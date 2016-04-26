//
//  ChatListModel.m
//  Diamond
//
//  Created by Pan on 15/7/15.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ChatListModel.h"
#import "NSDate+Category.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "EaseMob.h"
#import "WebService+Chat.h"

@implementation ChatListModel

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

// 得到最后消息时间
- (NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
- (NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = @"图片";
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                ret = @"语音";
            } break;
            case eMessageBodyType_Location: {
                ret = @"位置";
            } break;
            case eMessageBodyType_Video: {
                ret = @"视频";
            } break;
            default:
                break;
        }
    }
    
    return ret;
}


- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

- (void)getImageURLForConversations:(NSArray *)conversations;
{
    for (EMConversation *conversation in conversations)
    {
        //如果本地没有头像 那么去网络获取
        if (![conversation.ext objectForKeyedSubscript:FRIEND])
        {
            [self.webService getPhotoForUser:conversation.chatter completion:^(BOOL isSuccess, NSString *message, id result)
             {
                 if (isSuccess && !message)
                 {
                     conversation.ext = [NSDictionary dictionaryWithObjectsAndKeys:result,FRIEND, nil];
                     [[[EaseMob sharedInstance] chatManager] insertConversationToDB:conversation append2Chat:NO];
                     [[NSNotificationCenter defaultCenter] postNotificationName:HEAD_PHOTO_GETTED_NOTIFICATION object:nil];
                 }
                 else
                 {
//                     [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
                 }
             }];
        }
    }

}


@end
