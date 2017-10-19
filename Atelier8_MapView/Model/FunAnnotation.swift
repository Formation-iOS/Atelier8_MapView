//
//  FunAnnotation.swift
//  Atelier8_MapView
//
//  Created by CedricSoubrie on 19/10/2017.
//  Copyright © 2017 CedricSoubrie. All rights reserved.
//

import UIKit
import MapKit

class FunAnnotation : NSObject, MKAnnotation {
    private var mapPoint : FunMapPoint
    
    required init(mapPoint: FunMapPoint) {
        self.mapPoint = mapPoint
    }
    
    var title: String? {
        return mapPoint.title
    }
    
    var subtitle: String? {
        return nil
    }
    
    var coordinate: CLLocationCoordinate2D {
        return mapPoint.coordinate
    }
    
    var zoom : CLLocationDegrees {
        return mapPoint.zoom
    }
}
