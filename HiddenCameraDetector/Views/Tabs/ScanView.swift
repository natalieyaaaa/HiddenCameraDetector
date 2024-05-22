//
//  ScanView.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 21.05.2024.
//

import SwiftUI

struct ScanView: View {
    @Binding var selection: Int
    
    @StateObject var bluetoothManager = BluetoothManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text("Scan")
                        .foregroundStyle(.white)
                        .font(Font.title2.weight(.semibold))
                        .padding(.trailing, isSE ? 110 : 120)
                    
                    Button {
                        selection = 4
                    } label: {
                        Image("settings")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28)
                    }
                }.padding(.horizontal)
                
                VStack(spacing: 8) {
                    Text("Scanner")
                        .font(Font.largeTitle.weight(.bold))
                    Text("Detect potentially suspicious devices on the\n current network")
                        .multilineTextAlignment(.center)
                    
                }.foregroundStyle(.white)
                    .padding(.top, isSE ? 10 : 40)
                    .padding(.bottom, 32)
                
                Button {
                    bluetoothManager.centralManager.scanForPeripherals(withServices: nil, options: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        for i in bluetoothManager.peripherals { print(i.ipAdress, i.name)
                            bluetoothManager.centralManager.stopScan()}
                    }
                } label: {
                    Text("Start")
                        .foregroundStyle(.blue)
                        .font(Font.largeTitle.weight(.semibold))
                    
                }.frame(width: 300, height: 300)
                    .background(Image("start.scan.button"))
                    .padding(.bottom, isSE ? 28 : 52)
                
                HStack {
                    Text("Found devices")
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Button {
                        selection = 5
                    } label: {
                        Text("History")
                            .foregroundStyle(.blue)
                    }
                }.padding(.horizontal, 32)
                
                VStack {
                    Image("not.found")
                        .opacity(0.3)
                        .padding(.top, isSE ? 10 : 42)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
