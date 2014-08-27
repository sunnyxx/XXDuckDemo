//
//  XXAppDelegate.m
//  XXDuckDemo
//
//  Created by sunnyxx on 14-8-27.
//  Copyright (c) 2014年 sunnyxx. All rights reserved.
//

#import "XXAppDelegate.h"
#import "XXDuckEntity.h"
#import "XXUserEntity.h"
#import "XXDIProxy.h"
#import "XXTestDIProtocolsAndImps.h"

@implementation XXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self demoJsonEntity];
    [self demoDependencyInjection];
    return YES;
}

- (void)demoJsonEntity
{
    NSString *json = @"{\"name\": \"sunnyxx\", \"sex\": \"boy\", \"age\": 24}";
    id<XXDuckEntity, XXUserEntity> entity= XXDuckEntityCreateWithJSON(json);
    
    NSLog(@"%@, %@, %@", entity.jsonString, entity.name, entity.age);

    entity.name = @"east north";
    entity.age = @100;
    
    NSLog(@"%@, %@", entity.name, entity.age);
}

- (void)demoDependencyInjection
{
    林志玲 *implementA = [林志玲 new];
    凤姐 *implementB = [凤姐 new];
    
    id<XXGirlFriend, XXDIProxy> proxy = XXDIProxyCreate();
    [proxy injectDependencyObject:implementA forProtocol:@protocol(XXGirlFriend)];
    [proxy kiss];
    [proxy injectDependencyObject:implementB forProtocol:@protocol(XXGirlFriend)];
    [proxy kiss];

}

@end
