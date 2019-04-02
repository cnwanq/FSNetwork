//
//  FSSessionConfiguration.m
//  AFNetworking
//
//  Created by wanqijian on 2019/4/2.
//

#import "FSSessionConfiguration.h"
#import <objc/runtime.h>
#import "FSURLProtocol.h"

@implementation FSSessionConfiguration

+ (FSSessionConfiguration *)defaultConfiguration {
    static FSSessionConfiguration *staticConfiguration;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticConfiguration = [[FSSessionConfiguration alloc] init];
    });
    return staticConfiguration;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isExchanged = NO;
    }
    return self;
}

- (void)load {
    self.isExchanged=YES;
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:cls toClass:[self class]];
    
}

- (void)unload {
    self.isExchanged=NO;
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:cls toClass:[self class]];
}

- (void)swizzleSelector:(SEL)selector fromClass:(Class)original toClass:(Class)stub {
    Method originalMethod = class_getInstanceMethod(original, selector);
    Method stubMethod = class_getInstanceMethod(stub, selector);
    if (!originalMethod || !stubMethod) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NEURLSessionConfiguration."];
    }
    method_exchangeImplementations(originalMethod, stubMethod);
}

- (NSArray *)protocolClasses {
    // 如果还有其他的监控protocol，也可以在这里加进去
    return @[[FSURLProtocol class]];
}

@end
