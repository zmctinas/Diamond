//
//  ChatModel.m
//  Diamond
//
//  Created by Pan on 15/7/23.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ChatModel.h"
#import "NSDate+Category.h"
#import "MessageModel.h"
#import "MessageModelManager.h"
#import "ChatSendHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ChatModel ()



@end

@implementation ChatModel

#pragma mark - send message

- (BOOL)shouldAckMessage:(EMMessage *)message read:(BOOL)read
{
    NSString *account = [[EaseMob sharedInstance].chatManager loginInfo][kSDKUsername];
    if (message.messageType != eMessageTypeChat || message.isReadAcked || [account isEqualToString:message.from] || ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground))
    {
        return NO;
    }
    
    id<IEMMessageBody> body = [message.messageBodies firstObject];
    if (((body.messageBodyType == eMessageBodyType_Video) ||
         (body.messageBodyType == eMessageBodyType_Voice) ||
         (body.messageBodyType == eMessageBodyType_Image)) &&
        !read)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


- (NSMutableArray *)formatMessage:(EMMessage *)message
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
    NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
    if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
        [ret addObject:[createDate formattedTime]];
        self.chatTagDate = createDate;
    }
    
    MessageModel *model = [MessageModelManager modelWithMessage:message];
    if ([_delelgate respondsToSelector:@selector(nickNameWithChatter:)]) {
        NSString *showName = [_delelgate nickNameWithChatter:model.username];
        model.nickName = showName?showName:model.username;
    }else {
        model.nickName = model.username;
    }
    
    if ([_delelgate respondsToSelector:@selector(avatarWithChatter:)]) {
        model.headImageURL = [NSURL URLWithString:[_delelgate avatarWithChatter:model.username]];
    }
    
    if (model) {
        [ret addObject:model];
    }
    
    return ret;
}

- (NSArray *)formatMessages:(NSArray *)messagesArray
{
    NSMutableArray *formatArray = [[NSMutableArray alloc] init];
    if ([messagesArray count] > 0) {
        for (EMMessage *message in messagesArray) {
            NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
            if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
                [formatArray addObject:[createDate formattedTime]];
                self.chatTagDate = createDate;
            }
            
            MessageModel *model = [MessageModelManager modelWithMessage:message];
            if ([_delelgate respondsToSelector:@selector(nickNameWithChatter:)]) {
                NSString *showName = [_delelgate nickNameWithChatter:model.username];
                model.nickName = showName?showName:model.username;
            }else {
                model.nickName = model.username;
            }
            
            if ([_delelgate respondsToSelector:@selector(avatarWithChatter:)]) {
                model.headImageURL = [NSURL URLWithString:[_delelgate avatarWithChatter:model.username]];
            }
            
            if (model) {
                [formatArray addObject:model];
            }
        }
    }
    
    return formatArray;
}

//下载消息中的附件
- (void)downloadMessageAttachments:(EMMessage *)message completion:(void (^)(EMMessage *aMessage, EMError *error))completion
{

    
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    if ([messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)messageBody;
        if (imageBody.thumbnailDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([messageBody messageBodyType] == eMessageBodyType_Voice)
    {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)messageBody;
        if (voiceBody.attachmentDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载语音
            [[EaseMob sharedInstance].chatManager asyncFetchMessage:message progress:nil];
        }
    }
}


#pragma mark - send Message

-(void)sendTextMessage:(NSString *)textMessage
{
    EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:textMessage
                                                            toUsername:_conversation.chatter
                                                           messageType:eMessageTypeChat
                                                     requireEncryption:NO
                                                                   ext:nil];
    [self addMessage:tempMessage];
}

-(void)sendImageMessage:(UIImage *)image
{
    EMMessage *tempMessage = [ChatSendHelper sendImageMessageWithImage:image
                                                            toUsername:_conversation.chatter
                                                           messageType:eMessageTypeChat
                                                     requireEncryption:NO
                                                                   ext:nil];
    [self addMessage:tempMessage];
}

-(void)sendAudioMessage:(EMChatVoice *)voice
{
    EMMessage *tempMessage = [ChatSendHelper sendVoice:voice
                                            toUsername:_conversation.chatter
                                           messageType:eMessageTypeChat
                                     requireEncryption:NO ext:nil];
    [self addMessage:tempMessage];
}


- (void)sendHasReadResponseForMessages:(NSArray*)messages
{
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            [[EaseMob sharedInstance].chatManager sendReadAckForMessage:message];
        }
    });
}

- (void)markMessagesAsRead:(NSArray*)messages
{
    EMConversation *conversation = _conversation;
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            [conversation markMessageWithId:message.messageId asRead:YES];
        }
    });
}

-(void)addMessage:(EMMessage *)message
{
    [_messages addObject:message];
    dispatch_async(self.messageQueue, ^{
        NSArray *messages = [self formatMessage:message];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ADDED_NOTIFICATION object:messages];
        });
    });
}


- (NSDate *)chatTagDate
{
    if (_chatTagDate == nil) {
        _chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:0];
    }
    
    return _chatTagDate;
}

- (dispatch_queue_t)messageQueue
{
    if (!_messageQueue)
    {
        _messageQueue = dispatch_queue_create("easemob.com", NULL);
    }
    return _messageQueue;
}

- (NSMutableArray *)messages
{
    if (!_messages)
    {
        _messages = [NSMutableArray array];
    }
    return _messages;
}

@end
