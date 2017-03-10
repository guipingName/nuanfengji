//
//  SearchView.h
//  warmwind
//
//  Created by guiping on 17/3/8.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^GPBlock)();

@interface SearchView : UIView

@property (nonatomic, copy) GPBlock block;

@property (nonatomic, copy) NSString *title;

-(void) createHintViewWithBlock:(void (^)())block;

@end
