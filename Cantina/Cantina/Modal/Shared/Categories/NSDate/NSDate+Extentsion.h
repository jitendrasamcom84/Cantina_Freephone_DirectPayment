//
//  NSDate+Extentsion.h
//  FWModel
//
//  Created by SamirMAC on 11/12/15.
//  Copyright (c) 2015 SamirMAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extentsion)

#define MMDDYYYY             @"MM/dd/yyyy"

+ (NSDate *) date2;
- (BOOL) isSameDayAs:(NSDate *)date2;

+ (NSString *)systemDateWithFormatter:(NSString *)format AddingDay:(int)day;

- (BOOL) isOneDayPrevious:(NSDate *)date2;
+ (NSDate*)dateJSONTransformer:(NSString*)dateString;
+ (NSDate *)getDateFromJSONString:(NSString *)str;
+ (NSDate *) date2With15MinutesInterval;
- (NSString*) getJSONDateString;
- (int)dateCompareValue;
+ (NSDate *)systemDate;
- (NSDate*) changeTimeZoneToLocal;
- (NSString *)stringWithFormat:(NSString *)format;
- (BOOL) isDays:(NSUInteger)days next:(NSDate *)date2;
- (BOOL) isDays:(NSUInteger)days previous:(NSDate *)date2;
- (NSDate *)dateWithOutTime;
- (NSDate*)changeTimeZoneToUtc;
- (NSString *)stringLocalTimeWithFormat:(NSString *)format;
+ (NSDate *)LocalTime ;

@end
