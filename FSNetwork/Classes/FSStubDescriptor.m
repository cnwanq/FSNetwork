//
//  FSStubDescriptor.m
//  AFNetworking
//
//  Created by wanqijian on 2019/4/4.
//

#import "FSStubDescriptor.h"

@implementation FSStubDescriptor

+ (instancetype)stubDescriptorWithTestBlock:(FSStubsTestBlock)testBlock responseData:(NSData *)responseData {
    FSStubDescriptor *stub = [FSStubDescriptor new];
    stub.testBlock = testBlock;
    stub.reponseData = responseData;
    return stub;
}

@end
