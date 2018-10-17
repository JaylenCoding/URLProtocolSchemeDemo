//
//  LocalFileProtocol.swift
//  URLProtocolSchemeDemo
//
//  Created by Minecode on 2018/10/7.
//  Copyright © 2018年 Minecode. All rights reserved.
//

import WebKit
import Foundation

private typealias Const = LocalFileProtocolConst
struct LocalFileProtocolConst {
    static let imageScheme = "mcimg"
}

class LocalFileProtocol: URLProtocol {
    static private let interceptSchemes = [Const.imageScheme]
    static func shouldInterceptRequest(_ enable: Bool) {
        if enable {
            URLProtocol.registerClass(LocalFileProtocol.self)
            interceptSchemes.forEach { URLProtocol.wk_registerScheme($0) }
        } else {
            URLProtocol.unregisterClass(LocalFileProtocol.self)
            URLProtocol.wk_unregisterAllCustomSchemes()
        }
    }
    override class func canInit(with request: URLRequest) -> Bool {
        if let scheme = request.url?.scheme,
            interceptSchemes.contains(scheme) {
            return true
        }
        return false
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override func startLoading() {
        if let urlStr = request.url?.absoluteString,
            let scheme = request.url?.scheme {
            let startIndex = urlStr.index(urlStr.startIndex, offsetBy: scheme.count + 3)
            let endIndex = urlStr.endIndex
            let imagePath: String = String(urlStr[startIndex..<endIndex])
            
            if let image = UIImage(contentsOfFile: imagePath),
                let data = UIImagePNGRepresentation(image) {
                
                // Logic of Success
                let response = HTTPURLResponse(url: self.request.url!, statusCode: 200, httpVersion: "1.1", headerFields: nil)
                self.client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
                self.client?.urlProtocol(self, didLoad: data)
                self.client?.urlProtocolDidFinishLoading(self)
                return
            }
        }
        
        // Logic of Failed
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotOpenFile, userInfo: nil) as Error
        self.client?.urlProtocol(self, didFailWithError: error)
        return
    }
    override func stopLoading() {
        
    }
}
