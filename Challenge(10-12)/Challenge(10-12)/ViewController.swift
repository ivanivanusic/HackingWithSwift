//
//  ViewController.swift
//  Challenge(10-12)
//
//  Created by Ivan Ivanušić on 07/09/2020.
//  Copyright © 2020 Ivan Ivanušić. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My app"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture))
        
        let defaults = UserDefaults.standard
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
            } catch {
                print("Failed to load pictures.")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) as? PictureCell else {
            fatalError("Unable to dequeue PictureCell.")
        }
        let selectedPicture = pictures[indexPath.row]
        let path = getDocumentsDirectory().appendingPathComponent(selectedPicture.picture)
        cell.title.text = selectedPicture.title
        cell.imageViewCell.image = UIImage(contentsOfFile: path.path)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ac = UIAlertController(title: "Rename, delete or open picture", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Rename picture", style: .default, handler: { action in
            let picture = self.pictures[indexPath.item]
            let ac  = UIAlertController(title: "Rename picture", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
                guard let newTitle = ac?.textFields?[0].text else { return }
                picture.title = newTitle
                self?.save()
                self?.tableView.reloadData()
                
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(ac, animated: true)
        }))
        
        ac.addAction(UIAlertAction(title: "Delete picture", style: .default, handler: { action in
            self.pictures.remove(at: indexPath.item)
            self.save()
            tableView.reloadData()
        }))
        
        ac.addAction(UIAlertAction(title: "Open picture", style: .default, handler: { action in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                let selectedImage = self.pictures[indexPath.row]
                vc.pathToImage = self.getDocumentsDirectory().appendingPathComponent(selectedImage.picture)
                vc.imageTitle = selectedImage.title
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
    
        present(ac, animated: true)
    }
    
    @objc func addPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        
        present(picker, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
    
        let newPicture = Picture(title: "Unknown", picture: imageName)
        
        pictures.append(newPicture)
        save()
        tableView.reloadData()
        
        dismiss(animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save pictures.")
        }
    }
}

