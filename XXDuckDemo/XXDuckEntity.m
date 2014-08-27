//
//  XXDuckEntity.m
//  XXDuckDemo
//
//  Created by sunnyxx on 14-8-16.
//  Copyright (c) 2014年 sunnyxx. All rights reserved.
//

#import "XXDuckEntity.h"


@interface XXDuckEntity : NSProxy <XXDuckEntity>
@property (nonatomic, strong) NSMutableDictionary *innerDictionary;
@end

@implementation XXDuckEntity
@synthesize jsonString = _jsonString;

- (instancetype)initWithJSONString:(NSString *)json
{
    if (json) {
        self->_jsonString = [json copy];
        NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            self.innerDictionary = [jsonObject mutableCopy];
        }
        return self;
    }
    return nil;
}

#pragma mark - Message Forwading

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    // Change method signature to NSMutableDictionary's
    // getter -> objectForKey:
    // setter -> setObject:forKey:

    SEL changedSelector = aSelector;
    
    if ([self propertyNameScanFromGetterSelector:aSelector]) {
        changedSelector = @selector(objectForKey:);
    }
    else if ([self propertyNameScanFromSetterSelector:aSelector]) {
        changedSelector = @selector(setObject:forKey:);
    }
    
    NSMethodSignature *sign = [[self.innerDictionary class] instanceMethodSignatureForSelector:changedSelector];

    return sign;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString *propertyName = nil;

    // Try getter
    propertyName = [self propertyNameScanFromGetterSelector:invocation.selector];
    if (propertyName) {
        invocation.selector = @selector(objectForKey:);
        [invocation setArgument:&propertyName atIndex:2]; // self, _cmd, key
        [invocation invokeWithTarget:self.innerDictionary];
        return;
    }
    
    // Try setter
    propertyName = [self propertyNameScanFromSetterSelector:invocation.selector];
    if (propertyName) {
        
        invocation.selector = @selector(setObject:forKey:);
        [invocation setArgument:&propertyName atIndex:3]; // self, _cmd, obj, key
        [invocation invokeWithTarget:self.innerDictionary];
        return;
    }
    
    [super forwardInvocation:invocation];
}

#pragma mark - Helpers

- (NSString *)propertyNameScanFromGetterSelector:(SEL)selector
{
    NSString *selectorName = NSStringFromSelector(selector);
    NSUInteger parameterCount = [[selectorName componentsSeparatedByString:@":"] count] - 1;
    if (parameterCount == 0) {
        return selectorName;
    }
    return nil;
}

- (NSString *)propertyNameScanFromSetterSelector:(SEL)selector
{
    NSString *selectorName = NSStringFromSelector(selector);
    NSUInteger parameterCount = [[selectorName componentsSeparatedByString:@":"] count] - 1;

    if ([selectorName hasPrefix:@"set"] && parameterCount == 1) {
        NSUInteger firstColonLocation = [selectorName rangeOfString:@":"].location;
        return [selectorName substringWithRange:NSMakeRange(3, firstColonLocation - 3)].lowercaseString;
    }
    return nil;
}

@end

id XXDuckEntityCreateWithJSON(NSString *json)
{
    return [[XXDuckEntity alloc] initWithJSONString:json];
}
