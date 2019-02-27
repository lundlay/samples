//
//  OpenWeatherMap.swift
//
//  Created by Oleg Lavronov on 2/18/19.
//  Copyright © 2019 Lundlay. All rights reserved.
//

// To read values from URLs:
//
//   let task = URLSession.shared.openWeatherMapTask(with: url) { openWeatherMap, response, error in
//     if let openWeatherMap = openWeatherMap {
//       ...
//     }
//   }
//   task.resume()

import Foundation

struct OpenWeatherMap: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let id: Int?
    let name: String?
    let cod: Int?
    
    
    struct Clouds: Codable {
        let all: Int?
    }
    
    struct Coord: Codable {
        let lon, lat: Double?
    }
    
    struct Main: Codable {
        let temp: Double?
        let pressure, humidity: Int?
        let tempMin, tempMax: Double?
        
        enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }
    
    struct Sys: Codable {
        let type, id: Int?
        let message: Double?
        let country: String?
        let sunrise, sunset: Int?
    }
    
    struct Weather: Codable {
        let id: Int?
        let main, description, icon: String?
    }
    
    struct Wind: Codable {
        let speed: Double?
        let deg: Int?
    }
    
}
fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func openWeatherMapTask(with url: URL, completionHandler: @escaping (OpenWeatherMap?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
