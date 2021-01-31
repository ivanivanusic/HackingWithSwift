//
//  ViewController.swift
//  Challenge(07-09)
//
//  Created by Ivan Ivanušić on 30/08/2020.
//  Copyright © 2020 Ivan Ivanušić. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var allWords = [String]()
    var currentWord = ""
    var shownWord = ""
    var tryCounter = 0
    var usedLetters = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        loadList()
        startGame()
    }
    
    func loadList() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
    }
    
    func startGame() {
        currentWord = allWords.randomElement()!.uppercased()
        print(currentWord)
        printWordScore()
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer.uppercased())
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    func submit(_ answer: String) {
        checkletter(answer)
        checkForEnd()
    }
    
    func newGame(action: UIAlertAction) {
        tryCounter = 0
        shownWord = ""
        currentWord = ""
        usedLetters.removeAll()
        startGame()
    }
    
    func checkletter(_ answer: String) {
        if answer.count != 1 {
            let ac = UIAlertController(title: "You need to enter only one letter", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        usedLetters.append(answer)
        if !currentWord.contains(answer) {
            tryCounter += 1
        }
        printWordScore()
    }
    
    func checkForEnd() {
        var ac: UIAlertController
        if shownWord == currentWord {
            ac = UIAlertController(title: "YOU WON!!", message: nil, preferredStyle: .alert)
        } else if tryCounter == 7 {
            ac = UIAlertController(title: "YOU LOST!!", message: "Correct word is \(currentWord)", preferredStyle: .alert)
        } else {
            return
        }
        
        ac.addAction(UIAlertAction(title: "New game", style: .default, handler: newGame))
        present(ac, animated: true)
    }
    
    func printWordScore() {
        shownWord = ""
        for letter in currentWord {
            let strLetter = String(letter)
            
            if(usedLetters.contains(strLetter.uppercased())) {
                shownWord += strLetter.uppercased()
            } else {
                shownWord += "?"
            }
        }
        title = "Word: " + shownWord + "; Incorrect answers: \(tryCounter)"
    }
}

