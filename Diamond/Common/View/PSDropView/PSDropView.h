//
//  PSDropView.h
//  PSDropdownView
//
//  Created by Pan on 15/7/17.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PSDropViewSenderIdentifier)
{
    Other = 0,
    LeftBarButtonItem,
    RightBarButtonItem
};

@class PSDropView,NSIndexPath;

@protocol PSDropViewDelegate <NSObject>

- (void)dropView:(PSDropView *)dropView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface PSDropView : UIView

@property (nonatomic, weak) id<PSDropViewDelegate> delegate;

@property (nonatomic,getter=isShow) BOOL show;
/**
 *  必须用这个方法初始化
 *
 *  @param items 下拉菜单里面栏目数组 NSArray<PSDropItem>
 *
 *  @return PSDropView
 */
- (instancetype)initWithItems:(NSArray *)items;

/**
 *  调用这个方法显示下拉菜单
 *
 *  @param view       显示在哪个View里，必须传入的参数。通常为ViewController的Container View，也就是self.view
 *  @param identifier 标明消息发送者的身份，依靠这个身份来确定下拉菜单的位置。
 *  @param count      未查看的好友申请数量。
 *  @param sender     消息发送者
 */
- (void)showInView:(UIView *)view senderIdentifier:(PSDropViewSenderIdentifier)identifier noticeCount:(NSUInteger)count sender:(id)sender;


- (void)hide:(BOOL)animated;/**< 隐藏 */

@end



@interface PSDropItem : NSObject

@property (nonatomic, strong, readonly) UIImage *icon;
@property (nonatomic, strong, readonly) NSString *text;

/**
 *  必须使用这个方法初始化，属性是只读的
 *
 *  @param icon 图标
 *  @param text 文字描述
 *
 *  @return PSDropItem
 */
+ (instancetype)dropItemWithIcon:(UIImage *)icon text:(NSString *)text;

@end
