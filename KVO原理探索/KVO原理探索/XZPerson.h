//
//  XZPerson.h
//  KVO原理探索
//
//  Created by Alan on 4/29/20.
//  Copyright © 2020 zhaixingzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZPerson : NSObject{
    @public
    NSString *name;
}
@property (nonatomic, copy) NSString *nickName;


- (void)sayHello;
- (void)sayLove;

@end

NS_ASSUME_NONNULL_END
