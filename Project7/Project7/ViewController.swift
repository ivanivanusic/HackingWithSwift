//
//  ViewController.swift
//  Project7
//
//  Created by Ivan Ivanušić on 24/08/2020.
//  Copyright © 2020 Ivan Ivanušić. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var allPetitions = [Petition]()
    var filteredPetitions = [Petition]()
    var filter = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditsTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
        
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }

        showError()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            allPetitions = jsonPetitions.results
            filteredPetitions = allPetitions
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func creditsTapped() {
        let vc = UIAlertController(title: "Credits", message: "We The People API of the Whitehouse", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Exit", style: .default, handler: nil))
        
        present(vc, animated: true)
    }
    
    @objc func filterTapped() {
        let ac = UIAlertController(title: "Enter filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Enter", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.filter = answer
            self?.enter()
        }
        
        let clearFilters = UIAlertAction(title: "Clear filter", style: .default, handler: clearFilter)
        
        ac.addAction(submitAction)
        ac.addAction(clearFilters)
        present(ac, animated: true)
    }
    
    func enter() {
        performSelector(inBackground: #selector(filterData), with: nil)
        tableView.performSelector(onMainThread: #selector(tableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    func clearFilter(alert: UIAlertAction!) {
        filteredPetitions.removeAll(keepingCapacity: false)
        filteredPetitions = allPetitions
        tableView.reloadData()
    }
    
    @objc func filterData() {
        filteredPetitions.removeAll(keepingCapacity: false)
        
        if filter == "" {
            filteredPetitions = allPetitions
        } else {
            for petition in allPetitions {
                if petition.body.contains(filter) || petition.title.contains(filter) {
                    filteredPetitions.append(petition)
                }
            }
        }

    }

}

