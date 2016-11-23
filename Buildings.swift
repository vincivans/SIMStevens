//
//  Buildings.swift
//  stevens
//
//  Created by Xin Zou on 10/28/16.
//  Copyright © 2016 Stevens. All rights reserved.
//

import Foundation
import SpriteKit

let textFontName:     String = "AmericanTypewriter"
let textFontNameBold: String = "AmericanTypewriter-Bold"

// info box story: 
let descriptionOf : [String:String] = [
    
    "The Gate House":       "It was the grand entrance through which all guests approached the Castle, a haunting structure built for the Steven's in 1854. The Gate House remains; the Castle was demolished in 1959.",
    
    "Edwin A. Stevens Building":    "Constructed in 1870 as the main building for the campus, this federally registered landmark was designed by Richard Upjohn, whose work includes the Trinity Church in Manhattan.",

    "Carnegie Laboratory":  "As a trustee of Stevens Institute, Andrew Carnegie donated the funds for the Carnegie Laboratory,seen here after being built in 1902.",
    
    "Walker Gymnasium":     "The William Hall Walker Gymnasium, built in 1916, is named for its donor and serves as an adjunct athletic and recreational facility.",
    
    "Burchard Building":    "The Burchard Building, completed in 1958, houses the offices and facilities of electrical and computer engineering, materials engineering, physics and engineering physics.",
    
    "W.Howe Center":        "The family built the Stevens Castle in the 1850s. The new family residence was designed by Alexander Jackson Davis, a prominent architect of the time. It stood on the highest point in Hoboken, on a bluff overlooking the Hudson River.",
    
    "Samuel C. Williams Library": "The Library is the center for information discovery and preservation at Stevens Institute of Technology. The Library is dedicated to fostering an innovative environment with technology, education and culture.",
    
    "Babbio Center":        "The Howe School of Technology Management is one of the world’s preeminent institutions in the education of professionals who lead and manage technological innovation in businesses in America and around the world.",
    
    "Ship":     "我们的目标是星辰大海! Let's go outer ocean for aventure!!!   d(^o^)b "
]

/// building mode showing on map(after upgrade):
let buildingImageOf : [String:String] = [
    
    "The Gate House":           "build-gatehouse",
    "Edwin A. Stevens Building": "build-eas",
    "Carnegie Laboratory":      "build-carnegie",
    "Walker Gymnasium":         "build-gym",
    "Burchard Building":        "build-burchard",
    "W.Howe Center":            "build-howe",
    "Samuel C. Williams Library": "build-library",
    "Babbio Center":            "build-babbio",
    "Ship":                     "ship01"
    
]
let buildingImageSize : [String:CGSize] = [
    
    "The Gate House":           CGSize(width: 200, height: 200),
    "Edwin A. Stevens Building": CGSize(width: 300, height: 300),
    "Carnegie Laboratory":      CGSize(width: 330, height: 350),
    "Walker Gymnasium":         CGSize(width: 180, height: 180),
    "Burchard Building":        CGSize(width: 270, height: 230),
    "W.Howe Center":            CGSize(width: 140, height: 255),
    "Samuel C. Williams Library": CGSize(width: 300, height: 300),
    "Babbio Center":            CGSize(width: 230, height: 230),
    "Ship":                     CGSize(width: 330, height: 330)
    
]

// building image in info box:
let buildingInfoImgOf : [String:String] = [
    
    "The Gate House":           "info-gatehouse",
    "Edwin A. Stevens Building": "info-eas",
    "Carnegie Laboratory":      "info-carnegie",
    "Walker Gymnasium":         "info-gym",
    "Burchard Building":        "info-burchard",
    "W.Howe Center":            "info-howe",
    "Samuel C. Williams Library": "info-library",
    "Babbio Center":            "info-babbio",
    "Ship":                     "ship01"
    
]

/// showing in researchingBox, and researching setup for each:
let researchingImageOf : [String:String] = [
    
    "The Gate House":           "research-gatehouse",
    "Edwin A. Stevens Building": "research-eas",
    "Carnegie Laboratory":      "research-carnegie",
    "Walker Gymnasium":         "research-gym",
    "Burchard Building":        "research-burchard",
    "W.Howe Center":            "research-howe",
    "Samuel C. Williams Library": "research-library",
    "Babbio Center":            "research-babbio",
    "Ship":                     "ship01"
    
]
let researchDescriptionOf : [String:String] = [
    
    "The Gate House":           "duck researchDescription",
    "Edwin A. Stevens Building": "Spaceship researchDescription",
    "Carnegie Laboratory":      "Spaceship researchDescription",
    "Walker Gymnasium":         "duck researchDescription",
    "Burchard Building":        "Spaceship researchDescription",
    "W.Howe Center":            "duck researchDescription",
    "Samuel C. Williams Library": "duck researchDescription",
    "Babbio Center":            "SpaceshipresearchDescription",
    "Ship":                     "Ocean science "
    
]
let buildingResearchOf : [String:String] = [
    
    "The Gate House":           "Campus Security",
    "Edwin A. Stevens Building": "Mechanical Engineering",
    "Carnegie Laboratory":      "3D printing development",
    "Walker Gymnasium":         "team up! Football ducks",
    "Burchard Building":        "Swift3 iOS Engineering",
    "W.Howe Center":            "New headquarter of SIT",
    "Samuel C. Williams Library": "Acamedy and Fun",
    "Babbio Center":            "Finance + Business",
    "Ship":                     "我们的目标是星辰大海"
    
]
let buildingResearchTiming : [String:TimeInterval] = [
    
    "The Gate House":          6, // 120,   // 2 min
    "Edwin A. Stevens Building":32, //1200,   // 20 min
    "Carnegie Laboratory":     52, //3600,   // 1 h
    "Walker Gymnasium":        72, //10800,   // 3 h
    "Burchard Building":       82, //36000,   // 10 h
    "W.Howe Center":           92, //86400,   // 24 h
    "Samuel C. Williams Library": 102, //97200, // 27 h
    "Babbio Center":           162,    // 5 min
    "Ship":                    72      // 0.5 min
    
]

// in seconds: Upgrade time
let buildingUpgradeTimeOf : [String:TimeInterval] = [
    
    "The Gate House":           1,
    "Edwin A. Stevens Building": 123,
    "Carnegie Laboratory":      1500,
    "Walker Gymnasium":         200,
    "Burchard Building":        2703,
    "W.Howe Center":            3603,
    "Samuel C. Williams Library": 7203,
    "Babbio Center":            14403,
    "Ship":                     5
    
]

// the order to build them based on thier year:
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


class Building {
    var node : SKSpriteNode!
    let name : String
    let year : Int
    var level: Int
    let order: Int
    let containStudents: Int
    let upGradeCost: Float
    let researchCost: Float
    var timmingLabel: SKLabelNode!
    var timeToFinish: TimeInterval
    var secTimer: Timer
    var reword: Int
    
    init(image:String, name:String, year:Int, order:Int, numOfStudents:Int, upGradeCost: Float, x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat){
        
        self.name = name
        self.year = year
        self.level = 0
        self.order = order
        self.containStudents = numOfStudents
        self.upGradeCost = upGradeCost
        self.researchCost = upGradeCost * 0.2
        
        self.node = SKSpriteNode(imageNamed: image)
        self.node.name = name
        self.node.size = CGSize(width: width, height: height)
        self.node.position = CGPoint(x: x, y: y)
        self.node.zPosition = 2 // layer.building.rawvalue

        self.timmingLabel = SKLabelNode()
        self.timeToFinish = 0
        self.secTimer = Timer()
        
        self.reword = -1 // -1: no research, 0: doing research, >1: getting reword
    }
    
    
    func upgradeIn(parentNode: SKSpriteNode) {
        let oldPosition = node.position
        let oldzPosition = node.zPosition
        
        node.removeFromParent()
        
        let img = buildingImageOf[name]!
        node = SKSpriteNode(imageNamed: img)
        node.position = oldPosition
        node.zPosition = oldzPosition
        node.size = buildingImageSize[name]!
        parentNode.addChild(node)
        
        self.timmingLabel = SKLabelNode(text: "00:00:00")
        self.timmingLabel.fontName = textFontName
        self.timmingLabel.fontSize = 23
        self.timmingLabel.fontColor = UIColor.white
        self.timmingLabel.position = CGPoint(x: 0, y: 40)
        self.timmingLabel.zPosition = -5  // do not show timming label at begining.
        self.node.addChild(timmingLabel)
        
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
    
    // @objc: Err: Argument of #selector refers to instance method '..' that is not exposed to Ojbective-c
    fileprivate func researchFinish() {
        self.secTimer.invalidate()
        self.timeToFinish = 0
        self.timmingLabel.text = "✅" // to show user that research has finished!
        self.reword = Int(researchCost * 2)
    }
    @objc fileprivate func researchTimeCounting() {
        self.timeToFinish -= 1
        let ti = Int(timeToFinish)
        let hh = ti / 3600
        let mm = (ti / 60) % 60
        let ss = ti % 60
        let timeStr = String(format: "%02d:%02d:%02d", hh, mm, ss)
        self.timmingLabel.text = timeStr
        
        if self.timeToFinish <= 0 {
            researchFinish()
        }
    }
    func setupResearch() {
        self.secTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Building.researchTimeCounting), userInfo: nil, repeats: true)
        
        self.timeToFinish = buildingResearchTiming[name]!
        
        self.timmingLabel.position = CGPoint(x: 0, y: 40)
        self.timmingLabel.zPosition = node.zPosition + 1
        self.timmingLabel.text = "🔬"
        self.reword = 0 // -1: no research, 0: doing research, >1: getting reword
        
    }
}






