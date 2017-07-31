//
//  JMSHobbyModel.m
//  JMS_New
//
//  Created by 黄沐 on 08/06/2017.
//  Copyright © 2017 Hm. All rights reserved.
//

#import "JMSHobbyModel.h"
#import "MJExtension.h"
@implementation JMSHobbyModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}
//重新判断equal
- (BOOL)isEqual:(JMSHobbyModel *)other
{
    if (self.ID == other.ID) {
        return YES;
    }
    return [super isEqual:other];
}
@end
