//
//  FSURLProtocol.m
//  AFNetworking
//
//  Created by wanqijian on 2019/4/2.
//

#import "FSURLProtocol.h"

@implementation FSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (![request.URL.scheme isEqualToString:@"http"] &&
        ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    return YES;
}

@end
