//
//  ChatViewController.h
//  Diamond
//
//  Created by Pan on 15/7/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"
#import "EMChatManagerDefs.h"
#import "ChatModel.h"

@interface ChatViewController : BaseViewController
@property (strong, nonatomic, readonly) NSString *chatter;
@property (nonatomic, strong) ChatModel *model;

- (instancetype)initWithChatter:(NSString *)chatter;

- (void)reloadData;

- (void)hideImagePicker;


@end
