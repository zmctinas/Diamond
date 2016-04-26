//
//  RegisterModel.h
//  Diamond
//
//  Created by Leon Hu on 15/7/14.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "RegisterEntity.h"

@interface RegisterModel : BaseModel

/**
 *  手机注册
 *
 *  @param phone    手机号
 *  @param nick     昵称
 *  @param password 密码
 */
- (void)registerByMobile:(NSString *)phone
                nickName:(NSString *)nick
                password:(NSString *)password
                   image:(UIImage *)image;

@end
