//
//  NSDate+Extentsion.m
//  FWModel
//
//  Created by SamirMAC on 11/12/15.
//  Copyright (c) 2015 SamirMAC. All rights reserved.
//

#import "NSDate+Extentsion.h"

@implementation NSDate (Extentsion)

- (BOOL) isSameDayAs:(NSDate *)date2
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    int self_date = [[dateFormat stringFromDate:self] intValue];
    int date2_date = [[dateFormat stringFromDate:date2] intValue];
    
    if (self_date == date2_date) {
        return YES;
    }
    return NO;
}

- (BOOL) isDays:(NSUInteger)days next:(NSDate *)date2
{
    int days1 = [self  timeIntervalSince1970] / 86400;
    int days2 = [date2 timeIntervalSince1970] / 86400;
    if (days1 == days2) {
        return false;
    }
    return (days1 <= days2 + days);
}

- (BOOL) isDays:(NSUInteger)days previous:(NSDate *)date2
{
    int days1 = [self  timeIntervalSince1970] / 86400;
    int days2 = [date2 timeIntervalSince1970] / 86400;
    if (days1 == days2) {
        return false;
    }
    return (days1 >= days2 - days);
}


+ (NSDate *)systemDate {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    NSString *dtStr = [dateFormatter stringFromDate:date];
    NSDate *dt = [dateFormatter dateFromString:dtStr];
    return dt;
}

+ (NSString *)systemDateWithFormatter:(NSString *)format AddingDay:(int)day{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval Hours = 60*60*24*day;
    NSDate *dateHoursAhead = [date dateByAddingTimeInterval:Hours];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    NSString *dtStr = [dateFormatter stringFromDate:dateHoursAhead];
    return dtStr;
}



+ (NSDate *)LocalTime {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *dtStr = [dateFormatter stringFromDate:date];
    NSDate *dt = [dateFormatter dateFromString:dtStr];
    return dt;
}

+ (NSDate *) date2 {
    NSDate* sourceDate = [NSDate dateWithTimeIntervalSinceNow:0];//0
                                                                 //NSLog(@"%@", sourceDate);
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    NSDate *todayDate = [NSDate date];
    NSTimeInterval now = [todayDate timeIntervalSince1970];
    if(interval < 0) interval = interval * -1;
    now = now - interval;
    NSDate* destinationDate = [NSDate dateWithTimeIntervalSince1970:now];
    NSDate *newDate = [destinationDate dateByAddingTimeInterval:-3600];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm a"];
    NSString *dtStr = [dateFormatter stringFromDate:newDate];
    NSDate *dt = [dateFormatter dateFromString:dtStr];
    
    return dt;
}

+ (NSDate *) date2With15MinutesInterval {
    NSDate* sourceDate = [NSDate dateWithTimeIntervalSinceNow:0];//0
                                                                 //NSLog(@"%@", sourceDate);
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    NSDate *todayDate = [NSDate date];
    NSTimeInterval now = [todayDate timeIntervalSince1970];
    
    now = now - interval;
    NSDate* destinationDate = [NSDate dateWithTimeIntervalSince1970:now];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents* components = [cal components: (NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitYear|
                                                     NSCalendarUnitMonth|
                                                     NSCalendarUnitDay|
                                                     NSCalendarUnitSecond) fromDate:destinationDate];
    
    int minute = (int)[components minute];
    int hour = (int)[components hour];
    do {
        minute++;
        if (minute == 60) {
            minute = 0;
            hour++;
        }
        if (minute % 15 ==0) {
            break;
        }
    } while (minute < 60);
    
    [components setHour:hour];
    [components setMinute:minute];
    
    destinationDate = [cal dateFromComponents:components];
    return destinationDate;
}

+ (NSDate*)dateJSONTransformer:(NSString*)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZZZ"];
    return [dateFormatter dateFromString:dateString];
}

+ (NSDate *)getDateFromJSONString:(NSString *)str {
    
    if([str rangeOfString:@"T"].location != NSNotFound){
        NSArray *arr = [str componentsSeparatedByString:@"T"];
        NSString *time = @"";
        if(arr!= nil){
            time =  [[arr objectAtIndex:1] substringToIndex:8];
            str = [NSString stringWithFormat:@"%@ %@", [arr objectAtIndex:0], time];
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:[NSDate date2]];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:destinationGMTOffset]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt = [dateFormatter dateFromString:str];
    
    return [dt changeTimeZoneToLocal];
    
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *df = [NSDateFormatter new];
    
    df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    df.dateFormat = format;
    
    return [df stringFromDate:self];
}

- (NSString *)stringLocalTimeWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:format];
    NSString *sdate = [formatter stringFromDate:[self changeTimeZoneToUtc]];
    return sdate;
}

- (NSString*) getJSONDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    NSString *dtStr = [dateFormatter stringFromDate:self];
    return dtStr;
}

- (int)dateCompareValue {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *dateStr = [dateFormatter stringFromDate:self];
    return [dateStr intValue];
}

- (NSDate*) changeTimeZoneToLocal
{
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:self];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self];
    
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSTimeInterval now = [self timeIntervalSince1970];
    //if(interval < 0) interval = interval * -1;
    now = now + interval;
    NSDate* destinationDate = [NSDate dateWithTimeIntervalSince1970:now];
    return destinationDate;
    
}

- (NSDate *)dateWithOutTime {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self];
    [comps setHour:00];
    [comps setMinute:00];
    [comps setSecond:00];
    [comps setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (NSDate*)changeTimeZoneToUtc {
    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

@end
