//
//  ShareSDKManager.h
//  Diamond
//
//  Created by Pan on 15/8/13.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>


@protocol PSShareSDKManager <NSObject>

- (void)didFinishShare;

@end

@interface PSShareSDKManager : NSObject<ISSShareViewDelegate>

+ (PSShareSDKManager *)sharedInstance;

// 分享商品/店铺
- (void)shareWithImageURL:(NSString *)imageUrl
              description:(NSString *)description
                   shopId:(NSNumber *)shopId
                    title:(NSString *)title;

@property (weak, nonatomic) id<PSShareSDKManager> delegate;

@property (nonatomic, copy) NSString *weixinCode;

@end
