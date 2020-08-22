//
//  ViewController.swift
//  Challenge(4-6)
//
//  Created by Ivan Ivanušić on 22/08/2020.
//  Copyright © 2020 Ivan Ivanušić. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(answerPrompt))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePrompt))
        navigationItem.rightBarButtonItems = [share, add]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearListPrompt))
        
        title = "Shopping list"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func answerPrompt() {
        let ac = UIAlertController(title: "Enter new shopping item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Enter", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.enter(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func enter(_ item: String) {
        shoppingList.append(item)
        let lastItemPossition = shoppingList.count - 1
        let indexPath = IndexPath(row: lastItemPossition, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func clearListPrompt() {
        shoppingList.removeAll(keepingCapacity: false)
        tableView.reloadData()
    }
    
     @objc func sharePrompt() {
        let list = "My shopping list:\n\n" + shoppingList.joined(separator: "\n")
        
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
}

