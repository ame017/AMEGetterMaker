//
//  NSString+AMEGetterMaker.h
//  AMEGetterMaker
//
//  Created by pc37 on 2017/8/31.
//  Copyright © 2017年 AME. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AMEGetterMaker)


/**
 获取字符串(首尾)

 @param string1 字符串1
 @param string2 字符串2
 @return 返回获取到的字符串
 */
- (NSString *)getStringWithOutSpaceBetweenString1:(NSString *)string1 string2:(NSString *)string2;

/**
 获取字符串

 @param string1 字符串1
 @param options1 字符串1设置
 @param string2 字符串2
 @param options2 字符串2设置
 @return 返回获取到的字符串
 */
- (NSString *)getStringWithOutSpaceBetweenString1:(NSString *)string1 options1:(NSStringCompareOptions)options1 string2:(NSString *)string2 options2:(NSStringCompareOptions)options2;

/**
 判断字符串是否有某个字符串

 @param string 某个字符串
 @return 返回有或者没有
 */
- (BOOL)hasSubString:(NSString *)string;
@end
