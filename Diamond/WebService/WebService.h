//
//  WebService.h
//  DrivingOrder
//
//  Created by Pan on 15/5/19.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "URLConstant.h"
#import "Macros.h"
#import "Util.h"
#import "MJExtension.h"

typedef void (^DMCompletionBlock)(BOOL isSuccess,NSString *message,id result);//Completion Block

typedef void (^OnBizSuccess)(id result);//Completion Block

typedef enum ResponseStatus {
    ResponseStatusFailed              = 0,
    ResponseStatusSuccess             = 1
}ResponseStatus;

/**
 *  Key which is define by server.
 */
extern NSString *const METHOD_NAME;
extern NSString *const DATA;
extern NSString *const RESULT_MESSAGE;
extern NSString *const STATUS;


@interface WebService : AFHTTPSessionManager

+ (instancetype)service;// Do not use sharedInstance;


/**
 *  post a request to server
 *
 *  @param methodName the request method name
 *  @param data       data
 *  @param success    when success goto this block
 *  @param failure    when failure goto this block
 */
- (void)postWithMethodName:(NSString *)methodName
                      data:(id)data
                   success:(void (^)(id JSON))success
                   failure:(void (^)(NSError *error, id JSON))failure;

@end
