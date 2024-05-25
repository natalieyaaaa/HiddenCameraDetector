//
//  ContentView.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 21.05.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var selection = 1
    @StateObject var vm = ScanViewModel()
    @StateObject var tvm = ToolsViewModel()
    
    var body: some View {
        ZStack {
            Group {
                if selection == 1 {
                    ScanView(selection: $selection)
                        .environmentObject(vm)
                } else if selection == 2 {
                    CameraDetectorView()
                } else if selection == 3 {
                    ToolsView()
                        .environmentObject(tvm)
                } else if selection == 4 {
                    GuidesView()
                }
                
            }.zIndex(1)
            
            VStack {
                
                Spacer()
                
                HStack {
                    Button {
                        selection = 1
                    } label: {
                        VStack(spacing: 4) {
                            Image("scan")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32)
                            
                            Text("Scan")
                                .font(.caption)
                        }.foregroundStyle(selection == 1 ? .blue : .white)
                    }
                    
                    Spacer()
                    
                    Button {
                        selection = 2
                    } label: {
                        VStack(spacing: 4) {
                            Image("camera.detector")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32)
                            
                            Text("Camera Detector")
                                .font(.caption)
                        }.foregroundStyle(selection == 2 ? .blue : .white)
                    }
                    
                    Spacer()
                    
                    Button {
                        selection = 3
                    } label: {
                        VStack(spacing: 4) {
                            Image("tools")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32)
                            
                            Text("Tools")
                                .font(.caption)
                        }.foregroundStyle(selection == 3 ? .blue : .white)
                    }
                    
                    Spacer()
                    
                    Button {
                        selection = 4
                    } label: {
                        VStack(spacing: 4) {
                            Image("guides")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32)
                            
                            Text("Guides")
                                .font(.caption)
                        }.foregroundStyle(selection == 4 ? .blue : .white)
                    }
                }.padding(.horizontal, 27)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                    .background(Color.tabbarBlack)
                        .cornerRadius(46)
                        .shadow(color: Color(red: 0.93, green: 0.97, blue: 1).opacity(0.15), radius: 15, x: 0, y: -4)
                    .offset(y: isSE ? 25 : 50)
                
            }.zIndex(2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }.background(Color.black)
    }
}

#Preview {
    ContentView()
}
