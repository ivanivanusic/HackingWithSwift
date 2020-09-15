//
//  DetailTableViewController.swift
//  Challenge(13-15)
//
//  Created by Ivan Ivanušić on 15/09/2020.
//  Copyright © 2020 Ivan Ivanušić. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var Data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Data[0]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        cell.textLabel?.text = Data[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    

}
