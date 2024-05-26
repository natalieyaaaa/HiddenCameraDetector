//
//  ToolsViewModel.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 24.05.2024.
//

import Foundation
import SwiftUI
import CoreMotion

class ToolsViewModel: ObservableObject {
    
    @Published var uploadSpeedResult: Double = 0.0
    @Published var downloadSpeedResult: Double = 0.0
    @Published var timer: Timer? = nil
    @Published var progress: CGFloat = 0.01
    @Published var rotationAngleSpeed: Double =  0.0
    @Published var rotationAngleMagnetic: Double =  0.0
    @Published var magneticResult: Double =  0.0

    let magnetic = MagnetometerManager()
    
    func startMagneticTest() {
        stopMagneticTest()
        magneticTest()
        
    }
    
    func stopMagneticTest() {
        magnetic.stopMagnetometerUpdates()
        rotationAngleMagnetic = 0.0
        magneticResult = 0.0
    }
    
    func magneticTest() {
        magnetic.startMagnetometerUpdates { magneticField in
            let magneticFieldStrength = sqrt(pow(magneticField.field.x, 2) +
                                             pow(magneticField.field.y, 2) +
                                             pow(magneticField.field.z, 2))
            
            self.magneticResult = magneticFieldStrength  // Переведення в мікротесли (μT)
            self.rotationAngleMagnetic = self.magneticResult * 270 / 1000
     }
    }

    func startSpeedTest() {
        DispatchQueue.main.async {
            self.downloadSpeedResult = 0.0
            self.uploadSpeedResult = 0.0
            self.progress = 0.01
            self.rotationAngleSpeed = 0.0
        }
        stopSpeedTest()
        speedTest()
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            self.speedTest()
        }
    }
    
    func stopSpeedTest() {
        timer?.invalidate()
              timer = nil
              DispatchQueue.main.async {
                  self.downloadSpeedResult = 0.0
                  self.uploadSpeedResult = 0.0
                  self.progress = 0.01
                  self.rotationAngleSpeed = 0.0
              }
    }
    
    func speedTest() {
        self.downloadSpeedTest()
        self.uploadSpeedTest()
        DispatchQueue.main.async {
            let approximateResult = (self.uploadSpeedResult + self.downloadSpeedResult) / 2
            
            

            if approximateResult <= 10 { self.progress = CGFloat(approximateResult * 0.18 / 10)}
            else if approximateResult <= 50 { self.progress =  CGFloat(0.18 + ((approximateResult - 10) * 0.09 / 40))}
            else if approximateResult <= 100 { self.progress =  CGFloat(0.27 + (approximateResult - 50) * 0.09 / 50)}
            else if approximateResult <= 250 { self.progress =  CGFloat(0.36 + (approximateResult - 150) * 0.09 / 150)}
            else if approximateResult <= 500 { self.progress =  CGFloat(0.45 + (approximateResult - 250) * 0.09 / 250)}
            else if approximateResult <= 750 { self.progress =  CGFloat(0.55 + (approximateResult - 250) * 0.09 / 250)}
            else if approximateResult <= 1000 { self.progress =  CGFloat(0.64 + (approximateResult - 250) * 0.09 / 250)}
            else if approximateResult >= 1000 { self.progress =  CGFloat(0.73)}

            
            self.rotationAngleSpeed = self.progress * 270 / 0.73
        }
    }

    func downloadSpeedTest() {
        testDownloadSpeed { downloadSpeed in
            DispatchQueue.main.async {
                withAnimation {
                    self.downloadSpeedResult = downloadSpeed
                }
            }
        }
    }
        
    func uploadSpeedTest() {
        testUploadSpeed { uploadSpeed in
            DispatchQueue.main.async {
                withAnimation {
                    self.uploadSpeedResult = uploadSpeed
                }
            }
        }
    }
        
    func testDownloadSpeed(completion: @escaping (Double) -> Void) {
        let url = URL(string: "https://www.speedtest.net")!
        let startTime = CFAbsoluteTimeGetCurrent()
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let response = response as? HTTPURLResponse else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(-1.0) // Return -1 if there is an error
                return
            }
            
            let downloadTime = CFAbsoluteTimeGetCurrent() - startTime
            let downloadSpeed = Double(data?.count ?? 0) / downloadTime / 1024 / 2 // Convert to Mbps
            
            completion(downloadSpeed)
        }
        task.resume()
    }

    func testUploadSpeed(completion: @escaping (Double) -> Void) {
        let uploadStartTime = CFAbsoluteTimeGetCurrent()
        let url = URL(string: "https://www.speedtest.net")!
        var uploadRequest = URLRequest(url: url)
        uploadRequest.httpMethod = "POST" // For example, a POST request
        uploadRequest.httpBody = Data() // You can include your payload here
        
        let uploadTask = URLSession.shared.dataTask(with: uploadRequest) { (data, _, _) in
            let uploadTime = CFAbsoluteTimeGetCurrent() - uploadStartTime
            let uploadSpeed = Double(data?.count ?? 0) / uploadTime / 1024 * 2// Convert to Mbps
            
            completion(uploadSpeed)
        }
        uploadTask.resume()
    }
}
        
class MagnetometerManager {
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    
    func startMagnetometerUpdates(completion: @escaping (_ magneticField: CMCalibratedMagneticField) -> Void) {
        guard motionManager.isMagnetometerAvailable else {
            print("Магнітометр недоступний на цьому пристрої")
            return
        }
        
        motionManager.magnetometerUpdateInterval = 1.0 / 60.0  // Частота оновлення в секундах
        
        motionManager.startMagnetometerUpdates(to: queue) { (data, error) in
            if let error = error {
                print("Помилка при отриманні даних магнітометра: \(error.localizedDescription)")
                return
            }
            
            if let magneticField = data?.magneticField {
                let calibratedField = CMCalibratedMagneticField(field: magneticField, accuracy: .uncalibrated)
                DispatchQueue.main.async {
                    completion(calibratedField)
                }
            }
        }
    }
    
    func stopMagnetometerUpdates() {
        motionManager.stopMagnetometerUpdates()
    }
}
    

