//
//  HomeViewController.swift
//  URLProtocolSchemeDemo
//
//  Created by Minecode on 2018/10/7.
//  Copyright © 2018年 Minecode. All rights reserved.
//

import UIKit

private typealias Const = HomeViewControllerConst
struct HomeViewControllerConst {
    static let normalCell = "normalCell"
}

class HomeViewController: UITableViewController {
    
    fileprivate let options: [String] = ["LogRequestInfo", "LoadLocalFile"]
    fileprivate let optionsLocalizedDesc: [String: String] = ["LogRequestInfo": "WKWebView Get Request Info",
                                                 "LoadLocalFile": "WKWebView Load Local File"]
    fileprivate let optionsTargetController: [String: UIViewController.Type] = [
        "LogRequestInfo": RequestInfoController.self,
        "LoadLocalFile": LocalFileController.self
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Demo List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Const.normalCell)
    }
}

extension HomeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.normalCell, for: indexPath)
        cell.textLabel?.text = optionsLocalizedDesc[options[indexPath.item]]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let targetType = optionsTargetController[options[indexPath.item]] else { return }
        let vc: UIViewController = targetType.init(nibName: nil, bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

typealias Options = String
