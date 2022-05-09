//
//  IpInfoView.swift
//  connection-census
//
//  Created by Andy Gallagher on 09/05/2022.
//

import SwiftUI

/*
 let ip: String
 let city: String?
 let region: String?
 let country: String?
 let loc: String?
 let org: String
 let postal: String?
 let timezone: String
 */
struct IpInfoView: View {
    @Binding var content:IPInfo?
    
    var body: some View {
        VStack(content: {
            if let currentStatus = content {
                VStack(content: {
                    Text(String(format: "Your IP address is %@", currentStatus.ip))
                    Text(String(format: "Your ISP is probably: %@", currentStatus.org))
                    Text(String(format: "Likely timezone: %@", currentStatus.timezone))
                    Text(String(format: "Likely location: %@, %@", currentStatus.city ?? "<no city>", currentStatus.region ?? "<no region>"))
                    Text(String(format: "Likely country: %@", currentStatus.country ?? "<unknown>"))
                })
            } else {
                Text("Could not determine IP information")
            }
        })
    }
}

struct IpInfoView_Previews: PreviewProvider {
    @State static var ipInfo:IPInfo? = IPInfo(ip: "192.168.10.0",
                                              city: "Nowheresville",
                                              region: "Somewhere",
                                              country: "Any old country",
                                              loc: nil,
                                              org: "Some ISP",
                                              postal: nil,
                                              timezone: "Etc/UTC")
    static var previews: some View {
        IpInfoView(content: $ipInfo)
    }
}
