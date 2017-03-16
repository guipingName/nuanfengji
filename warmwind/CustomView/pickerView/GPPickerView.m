//
//  GPPickerView.m
//  sb
//
//  Created by guiping on 17/3/1.
//  Copyright © 2017年 WXP. All rights reserved.
//

#import "GPPickerView.h"
#import "PickerViewCell.h"

#define tempx(pix) pix * self.bounds.size.width / 1242
#define tempy(pix) pix * self.bounds.size.height / 969

@interface GPPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation GPPickerView{
    UIPickerView *myPickerView;
    NSArray *titleArray;
    NSArray *imageNamesArray;
    NSArray *returnStringArray;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.bounds.size.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return tempy(195);
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = UICOLOR_RGBA(209, 209, 209, 1.0);
        }
    }
    PickerViewCell *pickerCell = (PickerViewCell *)view;
    if (!pickerCell) {
        pickerCell = [[PickerViewCell alloc] initWithFrame:(CGRect){CGPointZero, [UIScreen mainScreen].bounds.size.width, 50}];
    }
    
    pickerCell.title = titleArray[row];
    pickerCell.imgName = imageNamesArray[row];
    
    return pickerCell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tempy(75), self.bounds.size.width, 30)];
        titleLabel.text = CURRENT_LANGUAGE(@"语言");
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = THEME_COLOR;
        [self addSubview:titleLabel];
        
        myPickerView = [[UIPickerView alloc]init];
        myPickerView.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame), self.bounds.size.width, self.bounds.size.height - CGRectGetMaxY(titleLabel.frame) - tempy(171));
        myPickerView.delegate = self;
        myPickerView.dataSource = self;
        [self addSubview:myPickerView];
        titleArray = @[@"English", @"简体中文", @"意大利语"];
        returnStringArray = @[@"en", @"zh-Hans", @"Italian"];
        imageNamesArray = @[@"bimar英语", @"bimar汉语", @"bimar意大利语"];
        
        NSArray *buttonNames = @[CURRENT_LANGUAGE(@"取消"), CURRENT_LANGUAGE(@"确定")];
        for (int i=0; i<2; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(self.bounds.size.width * i / 2, self.bounds.size.height - tempy(171), self.bounds.size.width / 2, tempy(171));
            [self addSubview:button];
            [button setTitle:buttonNames[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [button setTitleColor:UICOLOR_RGBA(250, 126, 20, 1.0) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.borderWidth = 1;
            button.layer.borderColor = UICOLOR_RGBA(209, 209, 209, 1.0).CGColor;
            button.tag = BTN_CANCEL_TAG + i;
        }
    }
    return self;
}

- (void) buttonClicked:(UIButton *) sender{
    [self removeFromSuperview];
    switch (sender.tag) {
        case BTN_CANCEL_TAG:
            break;
        case BTN_CHANGE_TAG:
        {
            NSInteger row=[myPickerView selectedRowInComponent:0];
            if (self.block) {
                self.block(returnStringArray[row]);
            }
            break;
        }
        default:
            break;
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
