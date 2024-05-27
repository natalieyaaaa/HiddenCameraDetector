//
//  ToolsView.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 21.05.2024.
//

import SwiftUI

struct ToolsView: View {
    
    @EnvironmentObject var vm: ToolsViewModel
    @State var selection = 1
    
    @State private var offsetX: CGFloat = 0.0
    
    var body: some View {
        VStack {
            
            HStack {
                
                if selection == 2 {
                    Spacer()
                        .frame(width: 28)
                }
                Spacer()
                
                Text("Tools")
                    .foregroundStyle(.white)
                    .font(Font.title2.weight(.semibold))
                
                Spacer()
                
                if selection == 2 {
                    NavigationLink {
                        
                    } label: {
                        Image("magnetic.info")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28)
                    }
                }
            }.frame(height: 40)
                .padding(.horizontal)
                .padding(.bottom)
            
            
            ZStack {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.tabbarBlack)
                        .frame(width: 285, height: 44)
                    
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.blue)
                        .frame(width: 150, height: 44)
                        .offset(x: offsetX, y: 0)
                        .animation(.easeInOut(duration: 0.5), value: offsetX)
                }
                HStack(spacing: 45) {
                    Button {
                        withAnimation {
                            selection = 1
                            offsetX = 0
                        }
                    } label: {
                        Text("Speed Test")
                            .foregroundStyle(.white)
                            .font(Font.title3.weight(.medium))
                    }
                    
                    Button {
                        withAnimation {
                            selection = 2
                            offsetX = 135
                        }
                    } label: {
                        Text("Magnetic")
                            .foregroundStyle(.white)
                            .font(Font.title3.weight(.medium))
                    }
                }
                
            }.padding(.bottom, isSE ? 30 : 60)
            
            if selection == 1 {
                ZStack {
                    Circle()
                        .trim(from: 0.0, to: 0.73)
                        .stroke(
                            style: StrokeStyle(
                                lineWidth: 25, // Adjust the line width as needed
                                lineCap: .round
                            )
                        )
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(-220)) // Start the stroke from the top
                        .frame(width: isSE ? 200 : 250, height: isSE ? 200 : 250)
                    
                    Circle()
                        .trim(from: 0.0, to: vm.progress)
                        .stroke(
                            style: StrokeStyle(
                                lineWidth: 25,
                                lineCap: .round
                            )
                        )
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(-220))
                        .frame(width: isSE ? 200 : 250, height: isSE ? 200 : 250)
                        .animation(.easeInOut(duration: 2.0), value: vm.progress)
                    
                    Image("numbers")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .offset(y: -15)
                        .frame(width: isSE ? 155 : 200, height: isSE ? 155 : 200)
                    
                    Image("path") // Replace this with your arrow image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: isSE ? 50 : 90, height: isSE ? 50 : 90)
                        .offset(y: -30)
                        .rotationEffect(Angle(degrees: -135))
                        .rotationEffect(Angle(degrees: vm.rotationAngleSpeed))
                        .animation(.easeInOut(duration: 2), value: vm.rotationAngleSpeed)
                    
                }.padding(.bottom, isSE ? 16 : 48)
                    .onAppear {
                        withAnimation {
                            
                            vm.startSpeedTest()
                        }
                    }
                    .onDisappear {
                        vm.stopSpeedTest()
                        vm.downloadSpeedResult = 0.1
                        vm.uploadSpeedResult = 0.1
                    }
                
                HStack(spacing: 18) {
                    SpeedOption(image: "download", text: "Download", value: $vm.downloadSpeedResult)
                    SpeedOption(image: "upload", text: "Upload", value: $vm.uploadSpeedResult)
                    
                }
                Spacer()
                
                Button {
                    withAnimation {
                        if vm.downloadSpeedResult == 0.0 {
                            vm.startSpeedTest()
                        } else {
                            vm.stopSpeedTest()
                        }
                    }
                } label: {
                    Text(vm.timer == nil ? "Start" : "Stop")
                        .foregroundStyle(.white)
                        .font(Font.title3.weight(.medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(.blue))
                }.padding()
                
                
            }
            
            if selection == 2 {
                ZStack {
                    MagneticPic()
                    
                    Image("path")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: isSE ? 50 : 90, height: isSE ? 50 : 90)
                        .offset(y: -30)
                        .rotationEffect(Angle(degrees: -135))
                        .rotationEffect(Angle(degrees: vm.rotationAngleMagnetic))
                        .animation(.easeInOut(duration: 2), value: vm.rotationAngleMagnetic)
                    
                }.padding(.top, 0)
                    .padding(.bottom, isSE ? 25 : 50)
                
                    .onDisappear {
                        withAnimation {
                            vm.stopMagneticTest()
                        }
                    }
                
                HStack(spacing: 10) {
                    Text("\(Int(vm.magneticResult))")
                        .foregroundStyle(vm.magneticResult == 0.0 ? .gray : .white)
                        .font(Font.largeTitle.weight(.semibold))
                    
                    Text("μT")
                        .foregroundStyle(vm.magneticResult == 0.0 ? .gray : .white)
                    
                }.frame(width: 150)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 32)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.blue))
                
                Spacer()
                
                Button {
                    if vm.magneticResult == 0 {
                        vm.startMagneticTest()
                    } else {
                        vm.stopMagneticTest()
                    }
                } label: {
                    Text(vm.magneticResult == 0 ? "Start Scanning" : "Stop Scanning")
                        .foregroundStyle(.white)
                        .font(Font.title3.weight(.medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(.blue))
                }.padding()
                
            }
            
        }.background(Color.black)
        .padding(.bottom, isSE ? 70 : 50)
        
        .alert(isPresented: $vm.checkAlert) {
            Alert(title: Text("Unsuccessful test"), message: Text("Please make sure your Wi-Fi is turned on and try again"))
        }
        
    }
}
#Preview {
    ToolsView()
}


struct SpeedOption: View {
    var image: String
    var text: String
    
    @Binding var value: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: isSE ? 16 : 24) {
            HStack(spacing: 16) {
                Image(image)
                Text(text)
                    .foregroundStyle(.white)
                    .font(Font.title3.weight(.medium))
            }
            
            HStack {
                Text(String(format: "%.1f", value))
                    .font( isSE ? Font.title3.weight(.semibold) : Font.title.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: isSE ? 70 : 100, alignment: .leading)
                
                Text("Mbps")
                    .foregroundStyle(.white)
            }
        }.padding()
            .background(RoundedRectangle(cornerRadius: 24)
                .foregroundStyle(.tabbarBlack)
                .frame(width: isSE ? 160 : 190))
    }
}

struct MagneticPic: View {
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: 0.73)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 25, // Adjust the line width as needed
                        lineCap: .round
                    )
                )
                .foregroundColor(.white)
                .rotationEffect(.degrees(-220)) // Start the stroke from the top
                .frame(width: isSE ? 200 : 250, height: isSE ? 200 : 250)
            
            Circle()
                .trim(from: 0.0, to: 0.73)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 25, // Adjust the line width as needed
                        lineCap: .round
                    )
                )
                .foregroundColor(.red.opacity(0.5))
                .rotationEffect(.degrees(-220)) // Start the stroke from the top
                .frame(width: isSE ? 200 : 250, height: isSE ? 200 : 250)
            
            Circle()
                .trim(from: 0.0, to: 0.55)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 25, // Adjust the line width as needed
                        lineCap: .round
                    )
                )
                .foregroundColor(.red)
                .rotationEffect(.degrees(-220)) // Start the stroke from the top
                .frame(width: isSE ? 200 : 250, height: isSE ? 200 : 250)
            
            
            Circle()
                .trim(from: 0.0, to: 0.36)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 25, // Adjust the line width as needed
                        lineCap: .round
                    )
                )
                .foregroundColor(.yellow)
                .rotationEffect(.degrees(-220)) // Start the stroke from the top
                .frame(width: isSE ? 200 : 250, height: isSE ? 200 : 250)
            
            Circle()
                .trim(from: 0.0, to: 0.18)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 25, // Adjust the line width as needed
                        lineCap: .round
                    )
                )
                .foregroundColor(.blue)
                .rotationEffect(.degrees(-220)) // Start the stroke from the top
                .frame(width: isSE ? 200 : 250, height: isSE ? 200 : 250)
        }
    }
}
