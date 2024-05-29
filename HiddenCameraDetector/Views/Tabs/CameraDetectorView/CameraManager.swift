//
//  CameraManager.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 26.05.2024.
//

import Foundation
import SwiftUI
import AVFoundation

class CameraViewModel: ObservableObject {
    @Published var showAlert = false
}

struct CameraView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: CameraViewModel

    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraViewController = CameraViewController()
        cameraViewController.viewModel = viewModel
        return cameraViewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // No update needed for static camera view
    }
}

class CameraViewController: UIViewController {
    
    var viewModel: CameraViewModel?

    var captureSession: AVCaptureSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraAccess()
        setupCamera()
        
    }
    func checkCameraAccess() {
         switch AVCaptureDevice.authorizationStatus(for: .video) {
         case .authorized:
             // Доступ надано, можна використовувати камеру
             print("Access granted to camera")
             
         case .notDetermined:
             // Користувач ще не вибрав, запитуємо доступ
             AVCaptureDevice.requestAccess(for: .video) { granted in
                 if granted {
                     DispatchQueue.main.async {
                         // Доступ надано, можна використовувати камеру
                         print("Access granted to camera")
                     }
                 } else {
                     DispatchQueue.main.async {
                         self.showSettingsAlert()
                     }
                 }
             }
             
         case .denied, .restricted:
             // Доступ відхилено або обмежено, показуємо сповіщення
             showSettingsAlert()
             
         @unknown default:
             // Обробка невідомих випадків
             fatalError("Unknown authorization status")
         }
     }
     
     func showSettingsAlert() {
         let alert = UIAlertController(title: "Camera Access Denied",
                                       message: "Please allow access to the camera in Settings to use Camera Detector",
                                       preferredStyle: .alert)
         
         alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
         
         alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
             if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                 UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
             }
         })
         
         self.present(alert, animated: true, completion: nil)
     }
    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo

        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("Unable to access back camera!")
            viewModel?.showAlert = true
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            captureSession?.addInput(input)
        } catch let error {
            print("Error unable to initialize back camera:  \(error.localizedDescription)")
            viewModel?.showAlert = true
            return
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)

        captureSession?.startRunning()
    }
}
