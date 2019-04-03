//
//  FSURLProtocol.h
//  AFNetworking
//
//  Created by wanqijian on 2019/4/2.
//

#import <Foundation/Foundation.h>
#import "FSNetworkHeader.h"
#import "FSStubDescriptor.h"


NS_ASSUME_NONNULL_BEGIN

@interface FSURLProtocol : NSURLProtocol

+ (void)start;

+ (void)end;

+ (instancetype)sharedInstance;

+ (void)stubRequestPassingTest:(FSStubsTestBlock)testBlock withStubResponseData:(NSData *)data;

+ (void)removeStub:(FSStubDescriptor *)stubDesc;

+ (BOOL)passingTestRequset:(NSURLRequest *)request;

@end

NS_ASSUME_NONNULL_END
