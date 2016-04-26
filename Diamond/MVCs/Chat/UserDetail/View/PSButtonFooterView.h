//
//  PSButtonFooterView.h
//  Diamond
//
//  Created by Pan on 15/7/21.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSButtonFooterDelegate <NSObject>

- (void)buttonFooterDidTouchButton:(UIButton *)button;

@end

@interface PSButtonFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, weak) id<PSButtonFooterDelegate> delegate;


@end
