//
//  WebService.m
//  DrivingOrder
//
//  Created by Pan on 15/5/19.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WebService.h"
#import "Reachability.h"
#import "Util.h"

NSString *const METHOD_NAME     = @"transCode";
NSString *const DATA            = @"data";
NSString *const RESULT_MESSAGE  = @"resultString";
NSString *const STATUS          = @"resultCode";

@implementation WebService

+ (instancetype)service
{
    return [[[self class]alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self)
    {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer.timeoutInterval = 15;
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}


- (void)postWithMethodName:(NSString *)methodName data:(id)data success:(void (^)(id))success failure:(void (^)(NSError *, id))failure
{
    if (!data)
    {
        data = [NSDictionary dictionary];
    }
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:methodName,METHOD_NAME,data,DATA,nil];
    [self postWithPath:PATH parameters:parameters token:nil success:success failure:failure];
    NSLog(@"%@",PATH);
}


- (void)postWithPath:(NSString *)path
         parameters:(NSDictionary *)parameters
              token:(NSString *)token
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error, id JSON))failure
{
    if ([self isReachable])
    {
        if (token)
        {
            [self.requestSerializer setValue:token forHTTPHeaderField:@"Authentication-Token"];
        }
        
        DLog(@"POST DATA: %@", [Util replaceUnicode:[parameters description]]);
        [self POST:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            if (httpResponse.statusCode == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    DLog(@"Received: %@ \n all above data received from method %@", [Util replaceUnicode:[responseObject description]],[parameters objectForKeyedSubscript:@"transCode"]);
                    
//                    
//                    NSData *data = responseObject;
//                    NSString *baocuo = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//                    DLog(@"ERROR DATA:%@  \n all above data received from method %@",baocuo,[parameters objectForKeyedSubscript:@"transCode"]);
                    
                        success(responseObject);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"服务器出错了,稍后试试" forKey:NSLocalizedFailureReasonErrorKey];
                    NSError *error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@%@",BASEURL,PATH] code:6000 userInfo:userInfo];
                    
                    
                    failure(error, responseObject);
                    
                });
                DLog(@"Received: %@ \n all above data received from method %@", [Util replaceUnicode:[responseObject description]],[parameters objectForKeyedSubscript:@"transCode"]);
                DLog(@"Received HTTP %ld", (long)httpResponse.statusCode);
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
                if (![userInfo objectForKey:NSLocalizedFailureReasonErrorKey])
                {
                    [userInfo setObject:@"服务器出错了,稍后试试" forKey:NSLocalizedFailureReasonErrorKey];
                }
                failure(error, nil);
            });
            
        }];
    }
    else
    {    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:@"没有连接网络" forKey:NSLocalizedFailureReasonErrorKey];
        NSError *newError = [NSError errorWithDomain:@"Network" code:1001 userInfo:userInfo];
        failure(newError, nil);
    }
}

- (BOOL)isReachable
{
    BOOL isReachable = [WebService service].reachabilityManager.reachable;
    if (!isReachable) {
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [reachability currentReachabilityStatus];
        if (networkStatus != NotReachable) {
            isReachable = YES;
        }
        else {
            isReachable = NO;
        }
    }
    return isReachable;
}
@end
