//
//  WidgetProperties.swift
//
//  Created by Oleg Lavronov on 2/23/19.
//  Copyright © 2019 Lundlay. All rights reserved.
//

import UIKit


/**
 Transformable class to save properties of widgets in CoreData with support Coding protocol for swift structures.
 
 */
@objcMembers
open class WidgetProperties: NSObject, NSCoding, NSCopying {
    
    public struct Location: Equatable, Codable {
        let lat: Double?
        let lon: Double?
        let address: String?
    }
    
    /// Foreground color. Text, tint and etc.
    public var foreground: UIColor?
    /// Background color.
    public var background: UIColor?
    /// Map coordinates and address string.
    public var location: Location?
    /// Time zone. 
    public var timeZone: String?

    enum CodingKeys: String, CodingKey, CaseIterable {
        case foreground
        case background
        case location
        case timeZone
    }
    
    // Memberwise initializer
    init(foreground: UIColor? = nil,
         background: UIColor? = nil,
         location: Location? = nil,
         timeZone: String? = nil) {
        self.foreground = foreground
        self.background = background
        self.location = location
        self.timeZone = timeZone
    }
    
    // MARK: NSCoding
    public required convenience init?(coder decoder: NSCoder) {
        guard let data = decoder.decodeData() else { return nil }
        let archiver = try? NSKeyedUnarchiver(forReadingFrom: data)
        archiver?.requiresSecureCoding = false
        let foreground = archiver?.decodeObject(forKey: .foreground) as? UIColor
        let background = archiver?.decodeObject(forKey: .background) as? UIColor
        let timeZone = archiver?.decodeObject(forKey: .timeZone) as? String
        let location = archiver?.decodeDecodable(Location.self, forKey: .location)
        
        self.init(foreground: foreground,
                  background: background,
                  location: location,
                  timeZone: timeZone)
    }
    
    public func encode(with coder: NSCoder) {
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        
        archiver.encode(self.foreground, forKey: .foreground)
        archiver.encode(self.background, forKey: .background)
        archiver.encode(self.timeZone, forKey: .timeZone)
        try? archiver.encodeEncodable(self.location, forKey: .location)
        
        defer {
            archiver.finishEncoding()
            coder.encode(archiver.encodedData)
        }
    }
    
    // MARK: NSCopying
    required public init(_ model: WidgetProperties) {
        foreground = model.foreground
        background = model.background
        location = model.location
        timeZone = model.timeZone
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return type(of:self).init(self)
    }
    
    subscript(_ property: String) -> Any? {
        get {
            guard let key = CodingKeys(rawValue: property) else { return nil }
            switch key {
            case .foreground: return foreground
            case .background: return background
            case .location: return location
            case .timeZone: return timeZone
            }
        }
        
        set (newValue) {
            guard let key = CodingKeys(rawValue: property) else { return }
            switch key {
            case .foreground: foreground = newValue as? UIColor
            case .background: background = newValue  as? UIColor
            case .location: location = newValue  as? Location
            case .timeZone: timeZone = newValue as? String
            }
        }
    }
    
    static func == (lhs: WidgetProperties, rhs: WidgetProperties) -> Bool {
        return lhs.foreground == rhs.foreground &&
            lhs.background == rhs.background &&
            lhs.location == rhs.location &&
            lhs.timeZone == rhs.timeZone
    }
    
}

extension NSCoder {
    
    func decodeObject(forKey key: WidgetProperties.CodingKeys) -> Any? {
        return decodeObject(forKey: key.rawValue)
    }
    
    func encode(_ object: Any?, forKey key: WidgetProperties.CodingKeys) {
        encode(object, forKey: key.rawValue)
    }
    
}

extension NSKeyedUnarchiver {

    func decodeDecodable<T>(_ type: T.Type, forKey key: WidgetProperties.CodingKeys) -> T? where T : Decodable {
        return decodeDecodable(type, forKey: key.rawValue)
    }

}

extension NSKeyedArchiver {
    
    func encodeEncodable<T>(_ value: T, forKey key: WidgetProperties.CodingKeys) throws where T : Encodable {
        try encodeEncodable(value, forKey: key.rawValue)
    }
    
}

