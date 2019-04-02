//
//  FSSessionConfiguration.h
//  AFNetworking
//
//  Created by wanqijian on 2019/4/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSSessionConfiguration : NSObject

//是否交换方法
@property (nonatomic,assign) BOOL isExchanged;

+ (FSSessionConfiguration *)defaultConfiguration;
// 交换掉NSURLSessionConfiguration的 protocolClasses方法
- (void)load;
// 还原初始化
- (void)unload;

@end

NS_ASSUME_NONNULL_END
