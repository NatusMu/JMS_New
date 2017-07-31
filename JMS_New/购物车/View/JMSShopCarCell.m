//
//  JMSShopCarCell.m
//  JMS_New
//
//  Created by 黄沐 on 21/05/2017.
//  Copyright © 2017 Hm. All rights reserved.
//

#import "JMSShopCarCell.h"
#import "JMSShopCarItem.h"
@interface JMSShopCarCell()

// 商品头像
@property (weak,nonatomic) IBOutlet UIImageView *CarImageView;
// 商品标题
@property (weak,nonatomic) IBOutlet UILabel *CarTitleLabel;
// 商品已选种类
@property (weak,nonatomic) IBOutlet UILabel *CarSelectType;
// 商品价格
@property (weak,nonatomic) IBOutlet UILabel *CarPriceLabel;
// 商品购买数量
@property (weak,nonatomic) IBOutlet UILabel *CarNumber;

@end
@implementation JMSShopCarCell

-(void)setCarItem:(JMSShopCarItem *)carItem{
    _carItem = carItem;
    self.CarImageView.image = [UIImage imageNamed:carItem.image];
    self.CarNumber.text = [NSString stringWithFormat:@"x %@",carItem.single_num];//单个数量
    self.CarPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f",[carItem.price floatValue]];//商品价格
    self.CarTitleLabel.text = carItem.title;//商品名称
    self.CarSelectType.text = carItem.select;//选中种类
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)isSelectedClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.selectBtnClick) {
        self.selectBtnClick(sender.selected);
    }
}

- (IBAction)allIsSelectedClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.allSelectBtnClick) {
        self.allSelectBtnClick(sender.selected);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
