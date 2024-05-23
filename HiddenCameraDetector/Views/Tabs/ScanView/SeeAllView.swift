//
//  SeeAllView.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 23.05.2024.
//

import SwiftUI

struct SeeAllView: View {
    
    @Binding var devices: [DeviceInfo]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("arrow.back")
                }
                
                Text("All")
                    .foregroundStyle(.white)
                    .font(Font.title2.weight(.semibold))
                    .padding(.leading, isSE ? 110 : 120)
            }.padding(.bottom, 20)
            
            ScrollView {
                ForEach(devices, id: \.id) { device in
                    NavigationLink {
                        
                    } label: {
                        DeviceShortView(isSuspicious: false, name: device.name)
                    }
                }
            }
            
        }.padding(.bottom, 40)
            .padding(.horizontal)
    }
}

//#Preview {
//    SeeAllView()
//}
