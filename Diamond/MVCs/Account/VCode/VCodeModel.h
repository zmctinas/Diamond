//
//  VCodeModel.h
//  Diamond
//
//  Created by Leon Hu on 15/7/14.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "VCodeEntity.h"

@interface VCodeModel : BaseModel

- (void)sendTo:(NSString *)mobile forget:(NSInteger)forget;

@end
