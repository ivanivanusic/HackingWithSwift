//
//  Person.swift
//  Project10
//
//  Created by Ivan Ivanušić on 31/08/2020.
//  Copyright © 2020 Ivan Ivanušić. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
}
