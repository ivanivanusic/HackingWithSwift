//
//  Picture.swift
//  Challenge(10-12)
//
//  Created by Ivan Ivanušić on 07/09/2020.
//  Copyright © 2020 Ivan Ivanušić. All rights reserved.
//

import UIKit

class Picture: NSObject, Codable {
    var picture: String
    var title: String
 
    init(title: String, picture: String) {
        self.title = title
        self.picture = picture
    }
}
