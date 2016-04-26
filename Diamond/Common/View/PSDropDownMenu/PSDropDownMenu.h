//
//  PSDropDownMenu.h
//  PSDropDownMenu
//
//  Created by Pan on 15/8/6.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSDropDownMenuDelegate <NSObject>

- (void)didTouchItem:(NSString *)itemTitle;

@end

@interface PSDropDownMenu : UIView

@property (nonatomic, assign) BOOL show;

@property (weak,nonatomic) id<PSDropDownMenuDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource;

- (void)showInView:(UIView *)view;

- (void)hide;

@end
