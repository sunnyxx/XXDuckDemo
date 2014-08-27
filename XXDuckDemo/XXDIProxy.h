//
//  XXDIProxy.h
//  XXDuckDemo
//
//  Created by sunnyxx on 14-8-26.
//  Copyright (c) 2014年 sunnyxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XXDIProxy <NSObject>

- (void)injectDependencyObject:(id)object forProtocol:(Protocol *)protocol;

@end

/// To create a proxy object that can inject
extern id/*<XXDIProxy>*/ XXDIProxyCreate();
