//
//  SessionViewController.swift
//  Alio
//
//  Created by Федор on 23/04/2019.
//  Copyright © 2019 Федор. All rights reserved.
//

import UIKit
import AVFoundation

private func setupAVSession() {
    
}

class SessionViewController: UIViewController {
    
    @IBOutlet var imageViewSession: UIImageView!
    
    @IBAction func startSessionutton(_ sender: UIButton) {
    }
    
    @IBOutlet var predictionLabelSession: UILabel!
    
    override func viewDidLoad() {
        print("Session View Loaded!")
        super.viewDidLoad()
    }
    
    
}
