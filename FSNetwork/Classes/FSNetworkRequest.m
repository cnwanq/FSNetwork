//
//  FSNetworkRequest.m
//  AFNetworking
//
//  Created by wanqijian on 2019/4/1.
//

#import "FSNetworkRequest.h"
#import "FSNetworkClient.h"

@implementation FSNetworkRequest

- (instancetype)init{
    self = [super init];
    self.clientName = FSNetworkDefalutClientName;
    return self;
}


- (FBLPromise *)request {
    
    FSNetworkClient *client = [FSNetworkClient getClientWithName:self.clientName];
    if (!client) {
        client = [FSNetworkClient defaultClient];
    }
    
    [client handleRequestSerializer:self];
    [client handleRequestSerializer:self];
    
    return [client handleStartRequest:self];
}

@end
