//
//  SearchModel.h
//  Diamond
//
//  Created by Pan on 15/8/5.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "RequestEntity.h"


@interface SearchModel : BaseModel

@property (nonatomic) SearchType searchType;
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  根据关键字搜索
 *
 *  @param keyWords
 */
- (void)searchWithKeyWords:(NSString *)keyWords;

- (void)giveMeNextData;
@end
