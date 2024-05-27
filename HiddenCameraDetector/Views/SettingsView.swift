//
//  SettingsView.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 27.05.2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("arrow.back")
                }
                
                Spacer()
                
                Text("Settings")
                    .foregroundStyle(.white)
                    .font(Font.title2.weight(.semibold))
                
                Spacer()
                Spacer()
                    .frame(width: 28)
            }.padding(.bottom, isSE ? 16 : 32)
            
            Button {
            } label: {
                
                HStack(spacing: 16) {
                    Image("crown")
                    Text("Upgrade to PRO")
                        .foregroundStyle(.white)
                        .font(Font.title2.weight(.semibold))
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 32).foregroundStyle(.blue))
            }.padding(.bottom, 24)
            
            VStack {
                Button {
                    
                } label: {
                    SettinsOption(image: "share", text: "Share App")
                }
                
                Button {
                    
                } label: {
                    SettinsOption(image: "rate", text: "Rate Our App")
                }
                Button {
                    
                } label: {
                    SettinsOption(image: "contact", text: "Contact Us")
                }
                Button {
                    
                } label: {
                    SettinsOption(image: "terms", text: "Terms of Use")
                }
                Button {
                    
                } label: {
                    SettinsOption(image: "privacy", text: "Privacy Policy")
                }
                
            }
            
            Spacer()
            
        }.padding(.horizontal)
            .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    SettingsView()
}

struct SettinsOption: View {
    
    var image: String
    var text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(image)
            Text(text)
                .foregroundStyle(.white)
                .font(Font.title3.weight(.medium))
        }.frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(RoundedRectangle(cornerRadius: 32).foregroundStyle(.tabbarBlack))
    }
}
