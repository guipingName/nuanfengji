//
//  LeftVCTableViewCell.m
//  warmwind
//
//  Created by guiping on 17/2/28.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "LeftVCTableViewCell.h"

@implementation LeftVCTableViewCell{
    UIImageView *leftImageView;
    UIImageView *rightImageView;
    UILabel *titleLabel;
    UIView *lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!leftImageView) {
        leftImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:leftImageView];
    }
    leftImageView.image = [UIImage imageNamed:_imageName];
    float imgH = leftImageView.image.size.height;
    float imgW = leftImageView.image.size.width;
    leftImageView.frame = CGRectMake(myX(60), (CGRectGetHeight(self.frame) - imgH)/2, imgW, imgH);
    
    // 标题
    if (!titleLabel) {
        titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = GPColor(48, 48, 48, 1.0);
        [self.contentView addSubview:titleLabel];
    }
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    CGRect titleR = HSGetLabelRect(titleLabel.text, 0, 0, 1, 17);
    titleLabel.frame = CGRectMake(CGRectGetMaxX(leftImageView.frame) + myX(60), (CGRectGetHeight(self.frame) - titleR.size.height) / 2, titleR.size.width, titleR.size.height);
    
    if (!rightImageView) {
        rightImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:rightImageView];
    }
    rightImageView.image = [UIImage imageNamed:@"箭头"];
    float imgH1 = rightImageView.image.size.height;
    float imgW1 = rightImageView.image.size.width;
    rightImageView.frame = CGRectMake(self.bounds.size.width - imgW1 - myX(60), (CGRectGetHeight(self.frame) - imgH1) / 2, imgW1, imgH1);
    
    if (!lineView) {
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, self.bounds.size.width, 0.5)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:lineView];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
