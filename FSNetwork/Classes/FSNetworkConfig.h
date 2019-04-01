//
//  FSNetworkConfig.h
//  AFNetworking
//
//  Created by wanqijian on 2019/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSNetworkConfig : NSObject

@property (nonatomic, strong) NSArray<NSString *> *hosts;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) NSInteger timeoutInterval;


+ (instancetype)defaultConfig;

@end

NS_ASSUME_NONNULL_END
