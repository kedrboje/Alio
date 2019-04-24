//
//  CameraViewController.swift
//  Alio
//
//  Created by Федор on 21/04/2019.
//  Copyright © 2019 Федор. All rights reserved.
//

import UIKit
import CoreML
import Vision

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var predictionLabelCamera: UILabel!
    
    @IBAction func takePictureLicensePlate(_ sender: UIButton) {
        
        let cameraImagePicker = UIImagePickerController()
        
//      handle camera availability exception
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let alertMessage = UIAlertController(title: "Camera Error", message: "No camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertMessage.addAction(ok)
            self.present(alertMessage, animated: true, completion: nil)
            return
        }
        
        cameraImagePicker.delegate = self
        cameraImagePicker.sourceType = .camera
        present(cameraImagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func takePictureFromGallery(_ sender: UIButton) {
        
        let galleryImagePicker = UIImagePickerController()
        
//      handle photo library availability exception

        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            let alertMessage = UIAlertController(title: "Photo Library Error", message: "No photos", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertMessage.addAction(ok)
            self.present(alertMessage, animated: true, completion: nil)
            return
        }
        
        galleryImagePicker.sourceType = .photoLibrary
        galleryImagePicker.delegate = self
        present(galleryImagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("coludn't load image")
        }
        
        imageView.image = image
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("couldn't convert")
        }
        detectAge(image: ciImage)
    }
}

extension CameraViewController {
    
    func detectAge(image: CIImage) {
        predictionLabelCamera.text = "Detecting age..."
        
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: AgeNet().model) else {
            fatalError("can't load AgeNet model")
        }
        
        // Create request for Vision Core ML model created
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    fatalError("unexpected result type from VNCoreMLRequest")
            }
            
            // Update UI on main queue
            DispatchQueue.main.async { [weak self] in
                self?.predictionLabelCamera.text = "I think your age is \(topResult.identifier) years!"
            }
        }
        
        // Run the Core ML AgeNet classifier on global dispatch queue
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
}
