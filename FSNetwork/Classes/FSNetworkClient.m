//
//  FSNetworkClient.m
//  AFNetworking
//
//  Created by wanqijian on 2019/4/1.
//

#import "FSNetworkClient.h"
#import "FSNetworkConfig.h"



@implementation FSNetworkClient

static NSDictionary *_clientDict;

static FSNetworkClient *_sharedClient = nil;

+ (instancetype)defaultClient {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FSNetworkConfig *config = [FSNetworkConfig defaultConfig];
        _sharedClient = [[FSNetworkClient alloc] initWithBaseURL:[NSURL URLWithString:config.host]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.name = FSNetworkDefalutClientName;
        _sharedClient.config = config;
    });
    return _sharedClient;
}

+ (void)addClientDictWithName:(NSString *)name client:(FSNetworkClient *)client {
    NSMutableDictionary *dicts;
    if (!_clientDict) {
        dicts = [NSMutableDictionary dictionary];
    } else {
        dicts = [_clientDict mutableCopy];
    }
    [dicts setValue:client forKey:name];
    _clientDict = [dicts copy];
}

+ (FSNetworkClient *)getClientWithName:(NSString *)name {
    return [_clientDict valueForKey:name];
}

- (instancetype)initWithName:(NSString *)name config:(FSNetworkConfig *)config  {
    self = [super initWithBaseURL:[NSURL URLWithString:config.host]];
    self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    self.name = name;
    self.config = config;
    
    return self;
}

- (void)handleRequestSerializer:(FSNetworkRequest *)request {
    switch (request.requestSerializer) {
        case FSRequestSerializerHttp:
        {
            AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
            requestSerializer.HTTPShouldHandleCookies = YES;
            self.requestSerializer = requestSerializer;
        }
            break;
        case FSRequestSerializerJson:
        {
            AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
            requestSerializer.HTTPShouldHandleCookies = YES;
            self.requestSerializer = requestSerializer;
        }
            break;
    }
}

- (void)handleResponseSerializer:(FSNetworkRequest *)request {
    switch (request.responseSerializer) {
        case FSResponseSerializerHttp:
        {
            self.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
            break;
        case FSResponseSerializerJson:
        {
            self.responseSerializer = [AFJSONResponseSerializer serializer];
        }
            break;
    }
}

- (FBLPromise *)handleStartRequest:(FSNetworkRequest *)request {
    
    FBLPromise *promis = [FBLPromise async:^(FBLPromiseFulfillBlock fulfill, FBLPromiseRejectBlock reject) {
        
        NSURLSessionDataTask *sessionDataTask = nil;

        switch (request.method) {
            case FSRequestGet:
            {
                sessionDataTask = [self GET:request.url parameters:request.parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    fulfill(responseObject);
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    reject(error);
                }];
            }
                break;
            case FSRequestPost:
            {
                sessionDataTask = [self POST:request.url parameters:request.parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    fulfill(responseObject);
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    reject(error);
                }];
            }
                break;
            case FSRequestPut:
            {
                sessionDataTask = [self PUT:request.url parameters:request.parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                    fulfill(responseObject);
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    reject(error);
                }];
            }
                break;
            case FSRequestHead:
            {
                sessionDataTask = [self HEAD:request.url parameters:request.parameters success:^(NSURLSessionDataTask *task) {
                    fulfill(nil);
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    reject(error);
                }];
                
            }
                break;
            case FSRequestPatch:
            {
                sessionDataTask = [self PATCH:request.url parameters:request.parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                    fulfill(responseObject);
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    reject(error);
                }];
            }
                break;
            case FSRequestDelete:
            {
                sessionDataTask = [self DELETE:request.url parameters:request.parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                    fulfill(responseObject);
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    reject(error);
                }];
            }
                break;
        }
    }];
    return promis;
}




@end
