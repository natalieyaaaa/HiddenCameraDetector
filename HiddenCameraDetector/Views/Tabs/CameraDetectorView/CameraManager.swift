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
      var filterColor: UIColor = .red // Default filter color is red

      override func viewDidLoad() {
          super.viewDidLoad()
          setupCamera()
          addFilterOverlay(color: filterColor)
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
    
    private func addFilterOverlay(color: UIColor) {
        let filterView = UIView(frame: view.bounds)
        filterView.backgroundColor = color.withAlphaComponent(0.5)
        filterView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(filterView)
    }

    func updateFilter(color: UIColor) {
        filterColor = color
        view.subviews.last?.removeFromSuperview() // Remove previous filter
        addFilterOverlay(color: filterColor)
    }
}
