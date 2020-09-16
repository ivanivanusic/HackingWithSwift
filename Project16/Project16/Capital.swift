//
//  Capital.swift
//  Project16
//
//  Created by Ivan Ivanušić on 16/09/2020.
//  Copyright © 2020 Ivan Ivanušić. All rights reserved.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
