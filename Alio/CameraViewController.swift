//
//  CameraViewController.swift
//  Alio
//
//  Created by Федор on 21/04/2019.
//  Copyright © 2019 Федор. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBAction func takePicture(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        print("Camera Loaded!")
        super.viewDidLoad()
    }
    
}
