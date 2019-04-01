//
//  FSNetworkHeader.h
//  AFNetworking
//
//  Created by wanqijian on 2019/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const FSNetworkDefalutClientName;

extern NSInteger const FSNetworkDefaultTimeoutInterval;


typedef NS_ENUM(NSInteger, FSRequestMethod) {
    FSRequestGet = 0,
    FSRequestPost,
    FSRequestHead,
    FSRequestPut,
    FSRequestDelete,
    FSRequestPatch,
};

typedef NS_ENUM(NSInteger, FSRequestSerializer) {
    FSRequestSerializerHttp,
    FSRequestSerializerJson,
};

typedef NS_ENUM(NSInteger, FSResponseSerializer) {
    FSResponseSerializerHttp,
    FSResponseSerializerJson,
};




@interface FSNetworkHeader : NSObject

@end

NS_ASSUME_NONNULL_END
