//
//  PictureViewController.swift
//  SeeFood
//
//  Created by Андрей on 04.01.2021.
//

import UIKit
import CoreML
import Vision

class PictureViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var userImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
        self.imageView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.imageView.layer.borderWidth = 10
        setImage()
    }
    
    func setImage() {
        guard let userImage = self.userImage else { return }
        imageView.image = userImage
        
        guard let ciImage = CIImage(image: userImage) else {
            fatalError("Could not convert to CIImage")
        }
        
        detect(image: ciImage)
    }
    
    func detect(image: CIImage) {
        
        guard let model: VNCoreMLModel = {
            do {
                let config = MLModelConfiguration()
                return try VNCoreMLModel(for: HotdogClassifier(configuration: config).model)
            }
            catch {
                print(error)
                fatalError("Couldn't create SleepCalculator")
            }
        }() else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            if let firstResult = result.first {
                if firstResult.identifier.contains("Hotdog") {
                    self.titleLabel.text = "Hotdog!"
                    self.imageView.layer.borderColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
                } else {
                    self.titleLabel.text = "Not Hotdog!"
                    self.imageView.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
}
