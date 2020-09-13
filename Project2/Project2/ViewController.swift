//
//  ViewController.swift
//  Project2
//
//  Created by Ivan Ivanušić on 10/08/2020.
//  Copyright © 2020 Ivan Ivanušić. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var answeredQuestions = 0
    var highestScore: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(shareTapped))
        
        let userDefaults = UserDefaults.standard
        if let loadedScore = userDefaults.object(forKey: "HighestScore") as? Int {
            highestScore = loadedScore
        } else {
            highestScore = 0
        }

        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "Flag: " + countries[correctAnswer].uppercased() + ", Score: \(score)"
    }

    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 2, y: 2)
        })
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            message = "Your score is \(score)"
        } else {
            title = "Wrong"
            score -= 1
            message = "Correct answer is \(countries[correctAnswer].uppercased()),\nYour score is \(score)"
        }
        
        answeredQuestions += 1
        
        if score > highestScore! {
            highestScore = score
            let ac = UIAlertController(title: "New highscore of \(highestScore!)!!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))

            saveHighScoreCount()
            present(ac, animated: true)
        }
        
        if answeredQuestions == 10 {
            let ac = UIAlertController(title: "END GAME", message: "Your final score is \(score) of maximum 10", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "New game", style: .default, handler: askQuestion))
            score = 0
            answeredQuestions = 0
            
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            
            present(ac, animated: true)
        }
        sender.transform = .identity
    }
    
    @objc func shareTapped() {
        let vc = UIAlertController(title: "Your score is: \(score)", message: "", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Exit", style: .default, handler: nil))
        
        present(vc, animated: true)
    }
    
    func saveHighScoreCount() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(highestScore, forKey: "HighestScore")
    }

    
}

