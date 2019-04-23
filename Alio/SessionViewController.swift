//
//  SessionViewController.swift
//  Alio
//
//  Created by Федор on 23/04/2019.
//  Copyright © 2019 Федор. All rights reserved.
//

import UIKit
import AVFoundation



class SessionViewController: UIViewController {
    
    @IBOutlet var imageViewSession: UIImageView!
    
    @IBAction func startSessionButton(_ sender: UIButton) {
        
        startSession()
        
    }
    
    @IBOutlet var predictionLabelSession: UILabel!
    
    override func viewDidLoad() {
        print("Session View Loaded!")
        super.viewDidLoad()
    }
    
    private func startSession() {
        
        let session = AVCaptureSession()
        
//      Configuration for the captureSession (between begin and commitConfiguration)
        session.beginConfiguration()
        let videoSource = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        
//      handle availability of videoSource
        guard let videoSourceInput = try? AVCaptureDeviceInput(device: videoSource!), session.canAddInput(videoSourceInput) else {
            return
        }
        
//      add input
        session.addInput(videoSourceInput)
        let videoSourceOutput = AVCaptureVideoDataOutput()
        guard session.canAddOutput(videoSourceOutput) else {
            return
        }
        
//      add output
        session.addOutput(videoSourceOutput)
        session.commitConfiguration()
        
//      create and add custom layer to the imageViewSession
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame.size = imageViewSession.frame.size
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        imageViewSession.layer.addSublayer(previewLayer)
    
        session.startRunning()
    }
    
}
