//
//  ToolsView.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 21.05.2024.
//

import SwiftUI

struct ToolsView: View {
    @EnvironmentObject var vm: ToolsViewModel
    var body: some View {
        VStack {
            Button {
                vm.checkSpeed()
            } label: {
                Text("Check")
            }
        }
    }
}
#Preview {
    ToolsView()
}
