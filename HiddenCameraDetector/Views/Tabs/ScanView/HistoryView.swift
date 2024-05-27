//
//  HistoryView.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 23.05.2024.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject var vm: ScanViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var allEntities: [Device] = []
    @State var cleanAlert = false
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("arrow.back")
                }
                Spacer()
                Text("History")
                    .foregroundStyle(.white)
                    .font(Font.title2.weight(.semibold))
                Spacer()
                
                Button {
                    cleanAlert.toggle()
                } label: {
                    Text("Clean")
                        .foregroundStyle(.suspiciousRed)
                }
            }.padding(.bottom, 10)
            
            ScrollView {
                if allEntities.isEmpty {
                    Text("No devices yet")
                        .foregroundStyle(.white.opacity(0.5))
                        .font(Font.title3.weight(.semibold))
                } else {
                    ForEach(allEntities, id: \.id) { device in
                        Button {
                            withAnimation {
                                vm.coreData.deleteEntity(entity: device)
                                allEntities.removeAll(where: {$0.id == device.id})
                            }
                        } label: {
                            HistoryDeviceView(device: device)
                        }.padding(.horizontal)
                    }
                }
            }
            
        }
            .background(Color.black)
            .onAppear {
                allEntities = vm.coreData.allEntities()
            }
            .alert(isPresented: $cleanAlert) {
                Alert(title: Text("Are you sure you want to delete all history?"), primaryButton: .default(Text("Clean"), action: {
                    withAnimation {
                        vm.coreData.deleteAllEntities()
                        allEntities.removeAll()
                    }
                }), secondaryButton: .cancel())
            }
    }
}

#Preview {
    HistoryView()
}

struct HistoryDeviceView: View {
    var device: Device
    var body: some View {
        
        HStack(spacing: 12) {
            Image(device.connectionType == "Wi-Fi" ? "wifi" : "bluetooth")
                .renderingMode(.template)
                .foregroundStyle(device.isSuspicious ? .suspiciousRed : .blue)
            
            VStack(alignment: .leading) {
                Text(device.name!)
                    .foregroundStyle(.white)
                    .font(Font.headline.weight(.medium))
                    .multilineTextAlignment(.leading)
                
                Text(device.date!)
                    .foregroundStyle(.white.opacity(0.5))
            }
            Spacer()
            
            if device.isSuspicious {
                Text("Attention")
                    .foregroundStyle(.red)
                    .font(Font.headline.weight(.medium))
                Spacer()
            }
            Image(systemName:"trash")
                .foregroundStyle(.suspiciousRed)
            
        }.padding()
            .background(RoundedRectangle(cornerRadius: 36)
                .stroke(lineWidth: 1)
                .foregroundStyle(device.isSuspicious ? .suspiciousRed : .blue))
        
    }
}
