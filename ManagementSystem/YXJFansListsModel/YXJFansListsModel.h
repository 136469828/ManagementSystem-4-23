//
//  YXJFansListsModel.h
//  多选
//
//  Created by yang on 16/6/21.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXJFansListsModel : NSObject
@property (nonatomic, copy) NSString *linkID;
@property (nonatomic, copy) NSString *m_nick;
@property (nonatomic, assign, getter=isChooseBtn) BOOL m_chooseBtn;
@end
