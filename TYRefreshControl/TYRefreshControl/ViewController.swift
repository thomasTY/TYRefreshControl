//
//  ViewController.swift
//  TYRefreshControl
//
//  Created by thomasTY on 16/11/10.
//  Copyright © 2016年 thomasTY. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.dataSource = self
        return view
    }()
    
    let refreshC = TYRefreshControl()
    
    override func loadView()
    {
        view = tableView
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        refreshC.addTarget(self, action: #selector(getData), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshC)
    }
    
    func getData()
    {
        print("getData")
        self.refreshC.endRefreshing()
    }

}


extension ViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "cell\(indexPath.row)"
        return cell
    }
}

