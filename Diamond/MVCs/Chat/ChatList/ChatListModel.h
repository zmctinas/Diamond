//
//  ChatListModel.h
//  Diamond
//
//  Created by Pan on 15/7/15.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"

@interface ChatListModel : BaseModel


- (NSMutableArray *)loadDataSource;

/**
 *  删除数据库中的空会话
 */
- (void)removeEmptyConversationsFromDB;

/**
 *  最后得到消息的时间
 *
 *  @param conversation 会话对象
 *
 *  @return 最后得到消息的时间
 */
- (NSString *)lastMessageTimeByConversation:(EMConversation *)conversation;


/**
 *  获得未读消息的条数
 *
 *  @param conversation 会话对象
 *
 *  @return 未读消息的条数
 */
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation;


/**
 *  最后的一条消息是什么类型
 *
 *  @param conversation 会话对象
 *
 *  @return 消息类型，可能为：图片 语音 位置 视频。
 */
- (NSString *)subTitleMessageByConversation:(EMConversation *)conversation;

/**
 *  去服务器拉取conversation的头像
 *
 *  @param conversation 
 */
- (void)getImageURLForConversations:(NSArray *)conversations;

@end
