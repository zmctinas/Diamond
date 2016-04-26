//
//  PSTabbarItem.m
//  Diamond
//
//  Created by Pan on 15/12/20.
//  Copyright © 2015年 Pan. All rights reserved.
//

#import "PSTabbarItem.h"
#import "Macros.h"

@interface PSTabbarItem ()

@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;


@end

@implementation PSTabbarItem

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.badgeLabel.hidden = IS_NULL(self.badgeValue);
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    _badgeLabel.text = _badgeValue;
    _badgeLabel.hidden = IS_NULL(_badgeValue);
}
@end
