//
//  SearchView.m
//  warmwind
//
//  Created by guiping on 17/3/8.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "SearchView.h"

#define _fsw(obj)                obj.frame.size.width
#define _fsh(obj)                 obj.frame.size.height
#define _sw(obj)                 obj.size.width
#define _sh(obj)                  obj.size.height

@implementation SearchView{
    UIView *hintView;
    UIImageView *loadingImg;
    UILabel *label;
}

- (instancetype)init{
    if ([super init] == self) {
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    label.text = title;
    CGRect labelR = HSGetLabelRect(label.text, 0, 0, 1, 13);
//    hintView.frame = CGRectMake(0, 0, _sw(loadingImg.image) > _sw(labelR) ? _sw(loadingImg.image) : _sw(labelR), _sh(loadingImg.image) + _sh(labelR));
//    hintView.center = CGPointMake(_fsw(self)/2, _fsh(self)/2);
//    loadingImg.frame = CGRectMake((_fsw(hintView) - _sw(loadingImg.image))/2, 0, _sw(loadingImg.image), _sh(loadingImg.image));
//    label.frame = CGRectMake((_fsw(hintView) - _sw(labelR))/2,CGRectGetMaxY(loadingImg.frame), _sw(labelR), _sh(labelR));
    hintView.frame = CGRectMake(0, 0, _sw(loadingImg.image) > _sw(labelR) ? 50 : _sw(labelR), 50 + 10 + _sh(labelR));
    hintView.center = CGPointMake(_fsw(self) / 2, _fsh(self) / 5);
    loadingImg.frame = CGRectMake((_fsw(hintView) - 50)/2, 0, 50, 50);
    label.frame = CGRectMake((_fsw(hintView) - _sw(labelR))/2,CGRectGetMaxY(loadingImg.frame) + 10, _sw(labelR), _sh(labelR));
}

-(void) createHintViewWithBlock:(void (^)())block{
    self.block = block;
    if (!hintView) {
        hintView = [[UIView alloc] init];
        [self addSubview:hintView];
    }
    UIImage *img = [UIImage imageNamed:@"搜索设备"];
    if (!loadingImg) {
        loadingImg = [[UIImageView alloc]init];
        [hintView addSubview:loadingImg];
    }
    loadingImg.image = img;
    
    if (!label) {
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        [hintView addSubview:label];
    }
//    label.text = title;
//    CGRect labelR = HSGetLabelRect(label.text, 0, 0, 1, 13);
//    hintView.frame = CGRectMake(0, 0, _sw(loadingImg.image) > _sw(labelR) ? _sw(loadingImg.image) : _sw(labelR), _sh(loadingImg.image) + _sh(labelR));
//    hintView.center = CGPointMake(_fsw(self)/2, _fsh(self)/2);
//    loadingImg.frame = CGRectMake((_fsw(hintView) - _sw(loadingImg.image))/2, 0, _sw(loadingImg.image), _sh(loadingImg.image));
//    label.frame = CGRectMake((_fsw(hintView) - _sw(labelR))/2,CGRectGetMaxY(loadingImg.frame), _sw(labelR), _sh(labelR));
}

- (void) doTap:(UITapGestureRecognizer *) sender{
    if (self.block) {
        self.block();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
