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
    
    let cameraImagePicker = UIImagePickerController()
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var predictionLabelCamera: UILabel!
    @IBAction func takePictureFromCamera(_ sender: UIButton) {
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
        detectDigit(image: ciImage)
        
    }
}

extension CameraViewController {
    
    func detectDigit(image: CIImage) {
         var classificationRequest: VNCoreMLRequest = {
            do {
                let model = try VNCoreMLModel(for: MNIST_model().model)
                return VNCoreMLRequest(model: model, completionHandler: handleClassification)
            } catch {
                fatalError()
            }
        }()
        
        func handleClassification(request: VNRequest, error: Error?) {
            guard let observations = request.results as? [VNClassificationObservation]
                else { fatalError() }
            guard let best = observations.first
                else { fatalError() }
            
            DispatchQueue.main.async {
                self.predictionLabelCamera.text = best.identifier
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([classificationRequest])
        } catch {
            print(error)
        }
    }
}
