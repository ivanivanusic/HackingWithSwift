//
//  ViewController.swift
//  Project01
//
//  Created by Ivan Ivanušić on 09/08/2020.
//  Copyright © 2020 Ivan Ivanušić. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var picturesViewCount = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        performSelector(inBackground: #selector(loadPictures), with: nil)
        
        let userDefaults = UserDefaults.standard
        picturesViewCount = userDefaults.object(forKey: "ViewCount") as? [String: Int] ?? [String: Int]()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Times seen:  \(picturesViewCount[pictures[indexPath.row], default: 0])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedImageNumber = indexPath.row + 1
            vc.imagesCount = pictures.count
            
            picturesViewCount[pictures[indexPath.row], default: 0] += 1
            self.saveViewCount()
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                // this is a picture to load!
                pictures.append(item)
            }
        }
        pictures.sort()
        
        print(pictures)
        tableView.performSelector(onMainThread: #selector(tableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    func saveViewCount() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(picturesViewCount, forKey: "ViewCount")
    }
}

