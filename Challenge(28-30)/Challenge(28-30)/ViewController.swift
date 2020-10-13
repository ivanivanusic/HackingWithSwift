//
//  ViewController.swift
//  Challenge(28-30)
//
//  Created by Ivan Ivanušić on 13/10/2020.
//

import UIKit

class ViewController: UICollectionViewController {
    var words = ["Hello", "Bonjour", "France", "Paris"]
    var foundPairs = 0
    var selectedItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pelmanism"
        words.shuffle()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell else {
            fatalError("Unable to dequeue CollectionViewCell.")
        }
        cell.word.text = words[indexPath.item]
        cell.word.isHidden = true
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cells = collectionView.visibleCells as? [CollectionViewCell] else { return }
        selectedItems.append(cells[indexPath.item].word.text!)
        
        if selectedItems.count == 1 {
            cells[indexPath.item].word.isHidden = false
            return
        } else if selectedItems.count == 2 {
            cells[indexPath.item].word.isHidden = false
            if check() {
                foundPairs += 1
                for cell in cells {
                    if !cell.word.isHidden && selectedItems.count == 2 {
                        if cell.word.text == selectedItems[0] || cell.word.text == selectedItems[1] {
                            cell.backgroundColor = UIColor.green
                        }
                    }
                }
                selectedItems.removeAll()
            } else {
                guard let cells = collectionView.visibleCells as? [CollectionViewCell] else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self, cells] in
                    for cell in cells {
                        if !cell.word.isHidden && self?.selectedItems.count == 2 {
                            if cell.word.text != self?.selectedItems[0] || cell.word.text != self?.selectedItems[1] {
                                cell.word.isHidden = true
                            }
                        }
                    }
                    self?.selectedItems.removeAll()
                }
            }
        }
        
        if foundPairs == 2 {
            let ac = UIAlertController(title: "You won", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func check() -> Bool {
        if selectedItems.contains("Bonjour") && selectedItems.contains("Hello") {
            return true
        } else if selectedItems.contains("Paris") && selectedItems.contains("France") {
            return true
        }
        
        return false
    }
}

