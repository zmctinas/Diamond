//
//  ShareSDKManager.m
//  Diamond
//
//  Created by Pan on 15/8/13.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PSShareSDKManager.h"
#import "Macros.h"
#import "Util.h"

@interface PSShareSDKManager () <ISSShareViewDelegate>


@end

@implementation PSShareSDKManager

static PSShareSDKManager *sharedInstance = nil;

+ (PSShareSDKManager *)sharedInstance
{
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        sharedInstance = [[PSShareSDKManager alloc] init];
    });
    
    return sharedInstance;
}

// 分享商品/店铺
- (void)shareWithImageURL:(NSString *)imageUrl
              description:(NSString *)description
                   shopId:(NSNumber *)shopId
                    title:(NSString *)title;
{
    description = IS_NULL(description) ? @"来自代忙iOS客户端" : description;
    title = IS_NULL(title) ? @"代忙" : title;
    NSString *url = [Util shareUrlWithShopId:shopId];
    id<ISSContent> publishContent = [ShareSDK content:description
                                       defaultContent:description
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title:title
                                                  url:url
                                          description:description
                                            mediaType:SSPublishContentMediaTypeText];
    
    [publishContent addWeixinSessionUnitWithType:@(SSPublishContentMediaTypeNews)
                                         content:description
                                           title:title
                                             url:url
                                           image:[ShareSDK imageWithUrl:imageUrl]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    [publishContent addWeixinTimelineUnitWithType:@(SSPublishContentMediaTypeNews)
                                          content:description
                                            title:title
                                              url:url
                                            image:[ShareSDK imageWithUrl:imageUrl]
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    NSUInteger index = description.length > 70 ? 50 : description.length;
    NSMutableString *content = [NSMutableString stringWithString:[description substringToIndex:index]];
    [content appendString:@"...[详情请戳]:"];
    [content appendString:url];
    [publishContent addSinaWeiboUnitWithContent:content image:[ShareSDK imageWithUrl:imageUrl]];
    
    //如果给过来的url是404的，那么image类型的QQ分享会失效，并且无法启动分享
    [publishContent addQQUnitWithType:@(SSPublishContentMediaTypeNews)
                              content:description
                                title:title
                                  url:url
                                image:[ShareSDK imageWithUrl:imageUrl]];
    [self showShareActionSheetWithContent:publishContent];
}



- (void)showShareActionSheetWithContent:(id<ISSContent>)publishContent
{
    //自定义标题栏相关委托
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"分享"
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:sharedInstance
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:[ShareSDK getShareListWithType:ShareTypeQQ,ShareTypeWeixiSession,ShareTypeQQSpace,ShareTypeSinaWeibo,ShareTypeWeixiTimeline, nil]
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                    message:@"分享成功!"
                                                                                   delegate:nil cancelButtonTitle:@"确定"
                                                                          otherButtonTitles:nil];
                                    [alert show];
                                    DLog(@"TEXT_ShARE_SUC : 分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                    message:@"啊哦...似乎不能分享它，请试试分享别的吧"
                                                                                   delegate:nil cancelButtonTitle:@"确定"
                                                                          otherButtonTitles:nil];
                                    [alert show];
                                    DLog(@"TEXT_ShARE_FAI : 分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (id<ISSContent>)view:(UIViewController *)viewController
    willPublishContent:(id<ISSContent>)content
             shareList:(NSArray *)shareList;
{
    [viewController.view endEditing:YES];
    return content;
}
@end
