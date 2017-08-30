//
//  AMEGetterMaker.m
//  AMEGetterMaker
//
//  Created by pc37 on 2017/8/30.
//  Copyright © 2017年 AME. All rights reserved.
//

#import "AMEGetterMaker.h"
#import <AppKit/AppKit.h>

@implementation AMEGetterMaker


+ (void)makeGetter:(XCSourceEditorCommandInvocation *)invocation{
    for (XCSourceTextRange *range in invocation.buffer.selections) {
        //选中的起始行
        NSInteger startLine = range.start.line;
        //选中的起始列
        NSInteger endLine   = range.end.line;
        NSLog(@"%ld,%ld",startLine,endLine);
        //遍历获取选中区域 获得选中区域的字符串数组
        NSMutableArray<NSString *> * selectLines = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = startLine; i<=endLine ; i++) {
            //去掉分号
            NSString * string = [invocation.buffer.lines[i] stringByReplacingOccurrencesOfString:@";" withString:@""];
            
            [selectLines addObject:string];
        }
        if (selectLines.count == 0) {
            return;
        }
        //获取全部Getter
        NSString * getterResult =@"";
        for (NSString * string in selectLines) {
            //排除空字符串
            if(string == nil||[string isEqualToString:@""]){
                continue;
            }
            getterResult = [getterResult stringByAppendingString:[AMEGetterMaker formatGetter:string]];
        }
        NSLog(@"%@",getterResult);
        //找end
        NSInteger implementationEndLine = [AMEGetterMaker findEndLine:invocation.buffer.lines selectionEndLine:endLine];
        if (implementationEndLine <= 1) {
            return;
        }
//        NSInteger insertLine = implementationEndLine - 1;
        [invocation.buffer.lines insertObject:getterResult atIndex:implementationEndLine];
    }

}

//输出的字符串
+ (NSString*)formatGetter:(NSString*)sourceStr{
    NSString *myResult;
    NSRange rangLeft=[sourceStr rangeOfString:@")"];
    NSRange rangRight=[sourceStr rangeOfString:@"*"];
    
    if(rangLeft.location==NSNotFound||rangRight.location==NSNotFound)
    {
        NSLog(@"错误的格式或者对象");
        return @"";
    }
    //类型名
    NSRange typePoint=NSMakeRange(rangLeft.location+1, rangRight.location-rangLeft.location);
    NSString *typeName=[sourceStr substringWithRange:typePoint];
    typeName=[typeName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //class
    NSString *className = [typeName stringByReplacingOccurrencesOfString:@"*" withString:@""];
    className = [className stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //属性名
    NSRange unamePoint=NSMakeRange(rangRight.location+1, sourceStr.length-rangRight.location-2);
    NSString *uName=[sourceStr substringWithRange:unamePoint];
    uName=[uName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //_属性名
    NSString *underLineName=[NSString stringWithFormat:@"_%@",uName];
    
    
    NSString *line1 = [NSString stringWithFormat:@"\n- (%@ *)%@{",className,uName];
    NSString *line2 = [NSString stringWithFormat:@"\n    if(!%@){",underLineName];
    NSString *line3 = [NSString stringWithFormat:@"\n        %@ = ({",underLineName];
    NSString *line4 = [NSString stringWithFormat:@"\n            %@ * object = [[%@ alloc]init];",className,className];
    NSString *line5 = [NSString stringWithFormat:@"\n            object;"];
    NSString *line6 = [NSString stringWithFormat:@"\n       });"];
    NSString *line7 = [NSString stringWithFormat:@"\n    }"];
    NSString *line8 = [NSString stringWithFormat:@"\n    return %@;",underLineName];
    NSString *line9 = [NSString stringWithFormat:@"\n}"];
    
    myResult = [NSString stringWithFormat:@"\n%@%@%@%@%@%@%@%@%@",line1,line2,line3,line4,line5,line6,line7,line8,line9];
    
    return myResult;
}

+ (NSInteger)findEndLine:(NSArray<NSString *> *)lines selectionEndLine:(NSInteger)endLine{
    //找interface确认类名
    NSString * interfaceLine = @"";
    for (NSInteger i = endLine; i >= 1; i--) {
        if ([lines[i] rangeOfString:@"@interface"].location != NSNotFound) {
            interfaceLine = lines[i];
            break;
        }
    }
    NSRange rangeInterface = [interfaceLine rangeOfString:@"@interface"];
    NSRange rangeLeftBracket = [interfaceLine rangeOfString:@"("];
    NSRange classWithSpaceRange = NSMakeRange(rangeInterface.location + rangeInterface.length, interfaceLine.length - rangeInterface.length - rangeInterface.location - (interfaceLine.length - rangeLeftBracket.location));
    NSString * classWithSpace = [interfaceLine substringWithRange:classWithSpaceRange];
    NSLog(@"%@",classWithSpace);
    //类名
    NSString * classStr = [classWithSpace stringByReplacingOccurrencesOfString:@" " withString:@""];
    //根据类名找implementation
    BOOL findMark = NO;
    for (NSInteger i = endLine; i < lines.count; i++) {
        if ([lines[i] rangeOfString:@"@implementation"].location != NSNotFound &&
            [lines[i] rangeOfString:classStr].location != NSNotFound) {
            findMark = YES;
            continue;
        }
        if (findMark && [lines[i] rangeOfString:@"@end"].location != NSNotFound) {
            return i;
        }
    }
    return 0;
}

@end
