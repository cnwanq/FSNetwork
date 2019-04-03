//
//  FSStubDescriptor.h
//  AFNetworking
//
//  Created by wanqijian on 2019/4/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^FSStubsTestBlock)(NSURLRequest *request);

@interface FSStubDescriptor : NSObject

@property (nonatomic, copy) FSStubsTestBlock testBlock;
@property (nonatomic, copy) NSData *reponseData;

+ (instancetype)stubDescriptorWithTestBlock:(FSStubsTestBlock)testBlock responseData:(NSData *)responseData;

@end


NS_ASSUME_NONNULL_END
