//
//  ChangeLanguage.m
//  warmwind
//
//  Created by guiping on 17/3/3.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "ChangeLanguage.h"



static NSBundle *bundle = nil;


@implementation ChangeLanguage

+ ( NSBundle * )bundle{
    
    return bundle;
}

//首次加载的时候先检测语言是否存在
+(void)initUserLanguage{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *currLanguage = [def valueForKey:CURRENTLANGUAGE];
    
    if(!currLanguage){
        NSArray *preferredLanguages = [NSLocale preferredLanguages];
        currLanguage = preferredLanguages[0];
        if ([currLanguage hasPrefix:@"en"]) {
            currLanguage = @"en";
        }
        else if ([currLanguage hasPrefix:@"zh"]) {
            currLanguage = CHINESE;
        }
        else {
            currLanguage = @"en";
        }
        [def setValue:currLanguage forKey:CURRENTLANGUAGE];
        [def synchronize];
    }
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:currLanguage ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}


+(NSString *)userLanguage{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:CURRENTLANGUAGE];
    return language;
}


+(void)setUserlanguage:(NSString *)language{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currLanguage = [userDefaults valueForKey:CURRENTLANGUAGE];
    if ([currLanguage isEqualToString:language]) {
        return;
    }
    [userDefaults setValue:language forKey:CURRENTLANGUAGE];
    [userDefaults synchronize];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
}

+ (NSString *) getContentWithKey:(NSString *) key{
    NSString *str = [[self bundle] localizedStringForKey:key value:nil table:@"Language"];
    if (str) {
        return str;
    }
    return key;
}

@end
