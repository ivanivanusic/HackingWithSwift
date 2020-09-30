import UIKit

// extension 1: animate out a UIView
extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [unowned self] in
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

// extension 2: create a times() method for integers
extension Int {
    func times(_ closure: () -> Void) {
        for _ in 0..<self {
            closure()
        }
    }
}

// extension 3: remove an item from an array
extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        let array = self
        for i in 0..<self.count {
            if array[i] == item {
                self.remove(at: i)
                return
            }
        }
    }
}


// some test code to make sure everything works
let view = UIView()
view.bounceOut(duration: 3)

5.times { print("Hello") }

var numbers = [1, 2, 3, 4, 5]
numbers.remove(item: 3)

