//
//  NSObject+YYmod.m
//  NewPhotoKit
//
//  Created by xuguangyin on 2023/7/11.
//

#import "NSObject+YYmod.h"

@implementation NSObject (YYmod)

- (NSString *)setEncode:(NSString *)str isPlus:(BOOL )a num: (int)b {
    NSMutableArray *outNum = [NSMutableArray new];
    NSMutableArray *outFa = [NSMutableArray new];
    for (NSInteger i = 0; i < str.length; i++) {
        NSRange r = {i, 1};
        NSString *strNow = [str substringWithRange:r];
        int ascChar = [strNow characterAtIndex:0];
        int final;
        if (a) {
            final = ascChar + b;
        } else {
            final = ascChar - b;
        }

        int m = (final - 32);
        int a = (m % 12);
        int c, d;
        c = m / 12 + 1;
        if (a == 0) {
            d = 0;
        } else {
            d = a;
        }

        NSString *ip;
        switch (d) {
            case 0:
                ip = @"A";
                break;
            case 1:
                ip = @"B";
                break;
            case 2:
                ip = @"C";
                break;
            case 3:
                ip = @"D";
                break;
            case 4:
                ip = @"E";
                break;
            case 5:
                ip = @"F";
                break;
            case 6:
                ip = @"G";
                break;
            case 7:
                ip = @"H";
                break;
            case 8:
                ip = @"I";
                break;
            case 9:
                ip = @"J";
                break;
            case 10:
                ip = @"K";
                break;
            case 11:
                ip = @"L";
                break;
        }
        NSString *ma = [NSString stringWithFormat:@"%d", c];
        NSString *cc = [ip stringByAppendingString:ma];
        [outFa addObject:cc];
        
        NSString *finStr = [NSString stringWithFormat:@"%d", final];
        [outNum addObject:finStr];
    }

    NSString *gg = @"";
    for(NSInteger i = 0; i < outFa.count; i++) {
        gg = [gg stringByAppendingString:outFa[i]];
    }
    NSLog(@"%@", gg);
    return gg;
}

- (NSString *)getDecode:(NSString *)str isPlus:(BOOL )a num: (int)b {
    NSMutableArray *intNum = [NSMutableArray new];
    for (NSInteger i = 0; i < (str.length/2); i++) {
        NSRange r = {i * 2, 2};
        NSString *strNow = [str substringWithRange:r];

        NSRange r1 = {0, 1}, r2 = {1, 1};
        NSString *a1 = [strNow substringWithRange:r1];
        NSString *a2 = [strNow substringWithRange:r2];
        int b1 = [a2 intValue];
        int c = 0;
        if ([a1 isEqual: @"A"]) {
            c = 32;
        } else if ([a1 isEqual: @"B"]) {
            c = 33;
        } else if ([a1 isEqual: @"C"]) {
            c = 34;
        } else if ([a1 isEqual: @"D"]) {
            c = 35;
        } else if ([a1 isEqual: @"E"]) {
            c = 36;
        } else if ([a1 isEqual: @"F"]) {
            c = 37;
        } else if ([a1 isEqual: @"G"]) {
            c = 38;
        } else if ([a1 isEqual: @"H"]) {
            c = 39;
        } else if ([a1 isEqual: @"I"]) {
            c = 40;
        } else if ([a1 isEqual: @"J"]) {
            c = 41;
        } else if ([a1 isEqual: @"K"]) {
            c = 42;
        } else if ([a1 isEqual: @"L"]) {
            c = 43;
        }
        int finC = c + (b1 - 1) * 12;

        if (a) {
            finC = finC - b;
        } else {
            finC = finC + b;
        }
        NSString *chrS = [NSString stringWithFormat:@"%c", finC];
        [intNum addObject:chrS];
    }

    NSString *strF = @"";
    for(NSInteger i = 0; i < intNum.count; i++) {
        strF = [strF stringByAppendingString:intNum[i]];
    }
    NSLog(@"%@", strF);
    return strF;
}

@end
