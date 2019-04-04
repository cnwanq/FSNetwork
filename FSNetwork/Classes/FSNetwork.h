//
//  FSNetwork.h
//  Pods
//
//  Created by wanqijian on 2019/4/1.
//

#ifndef FSNetwork_h
#define FSNetwork_h

#import "FSNetworkHeader.h"
#import "FSNetworkConfig.h"
#import "FSNetworkClient.h"
#import "FSNetworkRequest.h"
#import "FSURLProtocol.h"
#import "FSStubDescriptor.h"

#ifdef DEBUG
#define KSLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define KSLog(format, ...)
#endif

#endif /* FSNetwork_h */
