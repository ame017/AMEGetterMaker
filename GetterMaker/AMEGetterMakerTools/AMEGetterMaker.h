//
//  AMEGetterMaker.h
//  AMEGetterMaker
//
//  Created by pc37 on 2017/8/30.
//  Copyright © 2017年 AME. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XcodeKit/XcodeKit.h>

#define NSLog(FORMAT, ...)                                                        \
fprintf(stderr, "(%s %s)<runClock:%ld> ->\n<%s : %d行> %s方法\n  %s\n -------\n",  \
__DATE__,                                                                         \
__TIME__,                                                                         \
clock(),                                                                          \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],        \
__LINE__,                                                                         \
__func__,                                                                         \
[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])                   \

typedef NS_ENUM(NSInteger, AMEGetterMakerType) {
    AMEGetterMakerTypeObjc,
    AMEGetterMakerTypeSwift,
    AMEGetterMakerTypeOther
};

@interface AMEGetterMaker : NSObject

@property (nonatomic, strong)XCSourceEditorCommandInvocation *invocation;

+ (instancetype)shardMaker;
- (void)makeGetter:(XCSourceEditorCommandInvocation *)invocation;

@end
