//
//  FSNetworkClient.m
//  AFNetworking
//
//  Created by wanqijian on 2019/4/1.
//

#import "FSNetworkClient.h"
#import "FSNetworkConfig.h"
#import "FSURLProtocol.h"

@implementation FSNetworkClient

static NSDictionary *_clientDict;

static FSNetworkClient *_sharedClient = nil;

+ (instancetype)defaultClient {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FSNetworkConfig *config = [FSNetworkConfig defaultConfig];
//        _sharedClient = [[FSNetworkClient alloc] initWithBaseURL:[NSURL URLWithString:config.host]];
        _sharedClient = [[FSNetworkClient alloc] initWithBaseURL:[NSURL URLWithString:config.host] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.name = FSNetworkDefalutClientName;
        _sharedClient.config = config;
        [_sharedClient addAcceptableContextTypeTextHtml];
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

+ (NSArray<FSNetworkClient *> *)allClients {
    return [_clientDict allValues];
}

- (instancetype)initWithName:(NSString *)name config:(FSNetworkConfig *)config  {
    self = [super initWithBaseURL:[NSURL URLWithString:config.host] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    self.name = name;
    self.config = config;
    [self addAcceptableContextTypeTextHtml];
    
    return self;
}


- (void)addAcceptableContextTypeTextHtml {
    NSMutableSet *newContentTypes = [NSMutableSet set];
    // 添加我们需要的类型
    newContentTypes.set = self.responseSerializer.acceptableContentTypes;
    [newContentTypes addObject:@"text/html"];
    self.responseSerializer.acceptableContentTypes = newContentTypes;
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

        __weak typeof(self)weakSelf = self;
        switch (request.method) {
            case FSRequestGet:
            {
                sessionDataTask = [self GET:request.url parameters:request.parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    [weakSelf handleDataTask:task responseObject:responseObject fulfill:fulfill reject:reject];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    reject(error);
                }];
            }
                break;
            case FSRequestPost:
            {
                sessionDataTask = [self POST:request.url parameters:request.parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    [weakSelf handleDataTask:task responseObject:responseObject fulfill:fulfill reject:reject];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    reject(error);
                }];
            }
                break;
            case FSRequestPut:
            {
                sessionDataTask = [self PUT:request.url parameters:request.parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                    [weakSelf handleDataTask:task responseObject:responseObject fulfill:fulfill reject:reject];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    reject(error);
                }];
            }
                break;
            case FSRequestHead:
            {
                sessionDataTask = [self HEAD:request.url parameters:request.parameters success:^(NSURLSessionDataTask *task) {
                    [weakSelf handleDataTask:task responseObject:nil fulfill:fulfill reject:reject];
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
                    [weakSelf handleDataTask:task responseObject:responseObject fulfill:fulfill reject:reject];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    reject(error);
                }];
            }
                break;
        }
    }];
    return promis;
}

- (void)handleDataTask:(NSURLSessionDataTask *)task
                responseObject:(id)responseObject
                       fulfill:(FBLPromiseFulfillBlock)fulfill
                        reject:(FBLPromiseRejectBlock)reject {
    id data = responseObject;
#if DEBUG
    NSURLRequest *request = task.currentRequest;
    Class rClass = [responseObject class];
    
    if ([rClass isKindOfClass:[NSString class]]) {
        data = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
    }
    data = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
    
    if ([FSURLProtocol passingTestRequset:request]) {
        fulfill(data);
        return;
    }
#endif
    fulfill(data);
    return;
}



@end
