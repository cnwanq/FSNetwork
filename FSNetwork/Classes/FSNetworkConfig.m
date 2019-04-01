//
//  FSNetworkConfig.m
//  AFNetworking
//
//  Created by wanqijian on 2019/4/1.
//

#import "FSNetworkConfig.h"
#import "FSNetworkHeader.h"

@implementation FSNetworkConfig

static FSNetworkConfig *_defaultConfig;
+ (instancetype)defaultConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultConfig = [FSNetworkConfig new];
    });
    return _defaultConfig;
}


- (instancetype)init {
    self = [super init];
    self.timeoutInterval = FSNetworkDefaultTimeoutInterval;
    return self;
}

@end
