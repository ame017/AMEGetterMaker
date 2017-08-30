//
//  AMEGetterMaker.h
//  AMEGetterMaker
//
//  Created by pc37 on 2017/8/30.
//  Copyright © 2017年 AME. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XcodeKit/XcodeKit.h>

@interface AMEGetterMaker : NSObject

+ (void)makeGetter:(XCSourceEditorCommandInvocation *)invocation;

@end
