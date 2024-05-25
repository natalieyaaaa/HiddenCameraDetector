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
    @State private var progress: CGFloat = 0.73
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
                    .trim(from: 0.0, to: progress)
                                  .stroke(
                                      style: StrokeStyle(
                                          lineWidth: 25,
                                          lineCap: .round
                                      )
                                  )
                                  .foregroundColor(.blue)
                                  .rotationEffect(.degrees(-220))
                                  .frame(width: 250, height: 250)
                                  .animation(.easeInOut(duration: 2.0), value: progress)
                
                Image("numbers")
                    .offset(y: -15)
            }
            
            
            Spacer()
        }.background(Color.black)
            .onAppear {
                let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    vm.downloadSpeedTest()
                    progress = vm.downloadSpeed >= 1000.0 ? 0.73 : Double(vm.downloadSpeed / 1375 )
                    
                }
            }
    }
}
#Preview {
    ToolsView()
}
