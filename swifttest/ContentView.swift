//
//  ContentView.swift
//  swifttest
//
//  Created by Andy Gallagher on 29/04/2022.
//

import SwiftUI


struct ContentView: View {
    @State var iconColour:Color = .yellow
    @State var wifiStatus:CurrentWifi?
    @State var testWasRun = false
    
    func onClick() {
        do {
            wifiStatus = try InterrogateWifi()
            iconColour = .green
            testWasRun = true
        } catch let err {
            let panel = NSAlert(error: err)
            panel.runModal()
        }
    }
    
    var body: some View {
        VStack(content: {
            List(content: {
                TestResultsView(iconColour: $iconColour,
                                testWasRun: $testWasRun,
                                label: "WiFi",
                                content: WifiStatusView(currentWifiStatus: $wifiStatus)
                )
                TestResultsView(iconColour: $iconColour,
                                testWasRun: $testWasRun,
                                label: "EU Cloud",
                                content: Text("Not implemented")
                )
//                HStack(alignment: .center, spacing: 10, content: {
//                    Circle().size(
//                        CGSize(width: 18, height: 18))
//                        .foregroundColor(iconColour)
//                        .frame(width:20, height:20)
//                    Text("EU Cloud")
//                        .multilineTextAlignment(.leading).frame(width:labelColumnWidth, height:20)
//                }).padding(.all, 20)
                HStack(alignment: .bottom, spacing: 10, content: {
                    Text("Placeholder")
                }).padding(.all, 20)
            }).lineSpacing(5.0)
            Button(action: onClick) {
                Text("Run test")
            }
        })
        .padding(.all, 10.0)
        .frame(maxWidth: 800, maxHeight: 600)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
