//
//  Whistle.swift
//  Project33
//
//  Created by Ivan Ivanušić on 01.02.2021..
//

import CloudKit
import UIKit

class Whistle: NSObject {
    var recordID: CKRecord.ID!
	var genre: String!
	var comments: String!
	var audio: URL!
}
