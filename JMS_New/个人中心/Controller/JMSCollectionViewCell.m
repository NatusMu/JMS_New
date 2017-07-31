//
//  JMSCollectionViewCell.m
//  JMS_New
//
//  Created by 黄沐 on 29/04/2017.
//  Copyright © 2017 Hm. All rights reserved.
//

#import "JMSCollectionViewCell.h"
#define Height [UIScreen mainScreen].bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width
@implementation JMSCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}
-(void)setupSubviews{
    self.imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Width/3,Height/6)];
    self.imageButton.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.imageButton];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Width/3, Height/6)];
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.font = [UIFont systemFontOfSize:20];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.textLabel];
}
@end
