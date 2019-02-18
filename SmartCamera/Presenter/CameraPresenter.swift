//
//  CameraPresenter.swift
//  SmartCamera
//
//  Created by Sergey Shalnov on 18/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import AVKit
import Vision


class CameraPresenter: NSObject, ICameraPresenter {
    
    // MARK: - Variables
    
    unowned let view: ICameraView
    
    // MARK: - Initialization
    
    init(view: ICameraView) {
        self.view = view
    }
    
}


// MARK: - ICameraPresenter extension

extension CameraPresenter {
    
    func setCaptureSession() {
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        // Add camera layer to the view
        view.setCameraPreviewLayer(layer: previewLayer)
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        captureSession.addOutput(dataOutput)
    }
    
}


// MARK: - CaptureVideo delegate extension

extension CameraPresenter: AVCaptureVideoDataOutputSampleBufferDelegate  {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (finishRequest, error) in
            
            guard let results = finishRequest.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            
            // Print information about detected object to view
            print("$LOG: \(firstObservation.identifier)  % \((firstObservation.confidence * 100).format(".2"))")
            
            DispatchQueue.main.async { [weak self] in
                let object = firstObservation.identifier
                let percent = "% \((firstObservation.confidence * 100).format(".2"))"
                
                // Add information about detected object to view
                self?.view.setObjectInformation(object: object, percent: percent)
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
