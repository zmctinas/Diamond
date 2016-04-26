//
//  WebService+User.h
//  Diamond
//
//  Created by Leon Hu on 15/8/4.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WebService.h"
#import "RequestEntity.h"
#import "WareResponseEntity.h"
@interface WebService (User)

- (void)updateUserInfo:(NSString *)easemob
                  name:(NSString *)name
                   sex:(NSInteger)sex
                images:(NSArray *)array
            completion:(DMCompletionBlock)completion;

- (void)updateUserInfo:(NSString *)easemob
              province:(NSString *)province
                  city:(NSString *)city
            completion:(DMCompletionBlock)completion;

/**
 *  获取店铺收藏
 *
 *  @param requestInfo 请求数据
 *  @param completion  完成回调
 */
- (void)fetchCollectedShops:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;

/**
 *  获取商品收藏
 *
 *  @param requestInfo 请求数据
 *  @param completion  完成回调
 */
- (void)fetchCollectedWares:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;

@end
