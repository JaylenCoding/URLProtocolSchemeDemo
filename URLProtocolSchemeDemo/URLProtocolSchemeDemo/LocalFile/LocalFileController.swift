//
//  LocalFileController.swift
//  URLProtocolSchemeDemo
//
//  Created by Minecode on 2018/10/15.
//  Copyright © 2018年 Minecode. All rights reserved.
//

import UIKit
import WebKit

class LocalFileController: UIViewController {
    
    lazy var webView: WKWebView = WKWebView(frame: .zero)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        LocalFileProtocol.shouldInterceptRequest(true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        LocalFileProtocol.shouldInterceptRequest(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Load Local File"
        setupView()
        configure()
    }
    private func setupView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                .init(item: webView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0),
                .init(item: webView, attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0),
                .init(item: webView, attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 0),
                .init(item: webView, attribute: .trailing, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0)
                ])
        } else {
            NSLayoutConstraint.activate([
                .init(item: webView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0),
                .init(item: webView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0),
                .init(item: webView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0),
                .init(item: webView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0)
                ])
        }
    }
    private func configure() {
        if let filePath = Bundle.main.path(forResource: "index", ofType: "html") {
            do { var htmlStr = try String(contentsOfFile: filePath)
                // Redirect Image Url to local file
                htmlStr = htmlStr.replace(source: "$IMAGE1", with: imageURL(at: 1))
                htmlStr = htmlStr.replace(source: "\"$IMAGE2\"", with: imageURL(at: 2))
                webView.loadHTMLString(htmlStr, baseURL: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    private func imageURL(at index: Int) -> String {
        let pathStr: String = Bundle.main.path(forResource: "Image_\(index)", ofType: "jpeg") ?? ""
        let pathURL: URL = URL(fileURLWithPath: pathStr)
        return pathURL.absoluteString.replace(source: "file://", with: "\(LocalFileProtocolConst.imageScheme):/")
    }
}

private extension String {
    func replace(source sourceStr: String, with targetStr: String) -> String {
        return self.replacingOccurrences(of: sourceStr, with: targetStr, options: String.CompareOptions.literal, range: nil)
    }
}
