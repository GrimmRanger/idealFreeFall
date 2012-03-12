//
//  NSString+date.h
//  Live
//
//  Created by Frank Grimmer on 1/25/12.
//  Copyright (c) 2012 Me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(date)

+ (long long)millisecondsFromAPITimeString:(NSString *)time;
+ (NSString *)dateStringFromAPITimeString:(NSString *)time;
+ (NSString *)timeStringFromAPITimeString:(NSString *)time;
+ (NSString *)timeStringNow;

+ (NSDate *)dateFromAPITimeString:(NSString *)time;

@end
