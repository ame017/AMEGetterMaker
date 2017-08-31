//
//  SourceEditorCommand.m
//  GetterMaker
//
//  Created by pc37 on 2017/8/30.
//  Copyright © 2017年 AME. All rights reserved.
//

#import "SourceEditorCommand.h"
#import "AMEGetterMaker.h"

@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
    NSLog(@"%@",invocation);
    
    if ([invocation.commandIdentifier hasSuffix:@"SourceEditorCommand"]){
        [[AMEGetterMaker shardMaker]makeGetter:invocation];
    }
    completionHandler(nil);
}

@end
