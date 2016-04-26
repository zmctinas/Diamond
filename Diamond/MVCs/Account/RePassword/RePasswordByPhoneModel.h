//
//  RePasswordByPhoneModel.h
//  Diamond
//
//  Created by Leon Hu on 15/7/22.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"

@interface RePasswordByPhoneModel : BaseModel

- (void)changePassword:(NSString *)newPassword phone:(NSString *)phone;

@end
