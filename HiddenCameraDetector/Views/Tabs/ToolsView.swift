//
//  ToolsView.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 21.05.2024.
//

import SwiftUI
import LanScanner



import Network

struct ToolsView: View {

    @ObservedObject var viewModel = CountViewModel()
    @State var showAlert: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    Text(viewModel.title)
                        .font(.title)
                    Spacer()
                    Button {
                        viewModel.reload()
                    } label: {
                        Image(systemName: "repeat")
                            .foregroundColor(.black)
                    }
                }
                ProgressView(value: viewModel.progress)
            }.padding()

            List {
                ForEach(viewModel.connectedDevices) { device in
                    VStack(alignment: .leading) {
                        Text(device.ipAddress)
                            .font(.body)
                        Text(device.mac)
                            .font(.caption)
                        Text(device.brand)
                            .font(.footnote)
                    }
                    .onTapGesture {
                        #if os(iOS)
                            UIPasteboard.general.string = device.name
                        #endif
                    }
                    .padding()

                }
            }.alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Scan Finished"),
                    message: Text("Number of devices connected to your Local Area Network: \(viewModel.connectedDevices.count)")
                )
            }
        }
    }
}
#Preview {
    ToolsView()
}
