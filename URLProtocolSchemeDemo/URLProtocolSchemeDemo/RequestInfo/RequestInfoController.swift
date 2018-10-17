//
//  RequestInfoController.swift
//  URLProtocolSchemeDemo
//
//  Created by Minecode on 2018/10/7.
//  Copyright © 2018年 Minecode. All rights reserved.
//

import UIKit
import WebKit

class RequestInfoController: UIViewController {
    
    lazy var webView: WKWebView = WKWebView(frame: .zero)
    lazy var msgLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.backgroundColor = UIColor.gray.withAlphaComponent(0.75)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        RequestInfoProtocol.shouldInterceptRequest(true)
        NotificationCenter.default.addObserver(self, selector: #selector(urlChangedHandler(notification:)), name: NSNotification.Name.RequestInfoURL, object: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        RequestInfoProtocol.shouldInterceptRequest(false)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Request Info"
        setupView()
        configure()
    }
    private func setupView() {
        view.addSubview(webView)
        view.addSubview(msgLabel)
        webView.translatesAutoresizingMaskIntoConstraints = false
        msgLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                .init(item: webView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0),
                .init(item: webView, attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0),
                .init(item: webView, attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 0),
                .init(item: webView, attribute: .trailing, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0)
                ])
            NSLayoutConstraint.activate([
                .init(item: msgLabel, attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0),
                .init(item: msgLabel, attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 0),
                .init(item: msgLabel, attribute: .trailing, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0),
                .init(item: msgLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
                ])
        } else {
            NSLayoutConstraint.activate([
                .init(item: webView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0),
                .init(item: webView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0),
                .init(item: webView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0),
                .init(item: webView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0)
                ])
            NSLayoutConstraint.activate([
                .init(item: msgLabel, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0),
                .init(item: msgLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0),
                .init(item: msgLabel, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0),
                .init(item: msgLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
                ])
        }
    }
    private func configure() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        let link = "http://bilibili.com"
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @objc func urlChangedHandler(notification: Notification) {
        if let urlString = notification.object as? String {
            DispatchQueue.main.async {
                self.msgLabel.text = urlString
                NSObject.cancelPreviousPerformRequests(withTarget: self)
                self.perform(#selector(self.hideMsgTest), with: nil, afterDelay: 3.0, inModes: [.defaultRunLoopMode])
            }
        }
    }
    @objc private func hideMsgTest() {
        self.msgLabel.text = ""
    }
}

extension RequestInfoController: WKUIDelegate {
    
}

extension RequestInfoController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
}
