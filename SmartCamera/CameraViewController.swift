//
//  CameraViewController.swift
//  SmartCamera
//
//  Created by Sergey Shalnov on 10/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit
import AVKit
import Vision

class CameraViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var informationObjectLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        
        return label
    }()
    
    private lazy var informationPercentLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        return label
    }()
    
    private lazy var informationPanel: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = self.view.tintColor
        view.layer.cornerRadius = 15
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(informationObjectLabel)
        view.addSubview(informationPercentLabel)
        
        return view
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    
    // MARK: - Setup
    
    private func setup() {
        setupCapture()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        view.addSubview(informationPanel)
    }
    
    private func setupConstraints() {
        informationPanel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        informationPanel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        informationPanel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15).isActive = true
        
        informationObjectLabel.leadingAnchor.constraint(equalTo: informationPanel.leadingAnchor, constant: 15).isActive = true
        informationPercentLabel.trailingAnchor.constraint(equalTo: informationPanel.trailingAnchor, constant: -15).isActive = true
        informationObjectLabel.heightAnchor.constraint(equalTo: informationPanel.heightAnchor).isActive = true
        informationPercentLabel.heightAnchor.constraint(equalTo: informationPanel.heightAnchor).isActive = true
        
        informationObjectLabel.trailingAnchor.constraint(equalTo: informationPercentLabel.leadingAnchor, constant: -10).isActive = true
    }
    
    private func setupCapture() {
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        captureSession.addOutput(dataOutput)
    }
    
    
    
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate  {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (finishRequest, error) in
            
            guard let results = finishRequest.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            
            print("$LOG: \(firstObservation.identifier)  % \((firstObservation.confidence * 100).format(".2"))")
            
            DispatchQueue.main.async {
                self.informationObjectLabel.text = firstObservation.identifier
                self.informationPercentLabel.text = "% \((firstObservation.confidence * 100).format(".2"))"
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
