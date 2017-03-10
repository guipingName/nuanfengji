//
//  ChangeLanguage.h
//  warmwind
//
//  Created by guiping on 17/3/3.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangeLanguage : NSObject


/**
 *  获取当前资源文件
 *
 *  @return NSBundle
 */
+(NSBundle *)bundle;

/**
 *  初始化语言文件
 *
 */
+(void)initUserLanguage;

/**
 *  获取应用当前语言
 *
 *  @return 当前语言 en英语 zh-Hans中文
 */
+(NSString *)userLanguage;

/**
 *  设置当前语言
 *
 */
+(void)setUserlanguage:(NSString *)language;

/**
 *  获取内容
 *
 *  @return key键对应的value
 */
+ (NSString *) getContentWithKey:(NSString *) key;
@end
