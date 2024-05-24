//
//  ToolsViewModel.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 24.05.2024.
//

import Foundation
import SpeedcheckerSDK
import CoreLocation

class ToolsViewModel: ObservableObject {
    
    @Published var uploadSpeed: Double = 0.0
    @Published var downloadSpeed: Double = 0.0
    
    func checkSpeed() {
        self.testNetworkSpeed { downloadSpeed, uploadSpeed in
            print("Download Speed: \(downloadSpeed) Mbps")
            print("Upload Speed: \(uploadSpeed) Mbps")
        }
    }
    
    func testNetworkSpeed(completion: @escaping (Double, Double) -> Void) {
        let url = URL(string: "https://www.speedtest.net/ru")! // Замініть URL на той, який ви хочете протестувати

        let startTime = CFAbsoluteTimeGetCurrent()
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let response = response as? HTTPURLResponse else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(-1.0, -1.0) // Повертаємо -1, якщо виникла помилка
                return
            }

            let downloadTime = CFAbsoluteTimeGetCurrent() - startTime
            let downloadSpeed = Double(data?.count ?? 0) / downloadTime / 1024// Мбіт/с
            print("Download Speed: \(downloadSpeed) Mbps")

            let uploadStartTime = CFAbsoluteTimeGetCurrent()
            var uploadRequest = URLRequest(url: url)
            uploadRequest.httpMethod = "POST" // Наприклад, POST-запит
            uploadRequest.httpBody = Data() // Тут може бути ваше навантаження для відправки

            let uploadTask = URLSession.shared.dataTask(with: uploadRequest) { (_, _, _) in
                let uploadTime = CFAbsoluteTimeGetCurrent() - uploadStartTime
                let uploadSpeed = Double(data?.count ?? 0) / uploadTime / 1024 // Мбіт/с
                print("Upload Speed: \(uploadSpeed) Mbps")
                completion(downloadSpeed, uploadSpeed)
            }
            uploadTask.resume()
        }
        task.resume()
    }

    }

