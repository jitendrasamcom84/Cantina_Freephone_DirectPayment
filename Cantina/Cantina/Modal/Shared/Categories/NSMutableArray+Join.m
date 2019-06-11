//
//  NSMutableArray+Join.m
//  FieldWork
//
//  Created by Samir Kha on 18/01/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+Join.h"

@implementation NSMutableArray (Join)

- (NSString *)joinWithDelimeter:(NSString *)delimeter {
    NSString *mstring = @"";
    NSString *tempDel = @"";
    for (NSString *str in self) {
        if (str == nil || str.length <= 0) {
            continue;
        }
        if ([str isEqualToString:@"\n"]) {
            mstring = [mstring stringByAppendingString:str];
            tempDel = @"";
            continue;
        }
        mstring = [mstring stringByAppendingString:tempDel];
        mstring = [mstring stringByAppendingString:str];
        tempDel = delimeter;
    }
    
    return mstring ;
}

@end
