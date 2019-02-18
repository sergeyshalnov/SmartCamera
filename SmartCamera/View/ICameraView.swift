//
//  ICameraView.swift
//  SmartCamera
//
//  Created by Sergey Shalnov on 18/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import AVKit


// MARK: - CameraView protocol

protocol ICameraView: class {
    
    func setObjectInformation(object: String, percent: String)
    func setCameraPreviewLayer(layer: AVCaptureVideoPreviewLayer) 
    
}
