//
//  NSString+AMEGetterMaker.m
//  AMEGetterMaker
//
//  Created by pc37 on 2017/8/31.
//  Copyright © 2017年 AME. All rights reserved.
//

#import "NSString+AMEGetterMaker.h"

@implementation NSString (AMEGetterMaker)
- (NSString *)getStringWithOutSpaceBetweenString1:(NSString *)string1 string2:(NSString *)string2{
    NSRange range=[self rangeOfString:string1];
    if(range.location==NSNotFound){
        NSLog(@"错误的格式或者对象");
        return @"";
    }
    NSString * tempString = [self substringFromIndex:(range.location + range.length)];
    range = [tempString rangeOfString:string2 options:NSBackwardsSearch];
    if(range.location==NSNotFound){
        NSLog(@"错误的格式或者对象");
        return @"";
    }
    tempString = [tempString substringToIndex:range.location];
    NSString * typeName = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return typeName;
}

- (NSString *)getStringWithOutSpaceBetweenString1:(NSString *)string1 options1:(NSStringCompareOptions)options1 string2:(NSString *)string2 options2:(NSStringCompareOptions)options2{
    NSRange range=[self rangeOfString:string1 options:options1];
    if(range.location==NSNotFound){
        NSLog(@"错误的格式或者对象");
        return @"";
    }
    NSString * tempString = [self substringFromIndex:(range.location + range.length)];
    range = [tempString rangeOfString:string2 options:options2];
    if(range.location==NSNotFound){
        NSLog(@"错误的格式或者对象");
        return @"";
    }
    tempString = [tempString substringToIndex:range.location];
    NSString * typeName = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return typeName;
}

- (BOOL)hasSubString:(NSString *)string{
    return [self rangeOfString:string].location != NSNotFound? YES: NO;
}
@end
