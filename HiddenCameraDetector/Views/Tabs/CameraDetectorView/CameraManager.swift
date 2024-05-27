//
//  CameraManager.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 26.05.2024.
//

import Foundation
import SwiftUI
import AVFoundation


struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraViewController = CameraViewController()
        return cameraViewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // No update needed for static camera view
    }
}

class CameraViewController: UIViewController {
    var captureSession: AVCaptureSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo

        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("Unable to access back camera!")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            captureSession?.addInput(input)
        } catch let error {
            print("Error unable to initialize back camera:  \(error.localizedDescription)")
            return
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)

        captureSession?.startRunning()
    }
}
