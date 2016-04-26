

#import "MessageModel.h"

@implementation MessageModel

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        //code
    }
    
    return self;
}

- (void)dealloc{
    
}

- (NSString *)messageId
{
    return _message.messageId;
}

- (MessageDeliveryState)status
{
    return _message.deliveryState;
}

@end
