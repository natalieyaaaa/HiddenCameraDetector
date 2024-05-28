//
//  CameraDetectorView.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 21.05.2024.
//

import SwiftUI

struct CameraDetectorView: View {
    
    @State var color: UIColor = .red
    @State var opacity: Double = 1
    @State var hasTapped = false
    
    @EnvironmentObject var vm: CameraViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                CameraView(viewModel: vm)
                    .ignoresSafeArea()
                
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundStyle(Color(color).opacity(opacity))
                
                VStack {
                    
                    HStack {
                        Spacer()
                            .frame(width: 28)
                        
                        Spacer()
                        
                        Text("Camera Detector")
                            .foregroundStyle(.white)
                            .font(Font.title2.weight(.semibold))
                        
                        Spacer()
                        NavigationLink {
                            SettingsView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            Image("settings")
                        }
                    }.padding()
                        .padding(.top, 40)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .ignoresSafeArea()
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.black))
                        .offset(y: isSE ? -33 : -47)
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Button {
                            withAnimation {
                                color = .red
                            }
                        } label: {
                            Circle()
                                .stroke(lineWidth: 3)
                                .frame(width: 28, height: 28)
                                .foregroundStyle(.red)
                                .overlay {
                                    if color == .red {
                                        Circle()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(.red)
                                    }
                                }
                        }
                        
                        Button {
                            withAnimation {
                                color = .green
                                
                            }
                        } label: {
                            Circle()
                                .stroke(lineWidth: 3)
                                .frame(width: 28, height: 28)
                                .foregroundStyle(.green)
                                .overlay {
                                    if color == .green {
                                        Circle()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(.green)
                                    }
                                }
                        }
                        
                        Button {
                            withAnimation {
                                color = .blue
                            }
                        } label: {
                            Circle()
                                .stroke(lineWidth: 3)
                                .frame(width: 28, height: 28)
                                .foregroundStyle(.blue)
                                .overlay {
                                    if color == .blue {
                                        Circle()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(.blue)
                                    }
                                }
                        }
                    }.padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 30)
                    
                    Spacer()
                    
                    Text("Tap to start scanning, then move the camera\n to look for tracking devices.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(Color.blue.cornerRadius(16))
                        .padding(.bottom, isSE ? 90 : 70)
                    
                }
            }.onTapGesture {
                if hasTapped != true {
                    withAnimation {
                        opacity = 0.3
                        hasTapped = true
                    }
                }
            }.alert(isPresented: $vm.showAlert) {
                Alert(title: Text("Could not access camera"), message: Text("Please reload the app and try again"))
            }
        }
    }
}

#Preview {
    ContentView()
}
