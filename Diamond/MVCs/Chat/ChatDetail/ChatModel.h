//
//  ChatModel.h
//  Diamond
//
//  Created by Pan on 15/7/23.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"

@protocol ChatModelDelegate <NSObject>

- (NSString *)avatarWithChatter:(NSString *)chatter;
- (NSString *)nickNameWithChatter:(NSString *)chatter;

@end

@interface ChatModel : BaseModel

@property (nonatomic, assign) id <ChatModelDelegate> delelgate;

@property (nonatomic ,strong) dispatch_queue_t messageQueue;

@property (strong, nonatomic) NSDate *chatTagDate;

@property (strong, nonatomic) EMConversation *conversation;//会话管理者

@property (strong, nonatomic) NSMutableArray *messages;


-(void)addMessage:(EMMessage *)message;

/**
 *  整理EMMessage,添加头像和nickName
 *
 *  @param message EMMessage对象
 *
 *  @return 返回的数组中都是MessageModel对象
 */
- (NSMutableArray *)formatMessage:(EMMessage *)message;

/**
 *  整理EMMessages数组,添加头像和nickName
 *
 *  @param message EMMessage对象
 *
 *  @return 返回的数组中都是MessageModel对象
 */
- (NSArray *)formatMessages:(NSArray *)messagesArray;

/**
 *  下载消息中的附件，如图片，语音等等
 *
 *  @param message EMMessage对象
 */
- (void)downloadMessageAttachments:(EMMessage *)message completion:(void (^)(EMMessage *aMessage, EMError *error))completion;

/**
 *  是否应该向服务器发送已读通知
 *
 *  @param message 消息
 *  @param read    已读
 *
 *  @return BOOL
 */
- (BOOL)shouldAckMessage:(EMMessage *)message read:(BOOL)read;

/**
 *  将Message标记为已读
 *
 *  @param messages
 */
- (void)markMessagesAsRead:(NSArray*)messages;


/**
 *  发送文本消息
 *
 *  @param textMessage 
 */
- (void)sendTextMessage:(NSString *)textMessage;

/**
 *  发送图片
 *
 *  @param image image
 */
- (void)sendImageMessage:(UIImage *)image;

/**
 *  发送语音
 *
 *  @param voice
 */
- (void)sendAudioMessage:(EMChatVoice *)voice;

/**
 *  发送一个已读回执给服务器
 *
 *  @param messages 
 */
- (void)sendHasReadResponseForMessages:(NSArray*)messages;


@end
