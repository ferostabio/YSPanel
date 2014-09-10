//
//  NSArray+JSON.m
//  SampleProject
//
//  Created by Federico Erostarbe on 04/09/14.
//  Copyright (c) 2014 Federico Erostarbe. All rights reserved.
//

#import "NSArray+JSON.h"

@implementation NSArray (JSON)

+ (NSArray *) arrayWithJSONString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (array != nil && error == nil) {
        return array;
    } else {
        return nil;
    }
}

@end
