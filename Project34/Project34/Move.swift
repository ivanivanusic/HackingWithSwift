//
//  Move.swift
//  Project34
//
//  Created by Ivan Ivanušić on 20.02.2021..
//

import GameplayKit
import UIKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0
    var column: Int

    init(column: Int) {
        self.column = column
    }
}
