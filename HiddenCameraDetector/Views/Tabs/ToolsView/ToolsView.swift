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
                        Image("settings")
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
                
            }.padding(.bottom, 60)
            
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
                          .frame(width: 250, height: 250)
                
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
                                  .frame(width: 250, height: 250)
                                  .animation(.easeInOut(duration: 2.0), value: vm.progress)
                
                Image("numbers")
                    .offset(y: -15)
                
                Image("path") // Replace this with your arrow image
                    .offset(y: -30)
                    .rotationEffect(Angle(degrees: vm.rotationAngle))
                    .animation(.easeInOut(duration: 1), value: vm.rotationAngle)
                
            }.padding(.bottom, 64)
            
            HStack(spacing: 28) {
                SpeedOption(image: "download", text: "Download", value: $vm.downloadSpeedResult)
                SpeedOption(image: "upload", text: "Upload", value: $vm.uploadSpeedResult)
            }
            
            Spacer()
        }.background(Color.black)
        
            .onAppear {
                withAnimation {
                    vm.startTest()
                }
                       }
            .onDisappear {
                vm.stopTest()
                vm.downloadSpeedResult = 0.0
                vm.uploadSpeedResult = 0.0
                vm.progress = 0.1
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
        VStack(alignment: .leading, spacing: 24) {
            HStack(spacing: 16) {
                Image(image)
                Text(text)
                    .foregroundStyle(.white)
                    .font(Font.title3.weight(.medium))
            }
            
            HStack {
                Text(String(format: "%.1f", value))
                    .font(Font.title.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 90, alignment: .leading)

                Text("Mbps")
                    .foregroundStyle(.white)
            }
        }.padding()
            .background(RoundedRectangle(cornerRadius: 24)
                .foregroundStyle(.tabbarBlack)
                .frame(width: 180))
    }
}
