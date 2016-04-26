//
//  WebService+Chat.m
//  Diamond
//
//  Created by Pan on 15/7/21.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WebService+Chat.h"
#import "Buddy.h"
#import "Friend.h"
@implementation WebService (Chat)

- (void)searchBuddyWithPhoneNumber:(NSString *)phoneNumber completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"phoneNumber", nil];
    
    [self postWithMethodName:GET_USER_INFO_BY_PHONE_NUMBER data:postData success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                NSDictionary *dataDic = [JSON objectForKey:DATA];
                if (![dataDic isEqual:[NSNull null]])
                {
                    
                    Buddy *entity = [Buddy objectWithKeyValues:dataDic];
                    completion(YES,nil,entity);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSDictionary *objDict = [JSON objectForKey:DATA];
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![objDict isEqual:[NSNull null]])
                {
                    message = [objDict objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}


- (void)getFriendList:(NSString *)easeMobID completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:easeMobID,@"easemob", nil];
    
    [self postWithMethodName:GET_FRIENDS data:postData success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    [Friend setupReplacedKeyFromPropertyName:^NSDictionary *{return @{@"friendID" : @"id"};}];
                    NSArray *entities = [Friend objectArrayWithKeyValuesArray:dataDic];
                    completion(YES,nil,entities);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![dataDic isEqual:[NSNull null]])
                {
                    message = [dataDic objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)addFriend:(NSString *)friendEaseMobID myEaseMobID:(NSString *)myEaseMobID completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:myEaseMobID,@"user_easemob",
                                                                friendEaseMobID,@"friends_easemob",nil];
    
    [self postWithMethodName:ADD_FRIEND data:postData success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    //FIXME:后台传过来的数据出错了,多嵌套了一层Key 所以这里做一下特殊处理。
                    Buddy *entity = [Buddy objectWithKeyValues:[dataDic objectForKey:@"resultString"]];
                    completion(YES,nil,entity);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![dataDic isEqual:[NSNull null]])
                {
                    message = [dataDic objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}


- (void)deleteFriend:(NSString *)friendEaseMobID myEaseMobID:(NSString *)myEaseMobID completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:myEaseMobID,@"user_easemob",
                             friendEaseMobID,@"friends_easemob",nil];
    
    [self postWithMethodName:DELETE_FRIEND data:postData success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    NSString *message = [dataDic objectForKey:RESULT_MESSAGE];
                    completion(YES,nil,message);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![dataDic isEqual:[NSNull null]])
                {
                    message = [dataDic objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)getPhotoForUser:(NSString *)easemob completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:easemob,@"easemob",nil];
    
    [self postWithMethodName:GET_USER_PHOTO data:postData success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    Friend *entity = [Friend objectWithKeyValues:dataDic];
                    completion(YES,nil,entity);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![dataDic isEqual:[NSNull null]])
                {
                    message = [dataDic objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}


- (void)updateRemarkName:(NSString *)name friend:(NSString *)friendEaseMobID myEaseMobID:(NSString *)myEaseMobID completion:(DMCompletionBlock)completion;
{
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:myEaseMobID,@"user_easemob",
                             friendEaseMobID,@"friends_easemob",name,@"remarkname",nil];
    
    [self postWithMethodName:UPDATE_REMARK data:dataDic success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    NSString *message = @"更新成功";
                    completion(YES,nil,message);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![dataDic isEqual:[NSNull null]])
                {
                    message = [dataDic objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}
@end
