//
//  FSNetworkClient.h
//  AFNetworking
//
//  Created by wanqijian on 2019/4/1.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "FSNetworkConfig.h"
#import "FSNetworkRequest.h"
#import "FSNetworkHeader.h"


NS_ASSUME_NONNULL_BEGIN

@interface FSNetworkClient : AFHTTPSessionManager

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) FSNetworkConfig *config;

+ (instancetype)defaultClient;

+ (FSNetworkClient *)getClientWithName:(NSString *)name;

+ (void)addClientDictWithName:(NSString *)name
                       client:(FSNetworkClient *)client;

+ (NSArray<FSNetworkClient *> *)allClients;


- (instancetype)initWithName:(NSString *)name config:(FSNetworkConfig *)config;

- (void)handleRequestSerializer:(FSNetworkRequest *)request;
- (void)handleResponseSerializer:(FSNetworkRequest *)request;

- (FBLPromise *)handleStartRequest:(FSNetworkRequest *)request;

@end

NS_ASSUME_NONNULL_END
