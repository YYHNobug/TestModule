//
//  ViewController.m
//  RequestDemo2
//
//  Created by xzc on 2020/8/29.
//  Copyright © 2020 xzc. All rights reserved.
//

#import "ViewController.h"
//#import <AFNetworking/AFNetworking.h>
#import "NSHttpRequest.h"

static NSString *hostUrl = @"http://api.aixueshi.top:5000";
@interface ViewController ()
@property(copy,nonatomic) NSString *token;
//@property (strong, nonatomic) AFHTTPSessionManager *HQManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dic = @{@"Account": @"15962119320", @"DeviceSystemVersion": @"13.6", @"Logitude": @(0.0), @"Latitude": @(0.0), @"Location": @"", @"Password": @"123456", @"DeviceType": @(1), @"DeviceName": @"iPad Pro (12.9-inch)", @"AppBuild": @"2020.08.23.01", @"DeviceUUID": @"F9CF5E5B-AD12-4256-8F72-AE40FEAA8D9E", @"AppVersion": @"1.2.4"};
    [self loadData:@"/Api/V2/Teacher/Account/Login" params:dic headers:nil];
    
    
//    //test
//    NSMutableDictionary *newBodyDic = [[NSMutableDictionary alloc]init];
//    NSString *path = @"https://api.aixueshi.top:5001/Api/V2/Teacher/Study/Search/V200828";
//    [newBodyDic setValue:@"4" forKey:@"Result"];
//    [newBodyDic setValue:@"0" forKey:@"Review"];
//    [newBodyDic setValue:@"39F730CD49A1DEAEDE76C6CFC06BAAF0" forKey:@"StudentID"];
//    [newBodyDic setValue:@"200" forKey:@"Count"];
//    [NSHttpRequest POST:path contentStr:newBodyDic Headers:nil timeout:20 completion:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
//        if (!error && response.statusCode == 200) {
//            NSLog(@"00000");
//            NSDictionary *results = nil;
//            NSInteger messageId = -1;
//            NSString *message = nil;
//            if (response.statusCode == 200 && data) {
//                results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                messageId = [[results objectForKey:@"resultCode"] integerValue];
//                message = [results objectForKey:@"description"];
//                NSLog(@"结果-----%@",results);
//            }
//        } else {
//            NSLog(@"111111");
//        }
//    }];
    
    
}
- (IBAction)btnAction1:(id)sender {
    //请求大数据量的接口
//    [self loadData:@"/Api/V2/Teacher/Study/Search/V200828" params:@{@"Count": @(200)} headers:@{@"token": self.token}];
    
    
    //test
    NSMutableDictionary *newBodyDic = [[NSMutableDictionary alloc]init];
    NSString *path = @"https://api.aixueshi.top:5001/Api/V2/Teacher/Study/Search/V200828";
    [newBodyDic setValue:@"4" forKey:@"Result"];
    [newBodyDic setValue:@"0" forKey:@"Review"];
    [newBodyDic setValue:@"39F730CD49A1DEAEDE76C6CFC06BAAF0" forKey:@"StudentID"];
    [newBodyDic setValue:@"200" forKey:@"Count"];
    [NSHttpRequest POST:path contentStr:newBodyDic Headers:nil timeout:20 completion:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
        if (!error && response.statusCode == 200) {
            NSLog(@"00000");
            NSDictionary *results = nil;
            NSInteger messageId = -1;
            NSString *message = nil;
            if (response.statusCode == 200 && data) {
                results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                messageId = [[results objectForKey:@"resultCode"] integerValue];
                message = [results objectForKey:@"description"];
                NSLog(@"结果-----%@",results);
            }
        } else {
            NSLog(@"111111");
        }
    }];
    
    
}
- (IBAction)btnAction2:(id)sender {
    
}

-(void)loadData:(NSString *)stringURL params:(NSDictionary *)parameters headers:headers {
    
    stringURL = [NSString stringWithFormat:@"%@%@",hostUrl,stringURL];
//    NSURLSessionDataTask *task = [self.HQManager POST:stringURL parameters:parameters headers:headers constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        NSDictionary *dict = dic[@"result"];
//        if ([dict isKindOfClass:[NSDictionary class]] && [dict.allKeys containsObject:@"token"]) {
//            self.token = dict[@"token"];
//        }
//        NSLog(@"%@",dic);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    
    
    
//    stringURL = [NSString stringWithFormat:@"%@%@",hostUrl,stringURL];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
//    request.HTTPMethod = @"POST";
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    NSData *JSONdata = nil;
//    if (parameters) {
//        JSONdata = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
//    }
//    [request setHTTPBody:JSONdata];
//    if (self.token.length) {
//         [request setValue:self.token forHTTPHeaderField:@"token"];
//    }
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) { //请求失败
////            failure(task, error);
//        } else {  //请求成功
//            
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSDictionary *dict = dic[@"result"];
//            if ([dict isKindOfClass:[NSDictionary class]] && [dict.allKeys containsObject:@"token"]) {
//                self.token = dict[@"token"];
//            }
//            NSLog(@"%@",dic);
//        }
//    }];
//    [task resume];
}

//-(AFHTTPSessionManager *)HQManager {
//    if (!_HQManager) {
//        _HQManager = [AFHTTPSessionManager manager];
//        
//        _HQManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        _HQManager.responseSerializer = [AFHTTPResponseSerializer serializer];
////        _HQManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
////        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
////        [manager setResponseSerializer:responseSerializer];
//        [_HQManager.requestSerializer setTimeoutInterval:5.0f];
//        _HQManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        _HQManager.securityPolicy.allowInvalidCertificates = YES;
//        [_HQManager.securityPolicy setValidatesDomainName:NO];
////        _HQManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
//    }
//    return _HQManager;
//}

@end
