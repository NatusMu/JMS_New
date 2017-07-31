//
//  JMSHobbyModel.h
//  JMS_New
//
//  Created by 黄沐 on 08/06/2017.
//  Copyright © 2017 Hm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMSHobbyModel : NSObject

//图片地址
@property (nonatomic, copy)NSString *picture;

//名称
@property (nonatomic, copy)NSString *name;

//爱好的ID
@property (nonatomic, assign)NSInteger ID;

//判断是否被点击
@property (nonatomic,assign)BOOL isSelected;
@end
