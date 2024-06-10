//
//  OnbTemplate2.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 10.06.2024.
//

import SwiftUI

struct OnbTemplate2: View {
        
        @Binding var selection: Int
        
        @State private var scale = 1.0
        
        var image: String
        var background: String
        var title: String
        var text: String
        
        var body: some View {
            ZStack {
                if selection != 1 {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: isSE ? 250 : 300, height: isSE ? 450 : 500)
                        .padding(.bottom, 60)
                }
                
                VStack {
                    Spacer()
                    
                    Rectangle()
                        
                        .foregroundStyle(LinearGradient(colors: [.black, .clear], startPoint: .center, endPoint: .top))
                        .frame(height: isSE ? UIScreen.main.bounds.height / 1.3 : UIScreen.main.bounds.height / 1.6 )
                        .offset(y: 35)
                       
                }
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    Text(title)
                        .multilineTextAlignment(.center)
                        .font(Font.largeTitle.bold())
                        .foregroundStyle(.white)
                    
                    Text(text)
                        .multilineTextAlignment(.center)
                        .font(Font.system(size: isSE ? 15 : 16))
                        .foregroundStyle(.gray)
                    
                    HStack(spacing: 8) {
                        ForEach(1...4, id: \.self) { item in
                            if selection == item {
                                RoundedRectangle(cornerRadius: 4)
                                    .frame(width: 24, height: 8)
                                    .foregroundStyle(.blue)
                            } else {
                                
                                Circle()
                                    .frame(width: 8, height: 8)
                                    .foregroundStyle(.blue.opacity(0.3))
                            }
                        }
                    }
                    
                    Button {
                        selection += 1
                        triggerHapticFeedback()
                    } label: {
                        HStack {
                          
                            Spacer()
                            
                            Text("Continue")
                                .font(Font.system(size: 19, weight: .medium))
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                        
                        }.padding(20)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 35)
                                .foregroundStyle(.blue))
                    }.padding(.bottom)
                        .scaleEffect(scale)
                    
                    
                }.padding(.horizontal)
            }.background(Image(background)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea())
                .onAppear {
                    withAnimation(.linear(duration: 0.5).repeatForever()) {
                        scale = 0.96
                    }
                }
        }
}

#Preview {
    Onb2()
}
