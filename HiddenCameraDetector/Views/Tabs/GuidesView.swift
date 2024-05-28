//
//  GuidesView.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 21.05.2024.
//

import SwiftUI

struct GuidesView: View {
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                        .frame(width: 28)
                    Spacer()
                    
                    Text("Guides")
                        .foregroundStyle(.white)
                        .font(Font.title2.weight(.semibold))
                    
                    Spacer()
                    
                    NavigationLink {
                        SettingsView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        Image("settings")
                    }
                }.padding(.bottom, 15)
                
                ScrollView {
                    VStack(spacing: 8) {
                        Text("Security Tips")
                            .foregroundStyle(.gray)
                            .font(Font.system(size: 15, weight: .light))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(1...8, id: \.self) { index in

                            GuidesOption(title: sTitle[index]!, text: sText[index]!, image: "\(index)")

                        }
                        
                        Text("Cameras exposing guide")
                            .foregroundStyle(.gray)
                            .font(Font.system(size: 15, weight: .light))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(1...17, id: \.self) { index in

                            GuidesOption(title: cTitle[index]!, text: cText[index]!, image: "\(index + 8)")
                                .padding(.bottom, index == 17 ? isSE ? 70 : 50 : 0 )

                        }
                    }.padding(.horizontal)


                    
                }
                   
                
                Spacer()
            } 
            .padding(.horizontal)
            .background(Color.black.ignoresSafeArea())
        
        }
    }
    
    var sTitle = [ 1 : "Professional Security Services",
                   2 : "Social Engineering Awareness",
                   3 : "Electronic Devices",
                   4 : "Mobile Security",
                   5 : "Wi-Fi Security",
                   6 : "Regular Checks",
                   7 : "Regular Checks",
                   8 : "Privacy Settings",
    ]
    
    var sText = [ 1 : "If you have significant concerns or suspicions, consider hiring professional security services to conduct a comprehensive assessment of your premises.",
                   2 : "Be cautious with unsolicited communication, such as phone calls, emails, or messages. Verify the sender or caller’s identity, especially if they request personal information or device access.",
                   3 : "Be wary of gadgets like digital clocks or USB chargers that could hide cameras. Verify their authenticity and watch for any unusual activity.",
                   4 : "Exercise caution with your smartphones and tablets. Regularly review installed apps and their permissions. Keep your device software updated to address security vulnerabilities.",
                   5 : "Monitor your network for unknown devices. Use strong passwords and encryption to prevent unauthorized access. Stay vigilant with your mobile devices by reviewing installed apps and permissions regularly, and keep your software updated to fix any security flaws.",
                   6 : "Periodically inspect your living or working area thoroughly. Look behind furniture, in bookshelves, and in rarely-used spaces for possible hidden surveillance devices.",
                   7 : "Stay informed about cybersecurity risks. Be cautious with suspicious links and avoid sharing sensitive information online. Practice strong password management and enable two-factor authentication whenever possible.",
                   8 : "Regularly check and adjust privacy settings on your devices and social media accounts. Restrict public sharing of information and manage access to your personal details carefully.",
    ]
    
    var cTitle = [ 1 : "Desk or Standing Lamp",
                   2 : "Doorbell",
                   3 : "Phone",
                   4 : "Power Outlet",
                   5 : "Ceiling-Mounted Smoke Detector",
                   6 : "Alarm Sensor",
                   7 : "Clock",
                   8 : "AC Power Adapter",
                   9 : "Roofs",
                   10 : "Mirror",
                   11 : "Pen",
                   12 : "DVD Player or Set-Top Box",
                   13 : "Soap Dish",
                   14 : "Alarm Clock",
                   15 : "Holes in Doors",
                   16 : "Cloth Hooks",
                   17 : "Tissue Boxes"
    ]
    
    var cText = [ 1: "Inspect the base and shade of desk or standing lamps for any unusual openings. Hidden cameras could be discreetly placed within these fixtures, so be thorough in your inspection.",
                  2: "Carefully examine doorbells, particularly modern, high-tech ones, for hidden cameras. Make sure there are no extra lenses or attached devices to ensure your security.",
                  3: "Thoroughly inspect telephones, paying close attention to the keypad and receiver, for hidden cameras. Ensure the device hasn't been tampered with to prevent privacy breaches.",
                  4: "Examine power outlets and their surroundings for any suspicious devices or modifications. A thorough inspection helps maintain your privacy and security.",
                  5: "Carefully inspect ceiling-mounted smoke detectors for any unusual objects that could conceal cameras. Surveillance devices might be embedded within these detectors, so observe them closely.",
                  6: "When checking alarm sensors, especially those subtly positioned, look for any abnormal wires or lenses. Hidden cameras might be placed in these areas, requiring a thorough inspection.",
                  7: "Examine wall clocks closely for hidden cameras, especially around the clock face and hands. Make sure there are no hidden lenses that could infringe on your privacy.",
                  8: "Check the AC power adapter and its surroundings for small camera lenses. Ensure there are no unexpected additions or changes to the adapter, which might indicate a hidden camera.",
                  9: "Though less common, stay alert for possible hidden cameras on ceilings or roofs. Look for any unusual objects or devices that might be disguised as surveillance equipment.",
                  10: "Inspect mirror frames for tiny camera lenses. Watch for any irregularities in the reflective surface or around the edges to protect against potential surveillance.",
                  11: "Be careful with pens, as they could contain hidden cameras. Examine pens closely for unusual features and confirm they function as expected to protect your privacy.",
                  12: "Check DVD players and set-top boxes for any unusual modifications or additional devices. Keeping them in their original condition helps prevent hidden surveillance tools.",
                  13: "Inspect bathroom soap dishes for hidden cameras. A careful inspection ensures these seemingly harmless items do not compromise your privacy.",
                  14: "Check alarm clocks, focusing on the display and buttons, for hidden cameras. Regular inspections help you maintain your privacy.",
                  15: "Carefully inspect holes or crevices on doors for potential hidden cameras. These inconspicuous spots might be used for discreet surveillance.",
                  16: "Inspect cloth hooks in bathrooms or closets for hidden cameras. Ensure they are securely attached and have no unusual features to preserve your privacy.",
                  17: "Check tissue boxes for concealed cameras within or around them. Regular inspections ensure the integrity of these everyday items."
    ]
}

#Preview {
    GuidesView()
}

struct GuidesOption: View {
    var title = ""
    var text = ""
    var image = ""
    @State var height: CGFloat = 20
    @State var tapped = false

    var body: some View {
        Button {
            withAnimation {
                if tapped {
                    height = 20
                    tapped.toggle()
                } else {
                    height = .infinity
                    tapped.toggle()
                }
            }
        } label: {
        HStack(spacing: 4) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundStyle(.blue)
                    .font(Font.system(size: 17, weight: .medium))
                
                Text(text)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                    .font(Font.system(size: 15))
                
            }.frame(width: 270)
                .frame(maxHeight: height)
            
            Image(image)
            Image("guides.arrow")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32)
                .rotationEffect(Angle(degrees: tapped ? 180: 0))
                .animation(.easeInOut(duration: 0.7), value: tapped)
            
        }
        }.frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: tapped ? .infinity : 50)
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).foregroundStyle(.tabbarBlack))
    }
}
