//
//  JMSShopCarItem.h
//  JMS_New
//
//  Created by 黄沐 on 21/05/2017.
//  Copyright © 2017 Hm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JMSShopCarItem : NSObject

// 购物车 商品标题
@property (nonatomic,copy) NSString *title;
// 购物车 商品价格
@property (nonatomic,copy) NSString *price;
// 购物车 商品 单个数量
@property (nonatomic,copy) NSString *single_num;
// 购物车 商品 已选
@property (nonatomic,copy) NSString *select;
// 购物车 商品 图片
@property (nonatomic,copy) NSString *image;

// 购物车 商品选择
@property (nonatomic,assign) BOOL isSelected;
// 购物车 商品全选
@property (nonatomic,assign) BOOL allSelected;

//cell行高
@property (nonatomic,assign) CGFloat cellHeight;

@end
