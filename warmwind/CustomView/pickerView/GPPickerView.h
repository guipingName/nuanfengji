//
//  GPPickerView.h
//  sb
//
//  Created by guiping on 17/3/1.
//  Copyright © 2017年 WXP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GPBlock)(NSString *);
@interface GPPickerView : UIView

@property (nonatomic, copy) GPBlock block;

@end
