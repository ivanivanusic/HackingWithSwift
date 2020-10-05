//
//  ViewController.swift
//  Challenge(25-27)
//
//  Created by Ivan Ivanušić on 05/10/2020.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    
    var topText: String?
    var bottomText: String?
    var currentImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Meme generator"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    @IBAction func addTopText(_ sender: Any) {
        guard currentImage != nil else { return }
        let ac = UIAlertController(title: "Enter top text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Enter", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.topText = answer
            self?.renderImage()
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @IBAction func addBottomText(_ sender: Any) {
        guard currentImage != nil else { return }
        let ac = UIAlertController(title: "Enter bottom text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Enter", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.bottomText = answer
            self?.renderImage()
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @IBAction func importPicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        imageView.alpha = 1
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        imageView.image = currentImage
        view.reloadInputViews()
    }
    
    func renderImage() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: imageView.frame.width, height: imageView.frame.height))
        
        let img = renderer.image { ctx in
            // Set background
            let rectangle = CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height)
            ctx.cgContext.setFillColor(UIColor.lightGray.cgColor)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            // Set image
            let image = currentImage
            let ratio = currentImage.size.height / currentImage.size.width
            if ratio < 1 {
                image?.draw(in: CGRect(x: 0, y: (imageView.frame.height - imageView.frame.height * ratio)/2, width: imageView.frame.width, height: imageView.frame.height * ratio))
            } else if ratio > 1{
                image?.draw(in: CGRect(x: (imageView.frame.width - imageView.frame.width / ratio)/2, y: 0, width: imageView.frame.width / ratio, height: imageView.frame.height))
            } else {
                image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height))
            }
            
            // Set text
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20),
                .paragraphStyle: paragraphStyle
            ]
            if let topString = topText {
                let attributedString = NSAttributedString(string: topString, attributes: attrs)
                attributedString.draw(with: CGRect(x: 0, y: 0, width: imageView.frame.height, height: 30), options: .usesLineFragmentOrigin, context: nil)
            }
            
            if let bottomString = bottomText {
                let attributedString = NSAttributedString(string: bottomString, attributes: attrs)
                attributedString.draw(with: CGRect(x: 0, y: imageView.frame.height - 30, width: imageView.frame.width, height: 30), options: .usesLineFragmentOrigin, context: nil)
            }
        }
        
        imageView.image = img
        view.reloadInputViews()
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

