//
//  SetLanguageTableViewCell.m
//  warmwind
//
//  Created by guiping on 17/2/27.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "SetLanguageTableViewCell.h"

@implementation SetLanguageTableViewCell{
    UIImageView *leftImageView;
    UIImageView *rightImageView;
    UIView *lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!leftImageView) {
        leftImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:leftImageView];
    }
    leftImageView.image = [UIImage imageNamed:@"bimar语言"];
    leftImageView.frame = CGRectMake(POINT_X(60), (CGRectGetHeight(self.frame) - leftImageView.image.size.height)/2, leftImageView.image.size.width, leftImageView.image.size.height);
    
    if (!rightImageView) {
        rightImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:rightImageView];
    }
    NSString *name = nil;
    if ([imageName isEqualToString:@"bimar汉语"]) {
        name = @"bimar汉语";
    }
    else if ([imageName isEqualToString:@"bimar英语"]) {
        name = @"bimar英语";
    }
    else{
        name = @"bimar意大利语";
    }
    rightImageView.image = [UIImage imageNamed:name];
    rightImageView.frame = CGRectMake(self.bounds.size.width - 80, (CGRectGetHeight(self.frame) - rightImageView.image.size.height)/2, rightImageView.image.size.width, rightImageView.image.size.height);
    
    if (!lineView) {
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, self.bounds.size.width, 0.5)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:lineView];
    }
}

@end
