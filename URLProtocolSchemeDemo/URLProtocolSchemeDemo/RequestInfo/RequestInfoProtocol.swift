//
//  RequestInfoProtocol.swift
//  URLProtocolSchemeDemo
//
//  Created by Minecode on 2018/10/7.
//  Copyright © 2018年 Minecode. All rights reserved.
//

import WebKit

private typealias Const = RequestInfoProtocolConst
struct RequestInfoProtocolConst {
    static let requestLogged = "RequestLogged"
    static let requestURLNotification = "RequestURLNotification"
    static let httpScheme = "http"
    static let httpsScheme = "https"
}

class RequestInfoProtocol: URLProtocol {
    fileprivate lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
    fileprivate var copiedTask: URLSessionTask?
    
    static private var requestInfoProtocolDict = Set<Int>()
    static private let interceptSchemes = [Const.httpScheme, Const.httpsScheme]
    static func shouldInterceptRequest(_ enable: Bool) {
        if enable {
            URLProtocol.registerClass(RequestInfoProtocol.self)
            interceptSchemes.forEach { URLProtocol.wk_registerScheme($0) }
        } else {
            URLProtocol.unregisterClass(RequestInfoProtocol.self)
            URLProtocol.wk_unregisterAllCustomSchemes()
        }
    }
    override class func canInit(with request: URLRequest) -> Bool {
        if let scheme = request.url?.scheme,
            interceptSchemes.contains(scheme),
            requestInfoProtocolDict.contains(request.hashValue) {
            return false
        }
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override func startLoading() {
        RequestInfoProtocol.requestInfoProtocolDict.insert(request.hashValue)
        NotificationCenter.default.post(name: NSNotification.Name.RequestInfoURL, object: request.url?.absoluteString)
        
        if let newRequest = (request as NSURLRequest).copy() as? URLRequest {
            let newTask = session.dataTask(with: newRequest)
            newTask.resume()
            self.copiedTask = newTask
        }
    }
    override func stopLoading() {
        RequestInfoProtocol.requestInfoProtocolDict.remove(request.hashValue)
        session.invalidateAndCancel()
        copiedTask = nil
    }
}
extension RequestInfoProtocol: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            self.client?.urlProtocol(self, didFailWithError: error)
            return
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.client?.urlProtocol(self, didLoad: data)
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        completionHandler(.allow)
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        completionHandler(proposedResponse)
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        self.client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
        
        RequestInfoProtocol.requestInfoProtocolDict.remove(request.hashValue)
        let redirectError = NSError(domain: NSURLErrorDomain, code: NSUserCancelledError, userInfo: nil)
        task.cancel()
        self.client?.urlProtocol(self, didFailWithError: redirectError)
    }
}

extension Notification.Name {
    static let RequestInfoURL = Notification.Name.init(Const.requestURLNotification)
}
