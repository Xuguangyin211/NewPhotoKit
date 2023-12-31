//
//  ReachAbility.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/6/29.
//

#import "ReachAbility.h"
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <sys/socket.h>

#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>

NSString *kReachNotification = @"kReachNotifition";

NSString *kReachabilityChangedNotification = @"kNetworkReachabilityChangedNotification";

#pragma mark - Supporting functions

#define kShouldPrintReachabilityFlags 1

static void PrintReachabilityFlags(SCNetworkReachabilityFlags flags, const char* comment)
{
#if kShouldPrintReachabilityFlags
    NSLog(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n", (flags & kSCNetworkReachabilityFlagsIsWWAN) ? 'W' : '-', (flags & kSCNetworkReachabilityFlagsReachable) ? 'R' : '-', (flags & kSCNetworkReachabilityFlagsTransientConnection) ? 't' : '-', (flags & kSCNetworkReachabilityFlagsConnectionRequired) ? 'c' : '-', (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) ? 'C' : '-', (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-', (flags & kSCNetworkReachabilityFlagsConnectionOnDemand) ? 'D' : '-', (flags & kSCNetworkReachabilityFlagsIsLocalAddress) ? 'l' : '-', (flags & kSCNetworkReachabilityFlagsIsDirect) ? 'd' : '-', comment);
#endif
}

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#pragma unused (target, flags)
    NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
    NSCAssert([(__bridge NSObject*) info isKindOfClass: [ReachAbility class]], @"info was wrong class in ReachabilityCallback");

    ReachAbility* noteObject = (__bridge ReachAbility *)info;
    // Post a notification to notify the client that the network reachability changed.
    [[NSNotificationCenter defaultCenter] postNotificationName: kReachNotification object: noteObject];
}

#pragma mark - Reachability implementation

@implementation ReachAbility
{
    BOOL _alwaysReturnLocalWiFiStatus; //default is NO
    SCNetworkReachabilityRef _reachabilityRef;
}

+ (instancetype)reachabilityWithHostName:(NSString *)hostName
{
    ReachAbility* returnValue = NULL;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
    if (reachability != NULL)
    {
        returnValue= [[self alloc] init];
        if (returnValue != NULL)
        {
            returnValue->_reachabilityRef = reachability;
            returnValue->_alwaysReturnLocalWiFiStatus = NO;
        }
        else {
            CFRelease(reachability);
        }
    }
    return returnValue;
}

+ (instancetype)reachAddress:(const struct sockaddr_in *)hostAddress
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)hostAddress);

    ReachAbility* returnValue = NULL;

    if (reachability != NULL)
    {
        returnValue = [[self alloc] init];
        if (returnValue != NULL)
        {
            returnValue->_reachabilityRef = reachability;
            returnValue->_alwaysReturnLocalWiFiStatus = NO;
        }
        else {
            CFRelease(reachability);
        }
    }
    return returnValue;
}

+ (instancetype)reachForInternetConnection
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;

    return [self reachAddress:&zeroAddress];
}

+ (instancetype)reachForLocalWIFI
{
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;

    // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0.
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);

    ReachAbility* returnValue = [self reachAddress: &localWifiAddress];
    if (returnValue != NULL)
    {
        returnValue->_alwaysReturnLocalWiFiStatus = YES;
    }
    return returnValue;
}

#pragma mark - Start and stop notifier

- (BOOL)startNotifier
{
    BOOL returnValue = NO;
    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};

    if (SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context))
    {
        if (SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode))
        {
            returnValue = YES;
        }
    }
    return returnValue;
}


- (void)stopNotifier
{
    if (_reachabilityRef != NULL)
    {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}

- (void)dealloc
{
    [self stopNotifier];
    if (_reachabilityRef != NULL)
    {
        CFRelease(_reachabilityRef);
    }
}

#pragma mark - Network Flag Handling

- (NetworkStatus)localWiFiStatusForFlags:(SCNetworkReachabilityFlags)flags
{
    PrintReachabilityFlags(flags, "localWiFiStatusForFlags");
    NetworkStatus returnValue = NotReachable;

    if ((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect))
    {
        returnValue = ReachableWIFI;
    }
    
    return returnValue;
}

- (NetworkStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags
{
    PrintReachabilityFlags(flags, "networkStatusForFlags");
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        // The target host is not reachable.
        return NotReachable;
    }

    NetworkStatus returnValue = NotReachable;

    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        /*
         If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
         */
        returnValue = ReachableWIFI;
    }

    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
        (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        /*
         ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
         */

        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            /*
             ... and no [user] intervention is needed...
             */
            returnValue = ReachableWIFI;
        }
    }

    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            
            CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc] init];
            NSString * currentRadioAccessTechnology = info.serviceCurrentRadioAccessTechnology;
            if (currentRadioAccessTechnology)
            {
                if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE])
                {
                    returnValue = Reachable4G;
                }
                else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS])
                {
                    returnValue =  Reachable2G;
                }
                else
                {
                    returnValue =  Reachable3G;
                }
                return returnValue;
            }
        }

        if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection)
        {
            if((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired)
            {
                returnValue =  Reachable2G;
                return returnValue;
            }
            returnValue =  Reachable3G;
            return returnValue;
        }
        
        returnValue = ReachableWIFI;
    }
    return returnValue;
}


- (BOOL)connectionRequired
{
    NSAssert(_reachabilityRef != NULL, @"connectionRequired called with NULL reachabilityRef");
    SCNetworkReachabilityFlags flags;

    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
    {
        return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
    }

    return NO;
}


- (NetworkStatus)currentReachabilityStatus
{
    NSAssert(_reachabilityRef != NULL, @"currentNetworkStatus called with NULL SCNetworkReachabilityRef");
    NetworkStatus returnValue = NotReachable;
    SCNetworkReachabilityFlags flags;

    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
    {
        if (_alwaysReturnLocalWiFiStatus)
        {
            returnValue = [self localWiFiStatusForFlags:flags];
        }
        else
        {
            returnValue = [self networkStatusForFlags:flags];
        }
    }
    return returnValue;
}

@end
