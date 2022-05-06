//
//  ContentView.swift
//  swifttest
//
//  Created by Andy Gallagher on 29/04/2022.
//

import SwiftUI

struct WifiStatusView :View {
    var wifiStatus:CurrentWifi
    
    var body: some View {
        List(content: {
            Text(String(format:"Available networks: %d", wifiStatus.networksCount))
            Text(String(format:"Connected to: %@", wifiStatus.ssid ?? "<not connected>"))
            Text(String(format:"Channel band: %@", wifiStatus.channelBand ?? "<none>"))
            Text(String(format:"Channel number: %d", wifiStatus.channelNumber ?? -1))
            Text(String(format:"Signal-noise ratio: %02.0f%%", (wifiStatus.SNR ?? 0.0)*100))
        })
    }
}

struct ContentView: View {
    @State var iconColour:Color = .yellow
    @State var wifiStatus:CurrentWifi?
    
    func onClick() {
        do {
            wifiStatus = try InterrogateWifi()
            iconColour = .green
        } catch let err {
            let panel = NSAlert(error: err)
            panel.runModal()
        }
    }
    
    var body: some View {
        VStack(content: {
            List(content: {
                HStack(alignment: .top, spacing: 10, content: {
                    Text("WiFi")
                    Circle().size(
                        CGSize(width: 18, height: 18)).foregroundColor(iconColour)
                    if let activeWifi=wifiStatus {
                        WifiStatusView(wifiStatus: activeWifi).frame(width:200, height: 200)
                    } else {
                        Text("No wifi")
                    }
                }).padding(.all, 20)
                HStack(alignment: .center, spacing: 10, content: {
                    Text("Placeholder")
                }).padding(.all, 20)
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
