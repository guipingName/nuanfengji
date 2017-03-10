//
//  PickerViewCell.m
//  sb
//
//  Created by guiping on 17/3/1.
//  Copyright © 2017年 WXP. All rights reserved.
//

#import "PickerViewCell.h"

@implementation PickerViewCell{
    UIImageView *image;
    UILabel *label;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        image = [[UIImageView alloc]init];
        image.frame = CGRectMake(frame.size.width / 3, frame.size.height/2-15, 30, 30);
        [self addSubview:image];
        label = [[UILabel alloc]init];
        [self addSubview:label];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    if ([title isEqualToString:@"English"]) {
        label.textColor = GPColor(102, 102, 102, 1.0);
        label.font = [UIFont systemFontOfSize:18];
    }
    else{
        label.textColor = GPColor(51, 51, 51, 1.0);
        label.font = [UIFont systemFontOfSize:20];
    }
    label.text = title;
    CGRect labelR = HSGetLabelRect(label.text, 0, 0, 1, 20);
    label.frame = CGRectMake(CGRectGetMaxX(image.frame) + GPPointX(18), (self.bounds.size.height - labelR.size.height) / 2, labelR.size.width, labelR.size.height);
}

- (void)setImgName:(NSString *)imgName{
    _imgName = imgName;
    UIImage *img = [UIImage imageNamed:imgName];
    image.image = img;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
