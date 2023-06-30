//
//  ReachAbility.h
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/6/29.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

typedef enum: NSInteger {
    NotReachable = 0,
    ReachableWIFI,
    ReachableWWAN,
    Reachable2G,
    Reachable3G,
    Reachable4G
} NetworkStatus;

extern NSString * _Nullable kCNotification;

NS_ASSUME_NONNULL_BEGIN

@interface ReachAbility : NSObject
//Use to check the reachability of a given IP address.
+ (instancetype)reachAddress: (const struct sockaddr_in *)hostAddress;

//Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
+ (instancetype)reachForInternetConnection;

//Checks whether a local WiFi connection is available.
+ (instancetype)reachForLocalWIFI;

//Start listening for reachability notifications on the current run loop.
- (BOOL)startNotifier;
- (void)stopNotifier;

- (NetworkStatus) currentReachabilityStatus;

// * WWAN may be available, but not active until a connection has been established. WiFi may require a connection for VPN on Demand.
- (BOOL)connectionRequired;

@end

NS_ASSUME_NONNULL_END
