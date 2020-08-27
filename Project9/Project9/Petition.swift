//
//  Petition.swift
//  Project7
//
//  Created by Ivan Ivanušić on 24/08/2020.
//  Copyright © 2020 Ivan Ivanušić. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
