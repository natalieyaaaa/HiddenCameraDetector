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
    
    var device: Device
    
    @State var isSuspicious: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    vm.coreData.updateEntity()
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
            
            Text(isSuspicious ? "Don't trust" : "Trust")
                .foregroundStyle(isSuspicious ? .suspiciousRed : .green)
            
            Spacer()
            
            Button {
                withAnimation {

                }
            } label: {
                Text(isSuspicious ? "Mark as secure" : "Mark as suspicious")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(isSuspicious ? .suspiciousRed : .blue))
            }.padding(.bottom, 70)
                .onChange(of: isSuspicious) { newValue in
                    
                    device.isSuspicious = newValue
                    
                }
            
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
