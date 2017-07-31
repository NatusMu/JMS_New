//
//  JMSData+CoreDataProperties.h
//  JMS_New
//
//  Created by 黄沐 on 2016/12/12.
//  Copyright © 2016年 Hm. All rights reserved.
//

#import "JMSData.h"

NS_ASSUME_NONNULL_BEGIN
@interface JMSData (CoreDataProperties)

@property (nonatomic) double orderValue;
@property (nullable,nonatomic,retain) NSString *city; //城市
@property (nullable,nonatomic,retain) NSString *searchTerm;//搜索条目
@property (nullable,nonatomic,retain) NSData *historyData;//历史搜索

@end
NS_ASSUME_NONNULL_END
