//
//  RootViewController.swift
//  RefreshComponent
//
//  Created by hhuc on 2019/1/19.
//  Copyright © 2019 hhuc. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "next", style: .plain, target: self, action: #selector(nextAction))

    }

    @objc func nextAction()  {
        let vc = ListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension RootViewController{
    func setupUI() {
        
        title = "root"
        view.backgroundColor = UIColor.white
    }
}
