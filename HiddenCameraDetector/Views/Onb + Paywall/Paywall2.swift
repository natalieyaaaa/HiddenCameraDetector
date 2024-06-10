//
//  Paywall2.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 10.06.2024.
//

import SwiftUI

struct Paywall2: View {
    @State private var scale = 1.0
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {

            VStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .frame(width: 20)
                        .foregroundStyle(.gray)
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                Spacer()
                
                Rectangle()
                    .foregroundStyle(LinearGradient(colors: [.black, .clear], startPoint: .center, endPoint: .top))
                    .frame(height: isSE ? UIScreen.main.bounds.height / 1.3 : UIScreen.main.bounds.height / 1.6 )
                    .offset(y: 35)
                
            }
            
            Image("paywall")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: isSE ? 215 : UIScreen.main.bounds.width)
                .padding(.bottom, 170)
            
            
            VStack(spacing: 10) {
                Spacer()
                
                Text("Detect hidden cameras\n without limits")
                    .multilineTextAlignment(.center)
                    .font(Font.system(size: isSE ? 30 : 33, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Start a 3-day free trial of Hidden Camera Detector app with no limits for $6.99/week.")
                    .multilineTextAlignment(.center)
                    .font(Font.system(size: isSE ? 16 : 18))
                    .foregroundStyle(.gray)
                
                HStack(spacing: 8) {
                    ForEach(1...3, id: \.self) { item in
                    Circle()
                            .frame(width: 8, height: 8)
                            .foregroundStyle(.blue.opacity(0.3))
                    }
                    
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 24, height: 8)
                        .foregroundStyle(.blue)
                }

                Button {
                    triggerHapticFeedback()
                } label: {
                   Text("Continue")
                        .font(Font.system(size: 17, weight: .medium))
                        .foregroundStyle(.white)
                }.padding(20)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 35)
                        .foregroundStyle(.blue))
                    .scaleEffect(scale)
                    .padding(.bottom, 5)
                
                HStack {
                    
                    Button {
                        
                    } label: {
                        Text("Privacy Policy")
                            .font(Font.system(size: 15, weight: .regular))
                            .foregroundStyle(.gray)
                        
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Restore")
                            .font(Font.system(size: 15, weight: .regular))
                            .foregroundStyle(.gray)
                        
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Terms of Use")
                            .font(Font.system(size: 15, weight: .regular))
                            .foregroundStyle(.gray)
                        
                    }
                }.padding(.horizontal)
                
                
            }.padding(.horizontal)
        }.background(Image("")
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
    Paywall2()
}
