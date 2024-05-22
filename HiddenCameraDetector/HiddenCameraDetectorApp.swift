//
//  HiddenCameraDetectorApp.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 21.05.2024.
//

import SwiftUI

@main
struct HiddenCameraDetectorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .background(Color.black.ignoresSafeArea())
        }
    }
}

extension View {
    // Is phone SE
    var isSE: Bool { return UIScreen.main.bounds.height < 680 }
    var isDevicePad: Bool { return UIDevice.current.userInterfaceIdiom == .pad }
    var screen: CGRect { return UIScreen.main.bounds }
}
