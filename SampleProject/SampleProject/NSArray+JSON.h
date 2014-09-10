//
//  NSArray+JSON.h
//  SampleProject
//
//  Created by Federico Erostarbe on 04/09/14.
//  Copyright (c) 2014 Federico Erostarbe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JSON)

+ (NSArray *) arrayWithJSONString:(NSString *)string;

@end
