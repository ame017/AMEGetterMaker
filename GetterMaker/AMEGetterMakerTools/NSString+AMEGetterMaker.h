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
 取两个字符串中间的字符串

 @param string1 字符串左
 @param string2 字符串右
 @return 返回中间的字符串
 */
- (NSString *)getStringWithOutSpaceBetweenString1:(NSString *)string1 string2:(NSString *)string2;

/**
 判断字符串是否有某个字符串

 @param string 某个字符串
 @return 返回有或者没有
 */
- (BOOL)hasSubString:(NSString *)string;
@end
