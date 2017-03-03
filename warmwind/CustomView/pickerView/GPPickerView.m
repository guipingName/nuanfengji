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
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.bounds.size.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return tempy(195);
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = GPColor(209, 209, 209, 1.0);
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
        titleLabel.text = @"语言";
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = GPColor(250, 126, 20, 1.0);
        [self addSubview:titleLabel];
        
        myPickerView = [[UIPickerView alloc]init];
        myPickerView.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame), self.bounds.size.width, self.bounds.size.height - CGRectGetMaxY(titleLabel.frame) - tempy(171));
        myPickerView.delegate = self;
        myPickerView.dataSource = self;
        [self addSubview:myPickerView];
        titleArray = @[@"简体中文", @"English"];
        imageNamesArray = @[@"bimar汉语", @"bimar英语"];
        
        NSArray *buttonNames = @[@"取消", @"确定"];
        for (int i=0; i<2; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(self.bounds.size.width * i / 2, self.bounds.size.height - tempy(171), self.bounds.size.width / 2, tempy(171));
            [self addSubview:button];
            [button setTitle:buttonNames[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [button setTitleColor:GPColor(250, 126, 20, 1.0) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.borderWidth = 1;
            button.layer.borderColor = GPColor(209, 209, 209, 1.0).CGColor;
            button.tag = 485 + i;
        }
    }
    return self;
}

- (void) buttonClicked:(UIButton *) sender{
    [self removeFromSuperview];
    switch (sender.tag) {
        case 485:
            break;
        case 486:
        {
            NSInteger row=[myPickerView selectedRowInComponent:0];
            if (self.block) {
                self.block(titleArray[row]);
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
