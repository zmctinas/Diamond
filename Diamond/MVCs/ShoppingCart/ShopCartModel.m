//
//  ShopCartModel.m
//  Diamond
//
//  Created by Leon Hu on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ShopCartModel.h"
#import "WebService+ShopCart.h"
#import "OrderDetailEntity.h"
struct ShopCartTotal
{
    CGFloat   totalFee;
    NSInteger totalCount;
};
typedef struct ShopCartTotal ShopCartTotal;

@implementation ShopCartModel

#pragma mark - Public

- (void)getShopCart
{
    [self.webService getShopCart:[[UserSession sharedInstance] currentUser].easemob
                      completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             //更新一个数据，自动全选
             for (ShopCartEntity *entity in result)
             {
                 entity.isChecked = YES;
             }
             self.dataSource = result;
             [[NSNotificationCenter defaultCenter] postNotificationName:GET_SHOP_CART object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

- (void)updateShopCart:(BuyWareEntity *)entity count:(NSInteger)buyCount
{
    [self.webService updateShopCart:entity.buyWaresId
                           count:buyCount
                      completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             //更新一个数据，自动全选
             for (ShopCartEntity *entity in result)
             {
                 entity.isChecked = YES;
             }
             self.dataSource = result;

             [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_SHOP_CART object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

- (void)delBuyWare:(BuyWareEntity *)entity
{
    [self.webService delFromShopCart:entity.buyWaresId
                      completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (!isSuccess || message)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

- (void)addToShopCart:(NSInteger)typeId count:(NSInteger)buyCount
{
    [self.webService addShopCart:typeId
                         easemob:[[UserSession sharedInstance] currentUser].easemob
                           count:buyCount
                        completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:ADD_SHOP_CART object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}


- (void)shopCartEntityBeingSelectedAtIndex:(NSInteger)index
{
    //找到勾选了哪个Entity
    ShopCartEntity *shopCartEntity = [self.dataSource objectAtIndex:index];
    shopCartEntity.isChecked = !shopCartEntity.isChecked;
    
    //计算总价和总数量的变化
    [self calculate:shopCartEntity];
}

- (void)buyWareBeingSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    //找到勾选了哪个Entity
    ShopCartEntity *shopCartEntity = [self.dataSource objectAtIndex:indexPath.section];
    BuyWareEntity *entity = [shopCartEntity.list objectAtIndex:indexPath.row];
    entity.isChecked = !entity.isChecked;
    
    //计算总价和总数量的变化
    [self calculate:shopCartEntity];
}

- (OrderDetailEntity *)convertWithShopCart:(ShopCartEntity *)shopCart
{
    if (!shopCart)
    {
        return nil;
    }
    
    OrderDetailEntity *orderDetail = [[OrderDetailEntity alloc] init];
    orderDetail.buyer_easemob = [UserSession sharedInstance].currentUser.easemob;
    orderDetail.seller_easemob = shopCart.easemob;
    orderDetail.status = OrderStatusWaitCommit;
    orderDetail.count_no = @(shopCart.total_count);
    orderDetail.total_fee = shopCart.total_fee;
    orderDetail.shop_name = shopCart.shop_name;

    NSMutableArray *orderWares = [NSMutableArray array];
    for (BuyWareEntity *buyWare in shopCart.list)
    {
        if (buyWare.isChecked)
        {
            OrderWare *ware = [[OrderWare alloc] init];
            ware.goods_id = buyWare.goods_id;
            ware.goods_name = buyWare.goods_name;
            ware.goods_url = buyWare.goods_url;
            ware.nowprice = @(buyWare.accountPrice);
            ware.price = buyWare.price;
            ware.number = @(buyWare.count_no);
            ware.type_id = buyWare.type_id;
            ware.type_name = buyWare.type;
            if (buyWare.is_promotion)
            {
                ware.discount = @(buyWare.discount.doubleValue * 10);
            }
            else
            {
                ware.discount = @(10);
            }
            [orderWares addObject:ware];
        }
    }
    orderDetail.list = orderWares;
    return orderDetail;
}


#pragma mark - Private

- (void)calculate:(ShopCartEntity *)shopCartEntity
{
    ShopCartTotal total = [self calculateTotal:shopCartEntity];
    shopCartEntity.total_fee = @(total.totalFee);
    shopCartEntity.total_count = total.totalCount;
}

- (ShopCartTotal)calculateTotal:(ShopCartEntity *)entity
{
    ShopCartTotal total = {0.0 , 0};
    for (BuyWareEntity *buyWare in entity.list)
    {
        if (buyWare.isChecked)
        {
            total.totalFee += buyWare.accountPrice * buyWare.count_no;
            total.totalCount += buyWare.count_no;
        }
    }
    return total;
}

@end
