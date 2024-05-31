//
//  DeviceShortView.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 23.05.2024.
//

import SwiftUI

struct DeviceShortView: View {
    
    @ObservedObject var device: Device
    
    var body: some View {
        HStack(spacing: 12) {
            Image(device.connectionType == "Wi-Fi" ? "wifi" : "bluetooth")
                .renderingMode(.template)
                .foregroundStyle(device.isSuspicious ? .suspiciousRed : .blue)
            
            Text(device.name!)
                .foregroundStyle(.white)
                .font(Font.headline.weight(.medium))
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            if device.isSuspicious {
                HStack(spacing: 5) {
                    Text("Attention")
                        .foregroundStyle(.red)
                        .font(Font.headline.weight(.medium))
                    Image("sus")
                        .renderingMode(.template)
                        .foregroundStyle(.suspiciousRed)
                }
                Spacer()
            }
                Image("arrow")
        
        }.padding()
            .background(RoundedRectangle(cornerRadius: 36)
                .stroke(lineWidth: 1)
                .foregroundStyle(device.isSuspicious ? .suspiciousRed : .blue))
        
    }
}

//#Preview {
//    DeviceShortView(isSuspicious: .constant(false), name: .constant("gfdfcuydsgfisdgi"), openDevice: .constant(6))
//}
