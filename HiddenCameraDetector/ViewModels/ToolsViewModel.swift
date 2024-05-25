//
//  ToolsViewModel.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 24.05.2024.
//

import Foundation
import SpeedcheckerSDK
import CoreLocation
import Network


class ToolsViewModel: ObservableObject {
    
    @Published var uploadSpeed: Double = 0.0
    @Published var downloadSpeed: Double = 0.0
    
    func downloadSpeedTest() {
        testDownloadSpeed { downloadSpeed in
            print("Download speed: \(downloadSpeed) Mbps")
        }

 
        }
        
    func uploadSpeedTest() {
        testUploadSpeed {uploadSpeed in
            print("Upload speed: \(uploadSpeed) Mbps")
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
                print(downloadTime)
                let downloadSpeed = Double(data?.count ?? 0) / downloadTime / 1024 / 2// Mbps
            
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
                print(uploadTime)

                let uploadSpeed = Double(data?.count ?? 0) / uploadTime / 1024 * 2  // Mbps
                completion(uploadSpeed)
            }
            uploadTask.resume()
        }
}
        
    

