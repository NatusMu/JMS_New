//
//  ToolClass.m
//  JMS_New
//
//  Created by 黄沐 on 2016/12/23.
//  Copyright © 2016年 Hm. All rights reserved.
//

#import "ToolClass.h"

@implementation ToolClass


+(BOOL)isLogin{
    NSString * str =[[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (str==nil) {
        return NO;
    }else{
        return YES;
    }
    
}
@end



