//
//  Buildings.swift
//  stevens
//
//  Created by Xin Zou on 10/28/16.
//  Copyright © 2016 Stevens. All rights reserved.
//

import Foundation
import SpriteKit


let descriptionOf : [String:String] = [
    
    "The Gate House": "It was the grand entrance through which all guests approached the Castle, a haunting structure built for the Steven's in 1854. The Gate House remains; the Castle was demolished in 1959.",
    
    "Edwin A. Stevens Building": "Constructed in 1870 as the main building for the campus, this federally registered landmark was designed by Richard Upjohn, whose work includes the Trinity Church in Manhattan.",

    "Carnegie Laboratory": "As a trustee of Stevens Institute, Andrew Carnegie donated the funds for the Carnegie Laboratory,seen here after being built in 1902.",
    
    "Walker Gymnasium": "The William Hall Walker Gymnasium, built in 1916, is named for its donor and serves as an adjunct athletic and recreational facility.",
    
    "Burchard Building": "The Burchard Building, completed in 1958, houses the offices and facilities of electrical and computer engineering, materials engineering, physics and engineering physics.",
    
    "W.Howe Center": "The family built the Stevens Castle in the 1850s. The new family residence was designed by Alexander Jackson Davis, a prominent architect of the time. It stood on the highest point in Hoboken, on a bluff overlooking the Hudson River.",
    
    "Samuel C. Williams Library": "The Library is the center for information discovery and preservation at Stevens Institute of Technology. The Library is dedicated to fostering an innovative environment with technology, education and culture.",
    
    "Babbio Center": "The Howe School of Technology Management is one of the world’s preeminent institutions in the education of professionals who lead and manage technological innovation in businesses in America and around the world.",
    
    "Ship": "let's go to outer ocean for aventure!!!   d(^o^)b "
]

/// for building upgrade: 
let buildingImageOf : [String:String] = [
    
    "The Gate House":           "house15",
    "Edwin A. Stevens Building": "house15",
    "Carnegie Laboratory":      "house15",
    "Walker Gymnasium":         "house15",
    "Burchard Building":        "house15",
    "W.Howe Center":            "house15",
    "Samuel C. Williams Library": "house15",
    "Babbio Center":            "howe01",
    "Ship":                     "ship01"
    
]

/// for doing research in buildings:
let researchingImageOf : [String:String] = [
    
    "The Gate House":           "duck",
    "Edwin A. Stevens Building": "Spaceship",
    "Carnegie Laboratory":      "Spaceship",
    "Walker Gymnasium":         "duck",
    "Burchard Building":        "Spaceship",
    "W.Howe Center":            "duck",
    "Samuel C. Williams Library": "duck",
    "Babbio Center":            "Spaceship",
    "Ship":                     "Spaceship"
    
]
let researchDescriptionOf : [String:String] = [
    
    "The Gate House":           "duck researchDescription",
    "Edwin A. Stevens Building": "Spaceship researchDescription",
    "Carnegie Laboratory":      "Spaceship researchDescription",
    "Walker Gymnasium":         "duck researchDescription",
    "Burchard Building":        "SpaceshipresearchDescription",
    "W.Howe Center":            "duckresearchDescription",
    "Samuel C. Williams Library": "duckresearchDescription",
    "Babbio Center":            "SpaceshipresearchDescription",
    "Ship":                     "SpaceshipresearchDescription"
    
]

let buildingUpgradeTimeOf : [String:TimeInterval] = [
    
    "The Gate House":           5,  // seconds
    "Edwin A. Stevens Building": 123,
    "Carnegie Laboratory":      1500,
    "Walker Gymnasium":         200,
    "Burchard Building":        2703,
    "W.Howe Center":            3603,
    "Samuel C. Williams Library": 7203,
    "Babbio Center":            14403,
    "Ship":                     5
    
]

var buildingOrders : [String:Int] = [
    
    "The Gate House":           1,
    "Edwin A. Stevens Building": 1,
    "Carnegie Laboratory":      2,
    "Walker Gymnasium":         2,
    "Burchard Building":        3,
    "W.Howe Center":            3,
    "Samuel C. Williams Library": 4,
    "Babbio Center":            4,
    "Ship":                     5
    
]

func getIntTimeFrom(getSec:TimeInterval) -> (hor:Int, min:Int, sec:Int) {
    
    if getSec <= 0 {
        return (0,0,0)
    }
    let hor = round(getSec / 3600)
    let min = round((getSec - hor*3600) / 60)
    let sec = getSec - hor*3600 - min*60
    
    return (Int(hor), Int(min), Int(sec))

}

let buildingResearchOf : [String:String] = [
    
    "The Gate House":           "Campus Security",
    "Edwin A. Stevens Building": "Mechanical Engineering",
    "Carnegie Laboratory":      "3D printing",
    "Walker Gymnasium":         "team up! Football ducks",
    "Burchard Building":        "Communication lab",
    "W.Howe Center":            "New headquarters of Stevens",
    "Samuel C. Williams Library": "Acamedy and Fun",
    "Babbio Center":            "Finance + Business",
    "Ship":                     "我们的目标是星辰大海"
    
]

class Building {
    var node : SKSpriteNode!
    var name : String
    var year : Int
    var level: Int
    var order: Int
    var containStudents: Int
    var upGradeCost: Float
    
    init(image:String, name:String, year:Int, level:Int, order:Int, numOfStudents:Int, upGradeCost: Float, x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat){
        self.node = SKSpriteNode(imageNamed: image)
        self.node.name = name
        self.name = name
        self.year = year
        self.level = level
        self.order = order
        self.containStudents = numOfStudents
        self.upGradeCost = upGradeCost
        
        self.node.size = CGSize(width: width, height: height)
        self.node.position = CGPoint(x: x, y: y)
        self.node.zPosition = 2 // layer.building.rawvalue
    }
    
    func upgradeIn(parentNode: SKSpriteNode) {
        let oldPosition = node.position
        let oldzPosition = node.zPosition
        let oldSize = node.size
        
        node.removeFromParent()
        
        let img = buildingImageOf[name]!
        node = SKSpriteNode(imageNamed: img)
        node.position = oldPosition
        node.zPosition = oldzPosition
        node.size = oldSize
        parentNode.addChild(node)
        
        level += 1
        
        // action effect:
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = oldPosition
        explosion.zPosition = 6
        
        parentNode.addChild(explosion)
        
        self.node.run(SKAction.wait(forDuration: 8), completion: {
            explosion.removeFromParent()
        })
    }
}






