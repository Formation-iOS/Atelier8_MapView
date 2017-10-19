//
//  FunMapPoint.swift
//  Atelier8_MapView
//
//  Created by CedricSoubrie on 18/10/2017.
//  Copyright © 2017 CedricSoubrie. All rights reserved.
//

import UIKit
import CoreLocation

struct FunMapPoint : Codable {
    var title : String
    var latitude : CLLocationDegrees
    var longitude : CLLocationDegrees
    var zoom : CLLocationDegrees
    var coordinate : CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case longitude = "Longitude"
        case latitude = "Latitude"
        case zoom = "Zoom"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        zoom = try values.decode(CLLocationDegrees.self, forKey: .zoom)
        let latString = try values.decode(String.self, forKey: .latitude)
        let lngString = try values.decode(String.self, forKey: .longitude)
        latitude = CLLocationDegrees(latString) ?? 0
        longitude = CLLocationDegrees(lngString) ?? 0
    }
    
    static var allMapPoints : [FunMapPoint] = {
        if let path = Bundle.main.path(forResource: "AmazingPlaces", ofType: "plist")
            {
            let url = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: url) {
                let decoder = PropertyListDecoder()
                do {
                    return try decoder.decode([FunMapPoint].self, from: data)
                }
                catch {
                    print (error)
                    print ("Le fichier AmazingPlaces n'a pas le bon format de données")
                }
            }
            else {
                print ("Le fichier AmazingPlaces n'est pas un plist valide")
            }
        }
        else {
            print ("Pas de fichier AmazingPlaces")
        }
        return [FunMapPoint]()
    } ()
}
