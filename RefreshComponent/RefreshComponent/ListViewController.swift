//
//  ListViewController.swift
//  RefreshComponent
//
//  Created by hhuc on 2019/1/19.
//  Copyright © 2019 hhuc. All rights reserved.
//

import UIKit

//添加约束条件
private let cellId = "cellId"

class ListViewController: UIViewController {

    lazy var listView = UITableView()
    lazy var list = Array<String>()
    lazy var refershControl = GDRefershControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        self.refershControl.beginRefreshing()

        //添加监听方法
        refershControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        loadData()
    }
    
    @objc func loadData() {
        self.refershControl.beginRefreshing()

        for n in 0..<10 {
            list.insert(n.description, at: 0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            print("结束刷新")
            self.refershControl.endRefreshing()
            self.listView.reloadData()
        }
    }
    
}

extension ListViewController{
    
    func setupUI() {
        
        title = "list"
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = UIColor.white
        
        listView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
        listView.dataSource = self
        listView.delegate = self
        listView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(listView)
        
        //添加刷新控件
        listView.addSubview(refershControl)
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        cell.textLabel?.text = "hello \(list[indexPath.row])"
        
        return cell
    }
}
