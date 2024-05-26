//
//  ToolsViewModel.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 24.05.2024.
//

import Foundation
import SwiftUI


class ToolsViewModel: ObservableObject {
    
    @Published var uploadSpeedResult: Double = 0.0
    @Published var downloadSpeedResult: Double = 0.0
    @Published var timer: Timer? = nil
    @Published var progress: CGFloat = 0.01
    @Published var rotationAngle: Double = -135


    func startTest() {
        test()
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            self.test()
        }
    }
    
    func stopTest() {
        timer?.invalidate()
        timer = nil
    }
    
    func test() {
        self.downloadSpeedTest()
        self.uploadSpeedTest()
        DispatchQueue.main.async {
            let approximateResult = (self.uploadSpeedResult + self.downloadSpeedResult) / 2
            
            

            if approximateResult <= 10 { self.progress = CGFloat(approximateResult * 0.18 / 10)}
            else if approximateResult <= 50 { self.progress =  CGFloat(0.18 + ((approximateResult - 10) * 0.09 / 40))}
            else if approximateResult <= 100 { self.progress =  CGFloat(0.27 + (approximateResult - 50) * 0.09 / 50)}
            else if approximateResult <= 250 { self.progress =  CGFloat(0.36 + (approximateResult - 150) * 0.09 / 150)}
            else if approximateResult <= 500 { self.progress =  CGFloat(0.45 + (approximateResult - 250) * 0.09 / 250)}
            else if approximateResult < 750 { self.progress =  CGFloat(0.55 + (approximateResult - 250) * 0.09 / 250)}
            else if approximateResult < 1000 { self.progress =  CGFloat(0.64 + (approximateResult - 250) * 0.09 / 250)}
            else if approximateResult >= 1000 { self.progress =  CGFloat(0.73)}

            
            if self.progress < 0.36 {
                self.rotationAngle = -(self.progress * 5 / 0.01)
            } else {
                self.rotationAngle = self.progress * 5 / 0.01
            }
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
        
    

