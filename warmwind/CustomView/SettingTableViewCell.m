//
//  SettingTableViewCell.m
//  warmwind
//
//  Created by guiping on 17/2/27.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell{
    UIImageView *leftImageView;
    UIView *line;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setLeftImageName:(NSString *)leftImageName{
    _leftImageName = leftImageName;
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 标识图
    if (!leftImageView) {
        leftImageView = [[UIImageView alloc]init];
        //leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:leftImageView];
    }
    leftImageView.image = [UIImage imageNamed:leftImageName];
    float imgH = leftImageView.image.size.height;
    float imgW = leftImageView.image.size.width;

    leftImageView.frame = CGRectMake(20, (CGRectGetHeight(self.frame) - imgH)/2, imgW, imgH);

    
    // 右侧开关
    if (!_rightSwitch) {
        _rightSwitch = [[UISwitch alloc] init];
        [self.contentView addSubview:_rightSwitch];
    }
    [_rightSwitch setFrame:CGRectMake(self.bounds.size.width - 80, (CGRectGetHeight(self.frame) - 31)/2, 51, 31)];
    
    if (!line) {
        line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, self.bounds.size.width, 0.5)];
        line.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:line];
    }
}

@end
