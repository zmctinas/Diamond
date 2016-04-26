//
//  ChatSettingViewController.h
//  Diamond
//
//  Created by Pan on 15/7/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Friend.h"

@protocol ChatSettingViewControllerDelegate <NSObject>

- (void)didRemoveAllMessages;

@end

@interface ChatSettingViewController : BaseTableViewController

@property (nonatomic, strong) Friend *friendEntity;
@property (weak, nonatomic) id<ChatSettingViewControllerDelegate> delegate;


@end
