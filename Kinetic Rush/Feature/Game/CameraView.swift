//
//  CameraView.swift
//  Kinetic Rush
//
//  Created by Wahid Hidayat on 27/04/24.
//

import AVFoundation
import UIKit
import SwiftUI

class CameraView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}

struct CameraViewWrapper: UIViewControllerRepresentable {
    var poseEstimator: GameViewModel
    func makeUIViewController(context: Context) -> some UIViewController {
        let cvc = CameraViewController()
        cvc.delegate = poseEstimator
        return cvc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
