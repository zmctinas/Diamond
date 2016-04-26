//
//  BaseModel.h
//  Diamond
//
//  Created by Pan on 15/7/13.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseMob.h"
#import "Macros.h"
#import "WebService.h"
#import "UserInfo.h"
#import "UserSession.h"
#import "PSLocationManager.h"

@interface BaseModel : NSObject

@property (nonatomic,strong) WebService *webService;


- (NSString *)priorDistrict;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
