//
//  CameraView.swift
//  SmartCamera
//
//  Created by Sergey Shalnov on 10/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit
import AVKit
import Vision


class CameraView: UIViewController, ICameraView {
    
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
    
    // MARK: - Variables
    
    var presenter: ICameraPresenter?
    
    
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
        informationPanel.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -15).isActive = true
        
        informationObjectLabel.leadingAnchor.constraint(equalTo: informationPanel.leadingAnchor, constant: 15).isActive = true
        informationPercentLabel.trailingAnchor.constraint(equalTo: informationPanel.trailingAnchor, constant: -15).isActive = true
        informationObjectLabel.heightAnchor.constraint(equalTo: informationPanel.heightAnchor).isActive = true
        informationPercentLabel.heightAnchor.constraint(equalTo: informationPanel.heightAnchor).isActive = true
        
        informationObjectLabel.trailingAnchor.constraint(equalTo: informationPercentLabel.leadingAnchor, constant: -10).isActive = true
    }
    
    private func setupCapture() {
        presenter?.setCaptureSession()
    }
    
}


// MARK: - ICameraView extension

extension CameraView {
    
    func setObjectInformation(object: String, percent: String) {
        informationObjectLabel.text = object
        informationPercentLabel.text = percent
    }
    
    func setCameraPreviewLayer(layer: AVCaptureVideoPreviewLayer) {
        view.layer.addSublayer(layer)
        layer.frame = view.frame
    }

}

