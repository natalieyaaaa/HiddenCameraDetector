//
//  ContentView.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 21.05.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var selection = 1
    var body: some View {
        ZStack {
            Group {
                if selection == 1 {
                    ScanView()
                } else if selection == 2 {
                    CameraDetectorView()
                } else if selection == 3 {
                    ToolsView()
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

                }
            }.zIndex(2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }.background(Color.black)
    }
}

#Preview {
    ContentView()
}
