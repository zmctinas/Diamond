//
//  WebService+Shop.h
//  Diamond
//
//  Created by Pan on 15/7/14.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WebService.h"
#import "Shop.h"
#import "RequestEntity.h"
#import "ShopResponseEntity.h"
#import "UpLicenseEntity.h"
#import "WaresEntity.h"
#import "EditShopEntity.h"
#import "SetUpEntity.h"

@interface WebService (Shop)


/**
 *  获取热门店铺
 *
 *  @param requestInfo 请求数据
 *  @param completion  完成回调
 */
- (void)fetchHotShops:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;

/**
 *  获取新开店铺
 *
 *  @param requestInfo 请求数据
 *  @param completion  完成回调
 */
- (void)fetchNewShops:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;

/**
 *  获取16个分类店铺数据
 *
 *  @param requestInfo 请求数据
 *  @param completion  完成回调
 */
- (void)fetchCategorShops:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;

/**
 *  获取店铺详情数据
 *
 *  @param requestInfo 请求数据
 *  @param completion  完成回调
 */
- (void)fetchShopDetailInfo:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;

/**
 *  收藏店铺
 *
 *  @param shop       店铺
 *  @param userID     用户ID
 *  @param completion 完成回调
 */
- (void)storeUpShop:(NSNumber *)shopID userID:(NSString *)userID completion:(DMCompletionBlock)completion;


/**
 *  删除店铺收藏
 *
 *  @param shop       店铺ID数组
 *  @param userID     用户ID
 *  @param completion 完成回调
 */
- (void)unStoreUpShop:(NSArray *)shopIDs userID:(NSString *)userID completion:(DMCompletionBlock)completion;

/**
 *  获取代忙活动相关数据，返回店铺列表
 *
 *  @param activityID 活动ID
 *  @param completion 完成回调
 */
- (void)getActivityMenber:(NSNumber *)activityID completion:(DMCompletionBlock)completion;

- (void)setSale:(NSInteger)shopId
        goodsId:(NSString *)goodsId
         isSale:(BOOL)isSale
     completion:(DMCompletionBlock)completion;

//#warning 下面这些参数有RequestEntity可以用。
//- (void)getShopInfo:(NSInteger)shopId
//            easemob:(NSString *)easemob
//                lat:(NSNumber *)lat
//                lng:(NSNumber *)lng
//         completion:(DMCompletionBlock)completion;

- (void)updateShopInfo:(EditShopEntity *)entity
            completion:(DMCompletionBlock)completion;
/**
 *  获取证书相关数据
 *
 *  @param easemob     easemob description
 *  @param completion <#completion description#>
 */
- (void)getLicense:(NSString *)easemob
        completion:(DMCompletionBlock)completion;
/**
 *  新增相关数据
 *
 *  @param entity     <#entity description#>
 *  @param completion <#completion description#>
 */
- (void)upLicense:(UpLicenseEntity *)entity
       completion:(DMCompletionBlock)completion;
/**
 *  编辑相关数据
 *
 *  @param entity     <#entity description#>
 *  @param completion <#completion description#>
 */
- (void)editLicense:(UpLicenseEntity *)entity
         completion:(DMCompletionBlock)completion;
/**
 *  开店
 *
 *  @param entity     <#entity description#>
 *  @param completion <#completion description#>
 */
- (void)setUp:(SetUpEntity *)entity
   completion:(DMCompletionBlock)completion;

@end
