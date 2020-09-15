//
//  ViewController.swift
//  Challenge(13-15)
//
//  Created by Ivan Ivanušić on 15/09/2020.
//  Copyright © 2020 Ivan Ivanušić. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var countriesList = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries and capitals"
        parse()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let country = countriesList[indexPath.row]
        cell.textLabel?.text = country.country
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailTableViewController {
            vc.Data.append("Country: \(countriesList[indexPath.row].country)")
            vc.Data.append("Capital: \(countriesList[indexPath.row].city)")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func parse() {
        guard let path = Bundle.main.path(forResource: "country", ofType: "json") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return }
    
        let decoder = JSONDecoder()
        if let jsonCountries = try? decoder.decode(Countries.self, from: data) {
            countriesList = jsonCountries.countries
            print(jsonCountries.countries)
            tableView.reloadData()
            return
        }
    }
}

