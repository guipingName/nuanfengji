//
//  GPUtil.h
//  warmwind
//
//  Created by guiping on 17/3/1.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPUtil : NSObject

/**
 *  显示提示信息
 *
 *  @param superView 父视图
 *
 *  @param message 提示文本信息
 */
+(void)hintView:(UIView *)superView message:(NSString *) message;

/**
 *  显示提示信息
 *
 *  @param superView 父视图
 */
+(void) addBgImageViewWithImageName:(NSString *) imageName SuperView:(UIView *) superView;


/**
 *  按位数分离字符串(中间添加空格)
 *
 *  @param str 需要拆分的字符串
 *  @param splitNum 拆分的位数
 *
 *  @return 拆分后的字符串
 */
+ (NSString *) splitString:(NSString *) str splitNum:(NSInteger) splitNum;


/**
 *  获取当前时间Since1970
 *
 */
+ (NSInteger) nowTimeIntervalSince1970;

/**
 *  获取设备的SSID
 *
 */
+ (NSString *) SSID;

/**
 *  富文本
 *
 *  @param label 需要拆分的字符串
 *  @param searchString 查找的关键字
 *  @param firstSize 前半部分的字号
 *  @param lastSize 后半部分的字号
 *
 *  @return CGRect
 */
+ (CGRect) attributedLabel:(UILabel *) label String:(NSString *) searchString firstSize:(CGFloat) firstSize lastSize:(CGFloat) lastSize;

/**
 *  创建TextField
 *
 */
+ (UITextField *) createTextField;

/**
 *  十六进制颜色
 *
 *  @param hexValue 十六进制颜色
 *
 *  @return UIColor对象
 */
+ (UIColor *) colorWithHex:(int)hexValue;

/**
 *  十六进制颜色
 *
 *  @param hexValue 十六进制颜色
 *  @param alpha 透明度
 *
 *  @return UIColor对象
 */
+ (UIColor *) colorWithHex:(int)hexValue alpha:(CGFloat)alpha;



@end
