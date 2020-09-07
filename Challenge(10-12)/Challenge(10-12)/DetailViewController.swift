//
//  DetailViewController.swift
//  Challenge(10-12)
//
//  Created by Ivan Ivanušić on 07/09/2020.
//  Copyright © 2020 Ivan Ivanušić. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var pathToImage: URL!
    var imageTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = imageTitle!
        navigationItem.largeTitleDisplayMode = .never
        
        if let urlToLoad = pathToImage {
            imageView.image = UIImage(contentsOfFile: urlToLoad.path)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
