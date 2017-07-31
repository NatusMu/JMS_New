//
//  JMSShopCarCell.h
//  JMS_New
//
//  Created by 黄沐 on 21/05/2017.
//  Copyright © 2017 Hm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMSShopCarItem;
@interface JMSShopCarCell : UITableViewCell

// 购物车 属性
@property(strong,nonatomic)JMSShopCarItem *carItem;

// 商品选择按钮

@property (weak,nonatomic) IBOutlet UIButton *SelectButton;
@property (nonatomic,copy) void (^selectBtnClick)(BOOL isSelected);
@property (nonatomic,copy) void (^allSelectBtnClick)(BOOL isSelected);

#pragma mark -后续完成
// 商品魅族全选选择按钮
@property (weak,nonatomic) IBOutlet UIButton *AllSelectButton;
// 商品名
@property (weak,nonatomic) IBOutlet UIButton *Name;
// 商店编辑
@property (weak,nonatomic) IBOutlet UIButton *EditBtn;


@end
