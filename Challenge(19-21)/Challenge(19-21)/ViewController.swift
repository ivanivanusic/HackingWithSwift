//
//  ViewController.swift
//  Challenge(19-21)
//
//  Created by Ivan Ivanušić on 25/09/2020.
//

import UIKit

class ViewController: UITableViewController {
    var notes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        if let loadedNotes = userDefaults.object(forKey: "Notes") as? [String] {
            notes = loadedNotes
        } else {
            notes.removeAll()
        }
        
        title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        tableView.reloadData()
    }
    
    @objc func addNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.text = "Add your text here"
            notes.append(vc.text!)
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.text = notes[indexPath.row]
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func changeData(new: String, old: String) {
        for i in 0..<notes.count {
            if notes[i].contains(old) {
                notes[i] = new
                tableView.reloadData()
                saveNotes()
                return
            }
        }
    }
        
    func saveNotes() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(notes, forKey: "Notes")
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            notes.remove(at: indexPath.row)
            tableView.reloadData()
            saveNotes()
        }
    }
}

