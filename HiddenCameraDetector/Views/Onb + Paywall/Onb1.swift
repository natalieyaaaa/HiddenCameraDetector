//
//  Onb1.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 10.06.2024.
//

import SwiftUI

struct Onb1: View {
    @State var selection = 1
    
    var body: some View {
        VStack {
            if selection == 1 {
                OnbTemplate1(selection: $selection, image: "", background: "bg1", title: "Detect Hidden\n Cameras", text: "Scan rooms with your device to detect hidden\n cameras without manual inspection.")
            } else if selection == 2 {
                OnbTemplate1(selection: $selection, image: "image2", background: "bg2", title: "Simple and Efficient\n Scanner", text: "Effortlessly detect hidden cameras with\n advanced scanning technology.")
            } else if selection == 3 {
                OnbTemplate1(selection: $selection, image: "image3", background: "bg3", title: "Suspicious Devices\n Detection", text: "Scan your current Wi-Fi network to detect\n hidden cameras.")
            } 
        }
    }
}

#Preview {
    Onb1()
}
