import UIKit

extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        }
        
        return prefix + self
    }
    
    var isNumeric: Bool {
        if Int(self) != nil {
            return true
        }
        
        if Double(self) != nil{
            return true
        }
        
        return false
    }
    
    var lines: [String] {
        var array = [String]()
        let array2 = self.split(separator: "\n")
        
        for i in 0..<array2.count {
            array.append(String(array2[i]))
        }
        
        return array
    }
}

