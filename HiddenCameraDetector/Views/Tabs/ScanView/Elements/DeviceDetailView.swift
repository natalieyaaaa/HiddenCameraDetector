//
//  DeviceDetalView.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 23.05.2024.
//

import SwiftUI

struct DeviceDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: ScanViewModel
    
    @ObservedObject var device: Device
        
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("arrow.back")
                }
                
                Text("Device Details")
                    .foregroundStyle(.white)
                    .font(Font.title2.weight(.semibold))
                    .padding(.leading, isSE ? 90 : 90)
                
                Spacer()
                
            }.padding(.bottom, 40)
            
            
            VStack(spacing: 4) {
                DetailPoints(text: "Name", value: device.name ?? "No name")
                DetailPoints(text: "Connection Type", value: device.connectionType ?? "Unknown")
                DetailPoints(text: "IP Address", value: device.ipAdress ?? "Not available")
                DetailPoints(text: "MAC Address", value: "Not Available")
                DetailPoints(text: "Hostname", value: "Not Available")
            }.padding(.bottom, 24)
            
            Text(device.isSuspicious ? "Don't trust" : "Trust")
                .foregroundStyle(device.isSuspicious ? .suspiciousRed : .green)
            
            Spacer()
            
            Button {
                withAnimation {
                    device.isSuspicious.toggle()
                }
            } label: {
                Text(device.isSuspicious ? "Mark as secure" : "Mark as suspicious")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(device.isSuspicious ? .suspiciousRed : .blue))
            }.padding(.bottom, 70)

        }.padding(.horizontal)
            .background(Color.black)

    }
}

//"#Preview {
//    DeviceDetailView(name: "fdvdfg", connectionType: "dfdfg", ipAdress: "fdgdf", isSuspicious: .constant(true))
//}"

struct DetailPoints: View {
    
    var text: String
    var value: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(Font.headline.weight(.medium))
                .foregroundStyle(.white.opacity(0.5))
            
            Spacer()
            
            Text(value)
                .foregroundStyle(.white)
                .font(Font.headline.weight(.medium))
        }.padding()
            .background(RoundedRectangle(cornerRadius: 27)
                .foregroundStyle(.tabbarBlack))
    }
}
