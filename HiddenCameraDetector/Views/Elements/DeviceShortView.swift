//
//  DeviceShortView.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 23.05.2024.
//

import SwiftUI

struct DeviceShortView: View {
    
    var isSuspicious: Bool
    var name: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image("bluetooth")
                .renderingMode(.template)
                .foregroundStyle(isSuspicious ? .suspiciousRed : .blue)
            
            Text(name)
                .foregroundStyle(.white)
                .font(Font.headline.weight(.medium))
            
            Spacer()
            
            if isSuspicious {
                Text("Attention")
                    .foregroundStyle(.red)
                    .font(Font.headline.weight(.medium))
                Spacer()
            }
                Image("arrow")
        
        }.padding()
            .background(RoundedRectangle(cornerRadius: 36)
                .stroke(lineWidth: 1)
                .foregroundStyle(isSuspicious ? .suspiciousRed : .blue))
        
    }
}

//#Preview {
//    DeviceShortView(isSuspicious: .constant(false), name: .constant("gfdfcuydsgfisdgi"), openDevice: .constant(6))
//}
