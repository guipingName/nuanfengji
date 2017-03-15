//
//  CircleView.m
//  circle
//
//  Created by guiping on 17/2/22.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "CircleView.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface CircleView ()
{
    CAShapeLayer *_trackLayer;
    CAShapeLayer *_progressLayer;
    CAShapeLayer *_backLayer;
    CGFloat _lineWidth;
}
@end

@implementation CircleView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = POINT_Y(9);
        [self buildLayout];
        _newtimeLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _newtimeLabel.textColor = [UIColor whiteColor];
        _newtimeLabel.textAlignment = NSTextAlignmentCenter;
        _newtimeLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:_newtimeLabel];
    }
    return self;
}


-(void)buildLayout{
    float centerX = self.bounds.size.width / 2.0;
    float centerY = self.bounds.size.height / 2.0;
    //半径
    float radius = (self.bounds.size.width - _lineWidth) / 2.0;
    
    //创建路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(-0.5f * M_PI) endAngle:1.5f * M_PI clockwise:YES];
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius - POINT_Y(3) / 2 startAngle:(-0.5f * M_PI) endAngle:1.5f * M_PI clockwise:YES];
    
    //创建进度layer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [UIColor clearColor].CGColor;
    
    //指定path的渲染颜色
    _progressLayer.strokeColor  = [UIColor whiteColor].CGColor;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = _lineWidth;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 1;
    [self.layer addSublayer:_progressLayer];
    
    //添加背景圆环
    _backLayer = [CAShapeLayer layer];
    _backLayer.frame = self.bounds;
    _backLayer.fillColor =  [UIColor clearColor].CGColor;
    _backLayer.strokeColor = RGB(250, 74, 20).CGColor;
    _backLayer.lineWidth = POINT_Y(12);
    _backLayer.path = [path1 CGPath];
    [self.layer addSublayer:_backLayer];
}

-(void)setProgress:(float)progress{
    _progress = progress;
    _backLayer.strokeStart = progress;
    [_backLayer removeAllAnimations];
}


@end
