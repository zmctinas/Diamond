//
//  ChatSettingViewController.m
//  Diamond
//
//  Created by Pan on 15/7/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ChatSettingViewController.h"
#import "Friend.h"
#import "UserInfo.h"

@interface ChatSettingViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *unReceiveMessageSwitch;

@end

@implementation ChatSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    [self setupSwitch];
    self.tableView.contentInset = UIEdgeInsetsMake(-35.5, 0, 0, 0);
}

- (void)setupSwitch
{
    NSMutableArray *blockList = [UserInfo info].quietEasemobs;
    if ([blockList containsObject:self.friendEntity.friends_easemob])
    {
        self.unReceiveMessageSwitch.on = YES;
    }
}

- (IBAction)touchUnreceiveMessageSwitch:(UISwitch *)sender
{
    NSMutableArray *blockList = [UserInfo info].quietEasemobs;
    if (![blockList count]) {
        blockList = [NSMutableArray array];
    }
    if (sender.isOn) {
        [blockList addObject:self.friendEntity.friends_easemob];
    } else {
        [blockList removeObject:self.friendEntity.friends_easemob];
    }
    [UserInfo info].quietEasemobs = blockList;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1)
    {
        EMConversation *conversation = [[[EaseMob sharedInstance] chatManager] conversationForChatter:self.friendEntity.friends_easemob conversationType:eConversationTypeChat];
        BOOL success = [conversation removeAllMessages];
        if (success)
        {
            if ([self.delegate respondsToSelector:@selector(didRemoveAllMessages)])
            {
                [self.delegate didRemoveAllMessages];
            }
            [self showtips:@"删除聊天记录成功"];
        }
        else
        {
            [self showtips:@"无法删除聊天记录,请稍后再试"];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
