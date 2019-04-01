//
//  FSViewController.m
//  FSNetwork
//
//  Created by wanqijian on 03/29/2019.
//  Copyright (c) 2019 wanqijian. All rights reserved.
//

#import "FSViewController.h"
#import <FBLPromises/FBLPromises.h>
#import <AFNetworking/AFNetworking.h>
#import <FSNetwork.h>

@interface FSViewController ()

@end

@implementation FSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    FSNetworkConfig *config = [FSNetworkConfig defaultConfig];
    config.host = @"http://www.baidu.com";
    
    FSNetworkRequest *request = [FSNetworkRequest new];
    request.url = @"/";
    request.method = FSRequestGet;
    
    [[[request request] then:^id _Nullable(id  _Nullable value) {
        NSLog(@"%@", value);
        return nil;
    }] catch:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error.userInfo);
    }];
    
//    [[request request] then:^id(id value) {
//        NSLog(@"%@", value);
//    } catch:^(NSError * error) {
//        NSLog(@"error %@", error.userInfo);
//    }];
    
//    [[[FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
//        if (2>3) {
//            fulfill(@"Hello");
//        } else {
//            reject([NSError new]);
//        }
//    }] then:^id _Nullable(id  _Nullable value) {
//        NSLog(@"%@", value);
//        return nil;
//    }] catch:^(NSError * _Nonnull error) {
//        NSLog(@"error:%@", error.userInfo);
//    }];
    
    
    
    
}


    
- (IBAction)tapBaiduButton:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //根据返回的二进制数据，生成字符串！NSUTF8StringEncoding：编码方式
        NSString *html = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"网络响应：response：%@",html);
    }];
    [dataTask resume];
}

    
    
@end
