//
//  GPButton.m
//  warmwind
//
//  Created by guiping on 17/2/28.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "GPButton.h"

@implementation GPButton


- (CGRect) imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake((self.bounds.size.width - 30) / 2, 0, 30, 30);
}


- (CGRect) titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 31, self.bounds.size.width, 20);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
