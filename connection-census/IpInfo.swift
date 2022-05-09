//
//  IpInfo.swift
//  connection-census
//
//  Created by Andy Gallagher on 09/05/2022.
//

import Foundation

struct IPInfo:Decodable {
    let ip: String
    let city: String?
    let region: String?
    let country: String?
    let loc: String?
    let org: String
    let postal: String?
    let timezone: String
}

enum RetrieveIPInfoErrors: Error {
    case InternalCodeError
}

func parseAndMarshal(content: Data) -> IPInfo? {
    do {
        return try JSONDecoder().decode(IPInfo.self, from: content)
    } catch let err {
        NSLog("Could not parse content from IPInfo service: %@", err.localizedDescription)
        return nil
    }
}

func RetrieveIPInfo(completion: @escaping ((IPInfo?) -> Void)) throws {
    if let url = URL(string: "https://ipinfo.io/json") {
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let response = response as? HTTPURLResponse {
                switch(response.statusCode) {
                case 200:
                    if let data = data {
                        completion(parseAndMarshal(content: data))
                    } else {
                        NSLog("ERROR No data was returned from IPINFO service")
                        completion(nil)
                    }
                default:
                    NSLog("ERROR Could not access https://ipinfo.io/json: Server returned %d", response.statusCode)
                    completion(nil)
                }
            }
        }
        task.resume()
    } else {
        throw RetrieveIPInfoErrors.InternalCodeError
    }
}
