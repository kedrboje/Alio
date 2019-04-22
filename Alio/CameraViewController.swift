//
//  CameraViewController.swift
//  Alio
//
//  Created by Федор on 21/04/2019.
//  Copyright © 2019 Федор. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBAction func takePictureLicensePlate(_ sender: UIButton) {
        
        let cameraImagePicker = UIImagePickerController()

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraImagePicker.sourceType = .camera
        } else {
            cameraImagePicker.sourceType = .photoLibrary
        }
        
        cameraImagePicker.delegate = self
        
        present(cameraImagePicker, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        print("Camera Loaded!")
        super.viewDidLoad()
    }
    
}
