

#import "ChatViewController+Category.h"

@implementation ChatViewController (Category)
- (void)registerBecomeActive{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)didBecomeActive{
    [self reloadData];
}

@end
