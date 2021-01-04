//
//  ViewController.swift
//  SeeFood
//
//  Created by Андрей on 04.01.2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    var pictureVC: PictureViewController?
    var selectedPicture: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pictureVC = PictureViewController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let userPickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        selectedPicture = userPickedimage
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        performSegue(withIdentifier: "pictureViewSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? PictureViewController else { return }
        dvc.userImage = selectedPicture
    }
    
    @IBAction func cameraTapped(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

