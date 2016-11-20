//
//  TreasureBox.swift
//  stevens
//
//  Created by Xin Zou on 11/6/16.
//  Copyright © 2016 Stevens. All rights reserved.
//

import Foundation
import SpriteKit

class TreasureBox {
    var node : SKSpriteNode!
    var isShowing: Bool = false {
        didSet {
            if isShowing {
                self.node.zPosition = 3
            }else{
                self.node.zPosition = -1
            }
        }
    }
    
    init(img: String, initPosition: CGPoint){
        
        self.node = SKSpriteNode(imageNamed: img)
        self.node.size = CGSize(width: 80, height: 80)
        self.node.position = initPosition
        self.node.zPosition = 3
        
        self.isShowing = true
        
        // Determine speed of the treasure
        // let actualDuration = random(min: CGFloat(100.0), max: CGFloat(200.0))
        
        // Create the actions x: -treasureBox.size.width/2, y: actualY,
        // let actionMove = SKAction.move(to: CGPoint(x: self.frame.midX - 330, y: self.frame.midY - 40), duration: TimeInterval(actualDuration))
//        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: actualY), duration: TimeInterval(6))
//        let actionMoveDone = SKAction.removeFromParent()
//        treasureBox.run(SKAction.sequence([actionMove, actionMoveDone]))//, actionMoveDone

        // argument of #selector does not refer to an objc method, property, or initializer.
    }
    
    func showUpTreasureBox(){
        self.isShowing = true
    }
    
    
}
