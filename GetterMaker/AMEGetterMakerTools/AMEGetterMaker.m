//
//  AMEGetterMaker.m
//  AMEGetterMaker
//
//  Created by pc37 on 2017/8/30.
//  Copyright © 2017年 AME. All rights reserved.
//

#import "AMEGetterMaker.h"
#import "NSString+AMEGetterMaker.h"



static AMEGetterMaker * _ame_getter_maker;
@implementation AMEGetterMaker

+ (instancetype)shardMaker{
    @synchronized (self) {
        if (!_ame_getter_maker) {
            _ame_getter_maker = [AMEGetterMaker new];
        }
    }
    return _ame_getter_maker;
}

- (AMEGetterMakerType)typeJudgeWithString:(NSString *)string{
    //注释 或者Xib 或者不带var property的注释夹层
    if ([string hasSubString:@"//"] || [string hasSubString:@"/*"]|| [string hasSubString:@"*/"] || ([string hasSubString:@"IBOutlet"] && [string hasSubString:@"@"]) || (![string hasSubString:@"@property"] && ![string hasSubString:@"var"])) {
        return AMEGetterMakerTypeOther;
    }
    if ([string hasSubString:@"@property"]) {
        return AMEGetterMakerTypeObjc;
    }
    if([string hasSubString:@"var"]){
        //swift
        return AMEGetterMakerTypeSwift;
    }
    return AMEGetterMakerTypeOther;
}

- (NSMutableArray<NSString *> *)selectLinesWithStart:(NSInteger)startLine endLine:(NSInteger)endLine{
    NSMutableArray * selectLines = [NSMutableArray arrayWithCapacity:endLine-startLine];
    for (NSInteger i = startLine; i<=endLine ; i++) {
//        //去掉分号
//        NSString * string = [self.invocation.buffer.lines[i] stringByReplacingOccurrencesOfString:@";" withString:@""];
        
        [selectLines addObject:self.invocation.buffer.lines[i]];
    }
    return selectLines;
}


- (void)makeGetter:(XCSourceEditorCommandInvocation *)invocation{
    self.invocation = invocation;
    [self make];
}

- (void)make{
    for (XCSourceTextRange *range in self.invocation.buffer.selections) {
        //选中的起始行
        NSInteger startLine = range.start.line;
        //选中的起始列
        NSInteger endLine   = range.end.line;
        
        //遍历获取选中区域 获得选中区域的字符串数组
        NSMutableArray<NSString *> * selectLines = [self selectLinesWithStart:startLine endLine:endLine];
        
        //按行处理 如果是objc就丢到十八层地狱 如果是swift就地处斩😈
        for (int i = 0 ; i < selectLines.count ; i++) {
            NSString * string = selectLines[i];
            //排除空字符串
            if(string == nil||[string isEqualToString:@""]){
                continue;
            }
            AMEGetterMakerType type = [self typeJudgeWithString:string];
            //排除注释和xib
            if (type == AMEGetterMakerTypeOther) {
                continue;
            }
            NSString * getterResult =@"";
            //objc
            if (type == AMEGetterMakerTypeObjc) {
                getterResult = [self objc_formatGetter:string];
                //找end并写入
                NSInteger implementationEndLine = [self findEndLine:self.invocation.buffer.lines selectionEndLine:endLine];
                if (implementationEndLine <= 1) {
                    continue;
                }
                [self.invocation.buffer.lines insertObject:getterResult atIndex:implementationEndLine];
            }else{
                //swift
                getterResult = [self swift_formatGetter:string];
                if (!getterResult || [getterResult isEqualToString:@""]) {
                    continue;
                }
                //找距离startline最近的相同行(因为行号会变)
                NSInteger currentLine = [self findCurrentLine:self.invocation.buffer.lines selectionStartLine:startLine currentString:string];
                self.invocation.buffer.lines[currentLine] = @"";
                [self.invocation.buffer.lines insertObject:getterResult atIndex:currentLine];
            }
        }
    }
}

//输出的字符串_objc
- (NSString*)objc_formatGetter:(NSString*)sourceStr{
    NSString *myResult;
    //类名
    NSString * className = [sourceStr getStringWithOutSpaceBetweenString1:@")" string2:@"*"];
    NSLog(@"className--->%@",className);
    if ([className isEqualToString:@""]) {
        return @"";
    }
    //属性名
    NSString * uName = [sourceStr getStringWithOutSpaceBetweenString1:@"*" string2:@";"];
    if ([uName isEqualToString:@""]) {
        return @"";
    }
    NSLog(@"uName--->%@",uName);
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
    
    myResult = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",line1,line2,line3,line4,line5,line6,line7,line8,line9];
    
    return myResult;
}

//输出的字符串_swift
- (NSString*)swift_formatGetter:(NSString*)sourceStr{
    NSString *myResult = @"";
    //取类名 有等号或者有冒号
    NSString * className = @"";
    NSString * typeName = @"";
    if ([sourceStr hasSubString:@"="] && [sourceStr hasSubString:@"("]&& [sourceStr hasSubString:@")"]) {
        className = [sourceStr getStringWithOutSpaceBetweenString1:@"=" string2:@"("];
        if ([sourceStr hasSubString:@":"]) {
            typeName = [sourceStr getStringWithOutSpaceBetweenString1:@"var" string2:@":"];
        }else{
            typeName = [sourceStr getStringWithOutSpaceBetweenString1:@"var" string2:@"="];
        }
    }else if ([sourceStr hasSubString:@":"] && [sourceStr hasSubString:@"!"]){
        className = [sourceStr getStringWithOutSpaceBetweenString1:@":" string2:@"!"];
        typeName = [sourceStr getStringWithOutSpaceBetweenString1:@"var" string2:@":"];
    }else{
        NSLog(@"错误的格式或者对象");
        return nil;
    }
    NSLog(@"className----->%@",className);
    NSLog(@"typeName----->%@",typeName);
    if ([className isEqualToString:@""]) {
        return nil;
    }
    if ([typeName isEqualToString:@""]) {
        return nil;
    }
    NSString * line1 = [NSString stringWithFormat:@"\tlazy var %@ : %@ = {", typeName, className];
    NSString * line2 = [NSString stringWithFormat:@"\n\t\tlet object = %@()",className];
    NSString * line3 = [NSString stringWithFormat:@"\n\t\treturn object"];
    NSString * line4 = [NSString stringWithFormat:@"\n\t}()"];
    myResult = [NSString stringWithFormat:@"%@%@%@%@",line1,line2,line3,line4];
    NSLog(@"myResult---->%@",myResult);
    return myResult;
}

- (NSInteger)findEndLine:(NSArray<NSString *> *)lines selectionEndLine:(NSInteger)endLine{
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

- (NSInteger)findCurrentLine:(NSArray<NSString *> *)lines selectionStartLine:(NSInteger)startLine currentString:(NSString *)string{
    for (NSInteger i = startLine; i<lines.count; i++) {
        if ([lines[i] isEqualToString:string]) {
            return i;
        }
    }
    return 0;
}

@end
