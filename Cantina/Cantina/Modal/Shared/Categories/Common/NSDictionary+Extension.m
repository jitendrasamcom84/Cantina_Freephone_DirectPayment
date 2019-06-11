//
//  NSDictionary+Extension.m
//  FWModel
//
//  Created by SamirMAC on 11/21/15.
//  Copyright (c) 2015 SamirMAC. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

- (NSDictionary *)dictionaryByRemovingId{
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
    
    for (NSString *key in self) {
        const id object = [self objectForKey: key];
        if ([object isKindOfClass:[NSDictionary class]]) {
            [replaced setObject:[(NSDictionary*)object dictionaryByRemovingId] forKey:key];
        } else if ([key isEqualToString:@"id"]){
            [replaced removeObjectForKey:key];
        } else if ([object isKindOfClass:[NSArray class]]){
            if (object && [(NSArray*)object count] > 0) {
                id temp = [(NSArray*)object objectAtIndex:0];
                if (![temp isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
            }
            NSMutableArray *arr_temp = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in object) {
                NSDictionary *temp = [dict dictionaryByRemovingId];
                [arr_temp addObject:temp];
            }
            [replaced setObject:arr_temp forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:replaced];
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (id) initWithDestroy:(id)entity_id
{
    self = [[NSDictionary alloc] initWithObjectsAndKeys:entity_id, @"id",[NSNumber numberWithBool:YES], @"_destroy", nil];
    return self;
}
#pragma clang diagnostic pop


@end
