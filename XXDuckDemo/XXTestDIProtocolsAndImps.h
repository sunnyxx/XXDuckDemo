//
//  XXTestDIProtocolsAndImps.h
//  XXDuckDemo
//
//  Created by sunnyxx on 14-8-27.
//  Copyright (c) 2014年 sunnyxx. All rights reserved.
//

#import <Foundation/Foundation.h>

// Protocol
@protocol XXGirlFriend <NSObject>

- (void)kiss;

@end


// Imp A
@interface 林志玲 : NSObject <XXGirlFriend>
@end

@implementation 林志玲

- (void)kiss
{
    NSLog(@"林志玲 kissed me");
}

@end

// Imp B
@interface 凤姐 : NSObject <XXGirlFriend>
@end

@implementation 凤姐

- (void)kiss
{
    NSLog(@"凤姐 kissed me");
}

@end

