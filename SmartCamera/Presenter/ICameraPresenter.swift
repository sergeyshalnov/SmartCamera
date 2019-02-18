//
//  ICameraPresenter.swift
//  SmartCamera
//
//  Created by Sergey Shalnov on 18/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import AVKit


// MARK: - CameraPresenter protocol

protocol ICameraPresenter: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func setCaptureSession() 
    
}
