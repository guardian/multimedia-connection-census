//
//  WifiStatusView.swift
//  swifttest
//
//  Created by Andy Gallagher on 06/05/2022.
//

import SwiftUI

struct WifiStatusView :View {
    @Binding var currentWifiStatus:CurrentWifi?
    
    var body: some View {
        VStack(content: {
            if let wifiStatus=currentWifiStatus {
                VStack(content: {
                    Text(String(format:"Available networks: %d", wifiStatus.networksCount))
                    Text(String(format:"Connected to: %@", wifiStatus.ssid ?? "<not connected>"))
                    Text(String(format:"Channel band: %@", wifiStatus.channelBand ?? "<none>"))
                    Text(String(format:"Channel number: %d", wifiStatus.channelNumber ?? -1))
                    Text(String(format:"Signal-noise ratio: %02.0f%%", (wifiStatus.SNR ?? 0.0)*100))
                }).alignmentGuide(HorizontalAlignment.leading, computeValue: { dimension in
                    dimension.width
                })
            } else {
                Text("No Wifi")
            }
        })
    }
}

struct WifiStatusView_Previews: PreviewProvider {
    @State static var wifiStatus:CurrentWifi? = CurrentWifi(ssid: "My Network", channelBand: "5Ghz", noiseMeasurement: -91, signalMeasurement: -47, SNR: 0.512, channelNumber: 32, networksCount: 7)
    static var previews: some View {
        WifiStatusView(currentWifiStatus: $wifiStatus)
    }
}
