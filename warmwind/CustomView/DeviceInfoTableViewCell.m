//
//  DeviceInfoTableViewCell.m
//  warmwind
//
//  Created by guiping on 17/3/10.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "DeviceInfoTableViewCell.h"

@implementation DeviceInfoTableViewCell{
    UILabel *lbTitle;
    UILabel *lbTitleInfo;
    UIView *lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setTitleInfo:(NSString *)titleInfo{
    _titleInfo = titleInfo;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!lbTitle) {
        lbTitle = [[UILabel alloc]init];
        lbTitle.font = [UIFont systemFontOfSize:17];
        lbTitle.textColor = [UIColor blackColor];
        [self.contentView addSubview:lbTitle];
    }
    lbTitle.text = _title;
    CGRect lbTitleR = HSGetLabelRect(lbTitle.text, 0, 0, 1, 17);
    lbTitle.frame = CGRectMake(GPPointX(60), (CGRectGetHeight(self.frame) - lbTitleR.size.height) / 2, lbTitleR.size.width, lbTitleR.size.height);
    
    if (!lbTitleInfo) {
        lbTitleInfo = [[UILabel alloc]init];
        lbTitleInfo.font = [UIFont systemFontOfSize:17];
        lbTitleInfo.textColor = GPColor(250, 126, 20, 1.0);
        [self.contentView addSubview:lbTitleInfo];
    }
    lbTitleInfo.text = titleInfo;
    lbTitleInfo.textAlignment = NSTextAlignmentRight;
    CGRect lbTitleInfoR = HSGetLabelRect(lbTitleInfo.text, CGRectGetWidth(self.frame) - lbTitleR.size.width - 10, 0, 1, 17);
    lbTitleInfo.frame = CGRectMake(self.bounds.size.width - lbTitleInfoR.size.width - GPPointX(60), (CGRectGetHeight(self.frame) - lbTitleInfoR.size.height) / 2, lbTitleInfoR.size.width, lbTitleInfoR.size.height);
    
    if (!lineView) {
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, self.bounds.size.width, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:lineView];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
