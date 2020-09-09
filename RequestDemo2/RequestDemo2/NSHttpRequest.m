//
//  NSHttp.m
//  LongTV
//
//  Created by app on 2018/5/17.
//  Copyright © 2018年 yahuiYu. All rights reserved.
//

#define kHttpSharedRequest [NSHttpRequest sharedInstance]

#import "NSHttpRequest.h"
#import <AFNetworking/AFNetworking.h>

#define SWDictionaryObject(x) [(x) isKindOfClass:[NSDictionary class]] || [(x) isKindOfClass:[NSMutableDictionary class]]
#define SWStringObject(x) [(x) isKindOfClass:[NSString class]] || [(x) isKindOfClass:[NSMutableString class]]

@interface NSHttpRequest ()

@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;

@end

@implementation NSHttpRequest

+ (NSHttpRequest *)sharedInstance {
    static NSHttpRequest *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NSHttpRequest alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        
        // 2.申明请求和返回的结果是JSON类型, 并设置请求头
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        
        [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
            NSURLProtectionSpace *protectionSpace = challenge.protectionSpace;
            if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                SecTrustRef serverTrust = protectionSpace.serverTrust;
                *credential = [NSURLCredential credentialForTrust:serverTrust];
                return NSURLSessionAuthChallengeUseCredential;
            } else {
                return NSURLSessionAuthChallengePerformDefaultHandling;
            }
        }];
    }
    return self;
}

- (NSMutableDictionary *)dispatchTable {
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPRequestSerializer *)requestSerializer {
    if (_requestSerializer == nil) {
        _requestSerializer = [AFHTTPRequestSerializer serializer];
        _requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _requestSerializer;
}

- (AFURLSessionManager *)sessionManager {
    if (!_sessionManager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        _sessionManager.completionQueue = dispatch_queue_create("ivs.http.request.completion.queue", DISPATCH_QUEUE_SERIAL);;
        _sessionManager.securityPolicy.allowInvalidCertificates= YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

+ (NSNumber *)GET:(NSString *)path timeout:(NSInteger)timeout completion:(NSHttpRequestCallback)completion {
    
    if (timeout <= 0) {
        timeout = 10;
    }
    return [[NSHttpRequest sharedInstance] dataTaskWithHTTPMethod:@"GET" URLString:path parameters:nil Headers:nil timeout:timeout completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (completion) {
            completion((NSHTTPURLResponse *)response,responseObject,error);
        }
    }];
}

+ (NSNumber *)POST:(NSString *)path content:(NSString *)content timeout:(NSInteger)timeout completion:(NSHttpRequestCallback)completion {
    if (timeout <= 0) {
        timeout = 10;
    }
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    if ([content rangeOfString:@"&"].length > 0) {
        NSArray *contentList = [content componentsSeparatedByString:@"&"];
        for (NSString *paramStr in contentList) {
            NSArray *paramList = [paramStr componentsSeparatedByString:@"="];
            if (paramList.count == 2) {
                [contentDict setValue:paramList[1] forKey:paramList[0]];
            }
            else if (paramList.count == 1) {
                [contentDict setValue:@"" forKey:paramList[0]];
            }
        }
    }
    else {
        NSArray *paramList = [content componentsSeparatedByString:@"="];
        if (paramList.count == 2) {
            [contentDict setValue:paramList[1] forKey:paramList[0]];
        }
        else if (paramList.count == 1) {
            [contentDict setValue:@"" forKey:paramList[0]];
        }
    }
    
    return [[NSHttpRequest sharedInstance] dataTaskWithHTTPMethod:@"POST" URLString:path parameters:contentDict Headers:nil timeout:timeout completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (completion) {
            completion((NSHTTPURLResponse *)response,responseObject,error);
        }
    }];
}

+ (NSNumber *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(NSHttpRequestCallback)completion
{
    return [NSHttpRequest GET:URLString parameters:parameters Headers:nil timeout:10 completion:completion];
}

+ (NSNumber *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(NSHttpRequestCallback)completion
{
    return [NSHttpRequest POST:URLString parameters:parameters Headers:nil timeout:10 completion:completion];
}

+ (NSNumber *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters Headers:(NSDictionary *)headers completion:(NSHttpRequestCallback)completion{
    return [kHttpSharedRequest dataTaskWithHTTPMethod:@"GET" URLString:URLString parameters:parameters Headers:headers timeout:10 completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (completion) {
            completion((NSHTTPURLResponse *)response,responseObject,error);
        }
    }];
}

+ (NSNumber *)POST:(NSString *)URLString parameters:(id)parameters Headers:(NSDictionary *)headers completion:(NSHttpRequestCallback)completion
{
    return [kHttpSharedRequest dataTaskWithHTTPMethod:@"POST" URLString:URLString parameters:parameters Headers:headers timeout:10 completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (completion) {
            completion((NSHTTPURLResponse *)response,responseObject,error);
        }
    }];
}
+ (NSNumber *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters Headers:(NSDictionary *)headers timeout:(NSTimeInterval)timeout completion:(NSHttpRequestCallback)completion
{
    if (timeout <= 0) {
        timeout = 10;
    }
    return [kHttpSharedRequest dataTaskWithHTTPMethod:@"GET" URLString:URLString parameters:parameters Headers:headers timeout:timeout completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (completion) {
            completion((NSHTTPURLResponse *)response,responseObject,error);
        }
    }];
}

+ (NSNumber *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters Headers:(NSDictionary *)headers timeout:(NSTimeInterval)timeout completion:(NSHttpRequestCallback)completion
{
    if (timeout <= 0) {
        timeout = 10;
    }
    return [kHttpSharedRequest dataTaskWithHTTPMethod:@"POST" URLString:URLString parameters:parameters Headers:headers timeout:timeout completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (completion) {
            completion((NSHTTPURLResponse *)response,responseObject,error);
        }
    }];
}


//+ (void)POST:(NSString *)path contentStr:(NSString *)content  timeout:(NSTimeInterval)timeout completion:(httpCompletion)completion
//{
//    NSMutableURLRequest *request = [NSHttpRequest requestWithMethod:@"POST" urlString:path param:content header:nil];
//    request.timeoutInterval = timeout;
//    [[NSHttpRequest sharedInstance] resumeRequest:request completion:completion];
//}

+ (void)POST:(NSString *)path contentStr:(id)content Headers:(NSDictionary *)headers timeout:(NSTimeInterval)timeout completion:(httpCompletion)completion{
    NSMutableURLRequest *request = [NSHttpRequest requestWithMethod:@"POST" urlString:path param:content header:headers];
    request.timeoutInterval = timeout;
    [[NSHttpRequest sharedInstance] resumeRequest:request completion:completion];
}

+ (NSMutableURLRequest *)requestWithMethod:(NSString *)method urlString:(NSString *)urlString param:(id)param header:(NSDictionary<NSString *, NSString *> *)header{
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if ([method isEqualToString:@"GET"]) {
        /*GET请求*/
        if (SWDictionaryObject(param)) {
            //如果参数类型是字典
            NSDictionary *paramDict = param;
            if (paramDict && paramDict.allKeys.count > 0) {
//                urlString = [NSHttpRequest urlPathByAppendUrl:urlString WithParam:paramDict];
            }
        }else if (SWStringObject(param)) {
            //如果参数类型是字符串
            NSString *paramStr = param;
            if ([paramStr rangeOfString:@"?"].length > 0) {
                urlString = [urlString stringByAppendingFormat:@"%@%@", urlString, paramStr];
            }else {
                urlString = [urlString stringByAppendingFormat:@"%@?%@", urlString, paramStr];
            }
        }else if (!param){
            
        }else {
            
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        request.HTTPMethod = method;
        [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
        if (header && [header count] > 0) {
            [header enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                [request setValue:key forHTTPHeaderField:obj];
            }];
        }
        
        return request;
    }else if ([method isEqualToString:@"POST"]) {
        /*POST请求*/
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        request.HTTPMethod = method;
        [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
        [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        if (header && [header count] > 0) {
            for (NSString *keyPath in header.allKeys) {
                NSString *value = header[keyPath];
                [request setValue:value forHTTPHeaderField:keyPath];
            }
        }
        if (SWDictionaryObject(param)) {
            //如果参数类型是字典(JSON类型请求体)
            [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
            request.HTTPBody = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        }else if (SWStringObject(param)) {
            //如果参数类型是字符串（XML类型请求体）
            NSString *paramStr = param;
            //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
            NSData *paramData = [paramStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            //计算POST提交数据的长度
            NSString *paramLength = [NSString stringWithFormat:@"%ld",(unsigned long)[paramData length]];
            //设置http-header:Content-Length
            [request setValue:paramLength forHTTPHeaderField:@"Content-Length"];
            //设置需要post提交的内容
            [request setHTTPBody:paramData];
        }else if (!param){
            
        }else {
            
        }
        return request;
    }else {
        return nil;
    }
}

- (void)resumeRequest:(NSMutableURLRequest *)request completion:(httpCompletion)completion
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *mResponse = (NSHTTPURLResponse *)response;
//        if (mResponse.statusCode != 200) {
//            error = [NSError errorWithDomain:@"status code occur error" code:mResponse.statusCode userInfo:error.userInfo];
//        }
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(data,mResponse,error);
            });
        }
        
    }] resume];
//    [[[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        NSHTTPURLResponse *mResponse = (NSHTTPURLResponse *)response;
//        if (mResponse.statusCode != 200) {
//            error = [NSError errorWithDomain:@"status code occur error" code:mResponse.statusCode userInfo:error.userInfo];
//        }
//        if (completion) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completion(data,mResponse,error);
//            });
//        }
//        
//    }] resume];
}


- (NSString *)urlPathByAppendUrl:(NSString *)url WithParam:(NSDictionary *)param {
    
    NSMutableString *path = [NSMutableString string];
    NSInteger i = 0;
    for (NSString *key in param.allKeys) {
        if (i == 0) {
            [path appendFormat:@"%@?", url];
        }
        NSString *value = param[key];
        [path appendFormat:@"&%@=%@", key, value];
    }
    return [path copy];
}

#pragma mark - NSURLSessionDelegate

- (NSNumber *)dataTaskWithHTTPMethod:(NSString *)method
                           URLString:(NSString *)URLString
                          parameters:(id)parameters
                             Headers:(NSDictionary *)headers
                             timeout:(NSTimeInterval)timeOut
                          completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completion
{
        return @0;
}

- (void)fillAuthenticationHeaders:(NSDictionary *)headers
{
    //add headers here
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}

- (void)cancelRequestWithId:(NSNumber *)requestId
{
    NSURLSessionDataTask *task = [self.dispatchTable objectForKey:requestId];
    if (task) {
        [task cancel];
        [self.dispatchTable removeObjectForKey:requestId];
    }
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    NSLog(@"didReceiveChallenge ");
    NSURLProtectionSpace *protectionSpace = challenge.protectionSpace;
    if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef serverTrust = protectionSpace.serverTrust;
        completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:serverTrust]);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

- (OSStatus)extractIdentity:(CFDataRef)inP12Data toIdentity:(SecIdentityRef*)identity {
    OSStatus securityError = errSecSuccess;
    CFStringRef password = CFSTR("123456");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12Data, options, &items);
    if (securityError == 0)
    {
        CFDictionaryRef ident = CFArrayGetValueAtIndex(items,0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(ident, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
    }
    else
    {
        NSLog(@"clinet.p12 error!");
    }
    
    if (options) {
        CFRelease(options);
    }
    return securityError;
}

@end
