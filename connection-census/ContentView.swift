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
    @State var ipInfo:IPInfo?
    @State var testWasRun = false
    
    func onClick() {
        do {
            wifiStatus = try InterrogateWifi()
        } catch let err {
            let panel = NSAlert(error: err)
            panel.runModal()
        }
        
        do {
            try RetrieveIPInfo(completion: {(newInfo) in
                ipInfo = newInfo
            })
        } catch let err {
            let panel = NSAlert(error: err)
            panel.runModal()
        }
        
        iconColour = .green
        testWasRun = true
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
                                label: "IP Info",
                                content: IpInfoView(content: $ipInfo)
                )
                TestResultsView(iconColour: $iconColour,
                                testWasRun: $testWasRun,
                                label: "EU Cloud",
                                content: Text("Not implemented")
                )
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
