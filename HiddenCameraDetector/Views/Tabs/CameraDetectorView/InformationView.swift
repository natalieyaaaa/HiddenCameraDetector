//
//  InformationView.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 27.05.2024.
//

import SwiftUI

struct InformationView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack() {
            HStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image("arrow.back")
                    }
                    
                    Spacer()
                    
                    Text("Information")
                        .foregroundStyle(.white)
                        .font(Font.title2.weight(.semibold))
                    
                    Spacer()
                    Spacer()
                        .frame(width: 28)
                }
            }.padding(.horizontal)
                .frame(height: 40)
                .padding(.bottom, isSE ? 16 : 32)
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4){
                    Text("How to work the Magnetic?")
                        .foregroundStyle(.blue)
                        .font(Font.title3)
                    Text("Magnetic detects the magnetic fields that any mobile device has, whether it's a smartphone, computer or hidden camera.")
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                }.frame(width: UIScreen.main.bounds.width - 64, alignment: .leading)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(.tabbarBlack)
                    )
                InformationPoint(text: "Magnetic can be used to detect devices that cannot be seen. For example, hidden in soft toys, alarm clocks, paintings and other places inaccessible to the naked eye.")
                
                InformationPoint(text: "Open Magnetics and bring the device as close as possible to places where recording devices could potentially be hidden.")
         
               InformationPoint(text: "If a strong field is detected, there is likely a camera hidden in the object.")
            }.padding(.horizontal)

            Spacer()
            
        }.background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    InformationView()
}

struct InformationPoint: View {
    var text: String
    var body: some View {
        Text(text)
            .foregroundStyle(.white)
            .frame(width: UIScreen.main.bounds.width - 64, alignment: .leading)
            .padding()
            .background(RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.tabbarBlack)
            )
    }
}
