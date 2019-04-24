//
//  SessionViewController.swift
//  Alio
//
//  Created by Федор on 23/04/2019.
//  Copyright © 2019 Федор. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class SessionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var sequenceHandler = VNSequenceRequestHandler()
    @IBOutlet var predictionLabelSession: UILabel!
    @IBOutlet var imageViewSession: UIImageView!
    @IBAction func startSessionButton(_ sender: UIButton) {
        startSession()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    let dataOutputQueue = DispatchQueue(
        label: "video data queue",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem)

}

// CREATE SESSION
extension SessionViewController {
    private func startSession() {
//      Configuration for the captureSession (between begin and commitConfiguration)
        session.beginConfiguration()
        let videoSource = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                  for: .video,
                                                  position: .back)
//      handle availability of videoSource
        guard let videoSourceInput = try? AVCaptureDeviceInput(device: videoSource!), session.canAddInput(videoSourceInput) else {
            return
        }
        
        session.addInput(videoSourceInput)
        
//      create and add custom video data output
        let videoSourceOutput = AVCaptureVideoDataOutput()
        videoSourceOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
        videoSourceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        session.addOutput(videoSourceOutput)

        let videoConnection = videoSourceOutput.connection(with: .video)
        videoConnection?.videoOrientation = .portrait
        
        session.commitConfiguration()
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame.size = imageViewSession.frame.size
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        imageViewSession.layer.addSublayer(previewLayer)
        
        session.startRunning()
    }
}


