//
//  FSNetworkRequest.h
//  AFNetworking
//
//  Created by wanqijian on 2019/4/1.
//

#import <Foundation/Foundation.h>
#import "FSNetworkHeader.h"

NS_ASSUME_NONNULL_BEGIN


@interface FSNetworkRequest : NSObject

@property (nonatomic, strong) NSString *clientName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) FSRequestMethod method;
@property (nonatomic, assign) FSRequestSerializer requestSerializer;
@property (nonatomic, assign) FSResponseSerializer responseSerializer;

@property (nonatomic, strong) id parameters;
@property (nonatomic, strong, readonly) id responseObject;

- (FBLPromise *)request;

@end

NS_ASSUME_NONNULL_END
