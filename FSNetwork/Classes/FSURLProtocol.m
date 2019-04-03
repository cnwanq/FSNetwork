//
//  FSURLProtocol.m
//  AFNetworking
//
//  Created by wanqijian on 2019/4/2.
//

#import "FSURLProtocol.h"
#import "FSNetworkClient.h"
#import "FSSessionConfiguration.h"
#import "FSStubDescriptor.h"

static NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";

@interface FSURLProtocol () <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSMutableArray *stubs;

@end

@implementation FSURLProtocol

+ (void)start {
    FSSessionConfiguration *sessionConfiguration = [FSSessionConfiguration defaultConfiguration];
    [NSURLProtocol registerClass:[FSURLProtocol class]];
    if (![sessionConfiguration isExchanged]) {
        [sessionConfiguration load];
    }
}

+ (void)end {
    FSSessionConfiguration *sessionConfiguration = [FSSessionConfiguration defaultConfiguration];
    [NSURLProtocol unregisterClass:[FSURLProtocol class]];
    if ([sessionConfiguration isExchanged]) {
        [sessionConfiguration unload];
    }
}

+ (instancetype)sharedInstance {
    static FSURLProtocol *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        _sharedInstance.stubs = [NSMutableArray array];
    });
    return _sharedInstance;
}


+ (void)stubRequestPassingTest:(FSStubsTestBlock)testBlock withStubResponseData:(NSData *)data {
    FSStubDescriptor *stub = [FSStubDescriptor stubDescriptorWithTestBlock:testBlock responseData:data];
    [FSURLProtocol.sharedInstance addStubDescriptor:stub];
}

+ (void)removeStub:(FSStubDescriptor *)stubDesc {
    [FSURLProtocol.sharedInstance removeStubDescriptor:stubDesc];
}

- (void)addStubDescriptor:(FSStubDescriptor *)stubDesc {
    if (stubDesc) {
        [self.stubs addObject:stubDesc];
    }
}

- (void)removeStubDescriptor:(FSStubDescriptor *)stubDesc {
    if (stubDesc && [self.stubs containsObject:stubDesc]) {
        [self.stubs removeObject:stubDesc];
    }
}


+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    //看看是否已经处理过了，防止无限循环 根据业务来截取
    if ([NSURLProtocol propertyForKey: URLProtocolHandledKey inRequest:request]) {
        return NO;
    }
    NSURL *url = request.URL;
    NSString *scheme = url.scheme;
    if ([scheme hasPrefix:@"http"]) {
        return YES;
    }
    return NO;
}

/**
 拦截到的网络请求，进行加工，返回加工后的网络请求
 */
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (id)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id <NSURLProtocolClient>)client {
    return [super initWithRequest:request cachedResponse:cachedResponse client:client];
}

//开始请求
- (void)startLoading
{
//    NSLog(@"***监听接口：%@", self.request.URL.absoluteString);

    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //标示该request已经处理过了，防止无限循环
    [NSURLProtocol setProperty:@(YES) forKey:URLProtocolHandledKey inRequest:mutableReqeust];
    
    //这个enableDebug随便根据自己的需求了，可以直接拦截到数据返回本地的模拟数据，进行测试
#if DEBUG
    FSStubDescriptor *_stub;
    NSArray *stubs = FSURLProtocol.sharedInstance.stubs;
    for (FSStubDescriptor *stub in stubs) {
        if (stub.testBlock && stub.testBlock(self.request)) {
            _stub = stub;
            break;
        }
    }
    if (_stub) {
        NSData *data = _stub.reponseData;
        NSString *str = @"测试数据";
        data = [str dataUsingEncoding:NSUTF8StringEncoding];

        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:mutableReqeust.URL
                                                            MIMEType:@"text/plain"
                                               expectedContentLength:data.length
                                                    textEncodingName:nil];
        [self.client URLProtocol:self
              didReceiveResponse:response
              cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
        return;
    }
#endif
    {
        //使用NSURLSession继续把request发送出去
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:mainQueue];
        NSURLSessionDataTask *task = [self.session dataTaskWithRequest:mutableReqeust];
        [task resume];
    }
    
}

+ (BOOL)passingTestRequset:(NSURLRequest *)request {
    FSStubDescriptor *_stub;
    NSArray *stubs = FSURLProtocol.sharedInstance.stubs;
    for (FSStubDescriptor *stub in stubs) {
        if (stub.testBlock && stub.testBlock(request)) {
            _stub = stub;
            break;
        }
    }
    if (_stub) {
        return YES;
    }
    return NO;
}

//结束请求
- (void)stopLoading {
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // 打印返回数据
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (dataStr) {
        NSLog(@"***截取数据***: %@", dataStr);
    }
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}


@end
