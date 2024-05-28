//
//  ScanView.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 21.05.2024.
//

import SwiftUI

struct ScanView: View {
    
    @Binding var selection: Int
    
    @EnvironmentObject var vm: ScanViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text("Scan")
                            .foregroundStyle(.white)
                            .font(Font.title2.weight(.semibold))
                            .padding(.trailing, isSE ? 110 : 120)
                        
                        NavigationLink {
                            SettingsView()
                                .navigationBarBackButtonHidden()
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
                        withAnimation {
                            vm.scanButton()
                        }
                    } label: {
                        Text(vm.buttonText)
                            .foregroundStyle(.blue)
                            .font(Font.largeTitle.weight(.semibold))
                        
                    }.frame(width: 300, height: 300)
                        .background(Image(vm.isScanning ? "scanning.button" : "start.scan.button"))
                        .padding(.bottom, isSE ? 28 : 52)
                        .disabled(vm.isScanning)
                    
                    HStack {
                        Text("Found devices")
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                            if vm.devices.isEmpty {
                                NavigationLink {
                                    HistoryView()
                                        .environmentObject(vm)
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    Text("History")
                                        .foregroundStyle(.blue)
                                }
                                
                            } else {
                                NavigationLink {
                                    SeeAllView(devices: $vm.devices)
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    Text(vm.devices.isEmpty ? "History" : "See all")
                                        .foregroundStyle(.blue)
                                }
                            }
                    }.padding(.horizontal, 32)
                        .padding(.bottom, 8)
                    
                    VStack {
                        if vm.devices.isEmpty {
                            
                            Image("not.found")
                                .opacity(0.3)
                                .padding(.top, isSE ? 10 : 42)
                            
                        } else {
                            VStack(spacing: 8) {
                                ForEach(vm.devices, id: \.id) {device in
                                    NavigationLink {
                                        DeviceDetailView(device: device)
                                            .environmentObject(vm)
                                            .navigationBarBackButtonHidden()
                                          
                                    } label: {
                                        DeviceShortView(device: device)
                                    }
                                }
                            }.padding(.horizontal)
                                .padding(.bottom, 60)
                            
                        }
                    }
                    
                    Spacer()
                }
            }.background(Color.black.ignoresSafeArea())
        }            .alert(isPresented: $vm.bluetoothAlert) {
            Alert(title: Text(vm.alertTitle), message: Text(vm.alertText), dismissButton: .default(Text("OK")))
        }

    }
}

#Preview {
    ContentView()
}
