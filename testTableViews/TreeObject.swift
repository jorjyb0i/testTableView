//
//  StrangeEntity.swift
//  testTableViews
//
//  Created by jorjyb0i on 26.03.2021.
//

import Foundation
import UIKit

class TreeObject {
    
    lazy var children: [TreeObject] = createChildren()
    
    var pNum: Int
    var title: String
    var isHidden: Bool = true
    var isActive: Bool = false
    
    init(num: Int) {
        pNum = num
        title = "\(pNum): " + UUID().uuidString
    }
    
    private func createChildren() -> [TreeObject] {
        var newArray: [TreeObject] = []
        let numberOfElements = Int.random(in: 0...4)
        
        if numberOfElements != 0 {
            for _ in 0..<numberOfElements {
                newArray.append(TreeObject(num: self.pNum + 1))
            }
        }
        return newArray
    }
    
    func setHidden() {
        isHidden = !isHidden
    }
    
    func setActive() {
        isActive = !isActive
    }
    
    func numberOfObjectsBelowLine() -> Int {
        var count: Int = 0
        
        for child in children {
            if !child.isHidden && child.isActive {
                count += 1 + child.numberOfObjectsBelowLine()
            } else if !child.isHidden {
                count += 1
            } else {
                return 0
            }
        }
        return count
    }
    
    func findElement(withIndex index: Int) -> TreeObject? {
        let numberOfChilndren = children.count
        var objectsToIgnore = 0
        
        for currentIndex in 0..<numberOfChilndren {
            
            if currentIndex == index - objectsToIgnore {
                return children[currentIndex]
            }
            
            let numberOfObjectsBelowLine = children[currentIndex].numberOfObjectsBelowLine()
            
            if numberOfObjectsBelowLine + currentIndex < index  {
                objectsToIgnore += numberOfObjectsBelowLine
            } else {
                return children[currentIndex].findElement(withIndex: index - currentIndex - objectsToIgnore - 1)
            }
        }
        return nil
    }
}
