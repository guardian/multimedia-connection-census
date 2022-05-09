//
//  WifiClient.swift
//  swifttest
//
//  Created by Andy Gallagher on 29/04/2022.
//

import Foundation
import CoreWLAN

struct CurrentWifi {
    var ssid:String?
    var channelBand:String?
    var noiseMeasurement:Int?
    var signalMeasurement:Int?
    var SNR:Float?
    var channelNumber:Int?
    var networksCount:Int
}

private func channelBandName(maybeCh:CWChannel?) -> String {
    if let ch = maybeCh {
        switch(ch.channelBand) {
        case CWChannelBand.band2GHz:
            return "2Ghz";
        case CWChannelBand.band5GHz:
            return "5GHz";
        default:
            return "unknown";
        }
    } else {
        return "unknown";
    }
}

enum InterrograteWifiErrors: Error {
    case NoWifiInterfaces
    case CouldNotScan
}
func InterrogateWifi() throws -> CurrentWifi  {
    let client = CWWiFiClient.shared()
    var networkCount = 0
    
    if let interfaces = client.interfaces() {
        for iface in interfaces {
            do {
                let networks = try iface.scanForNetworks(withName: nil)
                for n in networks {
                    let bandName = channelBandName(maybeCh: client.interface()?.wlanChannel());
                    NSLog("Found network: %@", n.ssid ?? "<no ssid>")
                    NSLog("Noise measurement is %d", n.noiseMeasurement)    //typical values -80 -> -100
                    NSLog("Signal strength is %d", n.rssiValue)             //typical values -10 -> -70
                    NSLog("Network's channel is %d on %@", n.wlanChannel?.channelNumber ?? 0, bandName)
                }
                networkCount = networks.count
            } catch let err {
                let msg = String(format: "Could not scan for available networks: %@", err.localizedDescription)
                NSLog(msg)
                throw InterrograteWifiErrors.CouldNotScan
            }
        }
            
        if let connectedIface = client.interface() {
            let bandName = channelBandName(maybeCh: connectedIface.wlanChannel());

//            let msg = String(format: "Connected to: %@, noise measurement is %d, signal measurement is %d, network channel is %d on band %@. %d networks available",
//                  connectedIface.ssid() ?? "<no ssid>",
//                  connectedIface.noiseMeasurement(),
//                  connectedIface.rssiValue(),
//                  connectedIface.wlanChannel()?.channelNumber ?? -1,
//                  bandName,
//                  networkCount
//                  );
            let signalToNoise = Float(connectedIface.rssiValue()) / Float(connectedIface.noiseMeasurement())
            
            return CurrentWifi(
                ssid: connectedIface.ssid(),
                channelBand: bandName,
                noiseMeasurement: connectedIface.noiseMeasurement(),
                signalMeasurement: connectedIface.rssiValue(),
                SNR: signalToNoise,
                channelNumber: connectedIface.wlanChannel()?.channelNumber,
                networksCount: networkCount
            )
        } else {
            NSLog("No WiFi interface is connected");
            return CurrentWifi(networksCount: networkCount)
        }
    } else {
        throw InterrograteWifiErrors.NoWifiInterfaces
    }
}
