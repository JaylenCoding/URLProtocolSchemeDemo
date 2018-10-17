//
//  NSURLProtocol+WebKitSupport.h
//  NSURLProtocol+WebKitSupport
//
//  Created by yeatse on 2016/10/11.
//  Copyright © 2016年 Yeatse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLProtocol (WebKitSupport)

/**
 * @brief 注册、注销 WKWebKit URL拦截。非多线程安全。
 */
+ (void)wk_registerScheme:(NSString*)scheme;
+ (void)wk_unregisterScheme:(NSString*)scheme;
+ (void)wk_unregisterAllCustomSchemes;

@end

