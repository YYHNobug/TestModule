//
//  NSHttp.h
//  LongTV
//
//  Created by app on 2018/5/17.
//  Copyright © 2018年 yahuiYu. All rights reserved.
//

#import <Foundation/Foundation.h>

// soap 消息头尾定义
//static const NSString *SOAP_HEAD = @"<?xml version='1.0' encoding='UTF-8'?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"default\" SOAP-ENV:encodingStyle=\"default\">\r\n\t<SOAP-ENV:Body>\r\n";
//static const NSString *SOAP_TAIL = @"\r\n\t</SOAP-ENV:Body>\r\n</SOAP-ENV:Envelope>\r\n";

typedef void(^NSHttpRequestCallback)(NSHTTPURLResponse *response, id responseObject, NSError * error);
typedef void (^httpCompletion) (NSData * data, NSHTTPURLResponse *response, NSError *error);

@interface NSHttpRequest : NSObject<NSURLSessionDelegate,NSURLSessionDataDelegate>

+ (NSHttpRequest *)sharedInstance;

/**
 Get请求 此方法走AFN

 @param path 请求地址
 @param timeout 超时时间
 @param completion 完成代码块
 */
+ (NSNumber *)GET:(NSString *)path timeout:(NSInteger)timeout completion:(NSHttpRequestCallback)completion;


/**
 Post 请求 此请求走AFN

 @param path 接口地址
 @param content 字符串型参数 &key=value型
 @param timeout 超时时间
 @param completion 完成代码块
 */
+ (NSNumber *)POST:(NSString *)path content:(NSString *)content timeout:(NSInteger)timeout completion:(NSHttpRequestCallback)completion;


/**
 GET方式请求数据 默认10s超时 AFN
 
 @param URLString 请求地址
 @param parameters 请求体参数
 @param completion 请求结果
 @return sessionId 可以作为取消参数请求使用 -1代表请求url存在问题
 */
+ (NSNumber *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(NSHttpRequestCallback)completion;

/**
 Post方式请求数据 带有10s默认超时   AFN
 
 @param URLString 请求地址
 @param parameters 请求体参数
 @param completion 请求结果
 @return sessionId 可以作为取消参数请求使用 -1代表请求url存在问题
 */
+ (NSNumber *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(NSHttpRequestCallback)completion;

/**
 GET方式请求数据 默认10s超时 AFN
 
 @param URLString 请求地址
 @param parameters 请求体参数
 @param headers 头参数
 @param completion 请求结果
 @return sessionId 可以作为取消参数请求使用 -1代表请求url存在问题
 */
+ (NSNumber *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters Headers:(NSDictionary *)headers completion:(NSHttpRequestCallback)completion;

/**
 Post方式请求数据 带有10s默认超时   AFN
 
 @param URLString 请求地址
 @param parameters 请求体参数
 @param headers 头参数
 @param completion 请求结果
 @return sessionId 可以作为取消参数请求使用 -1代表请求url存在问题
 */
+ (NSNumber *)POST:(NSString *)URLString parameters:(id)parameters Headers:(NSDictionary *)headers completion:(NSHttpRequestCallback)completion;

/**
 GET方式请求数据 自定义超时时间 AFN
 
 @param URLString 请求地址
 @param parameters 请求体参数
 @param headers 头参数
 @param timeout 超时时间  小于等于0按默认10s计算
 @param completion 请求结果
 @return sessionId 可以作为取消参数请求使用 -1代表请求url存在问题
 
 */

+ (NSNumber *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters Headers:(NSDictionary *)headers timeout:(NSTimeInterval)timeout completion:(NSHttpRequestCallback)completion;

/**
 POST方式请求数据 自定义超时时间 AFN
 
 @param URLString 请求地址
 @param parameters 请求体参数
 @param headers 头参数
 @param timeout 超时时间 小于等于0按默认10s计算
 @param completion 请求结果
 @return sessionId 可以作为取消参数请求使用 -1代表请求url存在问题
 */
+ (NSNumber *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters Headers:(NSDictionary *)headers timeout:(NSTimeInterval)timeout completion:(NSHttpRequestCallback)completion;

/**
 取消某个请求
 
 @param requestId GET或者POST请求返回的ID
 */
- (void)cancelRequestWithId:(NSNumber *)requestId;


/**
 *  Post 请求 此请求走系统方法 主要针对于xml类型body
 *
 *  @param path       接口地址
 *  @param content    body
 *  @param timeout    超时
 *  @param completion 完成代码块
 */
//+ (void)POST:(NSString *)path contentStr:(NSString *)content timeout:(NSTimeInterval)timeout completion:(httpCompletion)completion;

+ (void)POST:(NSString *)path contentStr:(id)content Headers:(NSDictionary *)headers timeout:(NSTimeInterval)timeout completion:(httpCompletion)completion;

@end
