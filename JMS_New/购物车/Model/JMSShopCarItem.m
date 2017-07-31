//
//  JMSShopCarItem.m
//  JMS_New
//
//  Created by 黄沐 on 21/05/2017.
//  Copyright © 2017 Hm. All rights reserved.
//

#import "JMSShopCarItem.h"
@implementation JMSShopCarItem

-(CGFloat)cellHeight{
    if(_cellHeight) return _cellHeight;
    _cellHeight = [UIScreen mainScreen].bounds.size.height/8;
    return _cellHeight;
}
@end
