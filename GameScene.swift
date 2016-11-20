//
//  GameScene.swift
//  SpaceGame Demo
//
//  Created by Xin Zou on 10/13/16.
//  Copyright © 2016 Stevens. All rights reserved.
//

import SpriteKit
import GameplayKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.y, y: left.y * right.y)
}
func / (left: CGPoint, right: CGPoint) -> CGPoint {
    if right.x == 0 || right.y == 0 {
        return CGPoint(x: 0, y: 0)
    }
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}



// we need object contact, so add this:
class GameScene: SKScene{
    
    enum LayerAt: CGFloat {
        case Map = 1
        case Buildings = 2
        // case 3 reserve for upgraded buildings.
        case BuildingNameLabel = 5
        case ButtonLabels = 6
        case DialogBox = 7
        case DialogBoxButton = 8
        case DialogBoxImg = 9
        case TalkingBox = 15
        case Arrow = 16
    }
    func random()->CGFloat{//random generator
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max-min)+min
    }
    
    let textFontName:     String = "AmericanTypewriter"
    let textFontNameBold: String = "AmericanTypewriter-Bold"
    
    let moneyLogo :     String = "💰"
    let professorLogo:  String = "🎓"
    let researchLogo:   String = "🚀"
    let hourglassLogo:  String = "⌛️"
    let helpLogo:       String = "📕"
    let showNameLogo:   String = "💡"
    
    var campusMap : SKSpriteNode! // the map here!!!!!!
    var mapWidth : CGFloat!
    var mapHeight: CGFloat!
    var mapCarmmerLocation: CGPoint!
    
    var helpNode: SKLabelNode!
    var helpIsOn: Bool = false
    var showNameNode: SKLabelNode!
    var showNameIsOn: Bool = true
    var moneyLabel: SKLabelNode!
    var money : Float = 20000.0 { // 200, unit as K.
        didSet {
            if money > 999.0 {
                let m = Int(money)
                moneyLabel.text = "\(moneyLogo)\(m / 1000),\((m % 1000) / 100)\((m % 100) / 10)\(m % 10)k"
            }
        }
    }
    var professorsLabel:SKLabelNode!
    var professors : Int = 20 {
        didSet {
            professorsLabel.text = "\(professorLogo)\(professors)"
        }
    }
    var yearLabel: SKLabelNode!
    var year : Int = 1830 {
        didSet {
            yearLabel.text = "\(year)"
        }
    }
    var currentOrder : Int = 0

    var selectedBuilding : Building!
    var infoBox :   InfoBox!
    var talkingBox: InfoBox!
    let talkingBoxOffset: CGFloat = 140 // moving offSet: 140

    // all house nodes:
    var gateHouse : Building!
    var eas :       Building!
    var carnagie:   Building!
    var walkerGym:  Building!
    var burchard :  Building!
    var howeCenter: Building!
    var library:    Building!
    var babbio :    Building!
    var ship:       Building!
    
    var buildingList: [Building] = []
    var buildingLabelOfName:[String:SKLabelNode] = [:]
    var buildingLabelNodeInHelp:[SKLabelNode] = []
    var buildingLabelInHelp:[String:CGPoint] = [:]

    // interface buttons:
    let buttonSize = CGSize(width: 53, height: 50)
    var infoButton = SKSpriteNode()
    var upgradeButton = SKSpriteNode()
    var infoUpgradeBtnIsShowing = false
    
    // treasure and quize:
    var treasureBox: TreasureBox!
    var treasureBoxIsOnMap: Bool = false
    
    var quize: Quize!
    var key: String!
    var userAnswer: String!
    var alreadySelect: Bool = false

    // teaching modules:
    var teachingStep: Int = 1
    var arrow = SKSpriteNode()
    
    
    
    //=== set up all items above ===========================================================
    
    func setUpMap(){
        
        campusMap = SKSpriteNode(imageNamed: "Stevens_map3.jpg")
        campusMap.position = CGPoint(x: 0, y: 0)
        campusMap.zPosition = LayerAt.Map.rawValue
        self.addChild(campusMap)
        
        mapWidth =  campusMap.frame.size.width
        mapHeight = campusMap.frame.size.height
        mapCarmmerLocation = campusMap.position
        // get print: campusMap.width = 2503.0, height = 3129.0
        print("campusMap.width = \(mapWidth), height = \(mapHeight)")
        // print("frame x, y = \(frameX), \(frameY)")
    }
    func setUpLabels(){

        yearLabel = SKLabelNode(text: "\(year)") // also indicates map status.
        yearLabel.fontColor = SKColor.white
        yearLabel.fontSize = 40
        yearLabel.fontName = textFontNameBold
        yearLabel.position = CGPoint(x: 0, y: self.frame.midY + 170)
        yearLabel.zPosition = LayerAt.ButtonLabels.rawValue
        self.addChild(yearLabel)
        
        professorsLabel = SKLabelNode(text: "\(professorLogo)\(professors)")
        professorsLabel.fontColor = SKColor.white
        professorsLabel.fontSize = 30
        professorsLabel.fontName = textFontName
        professorsLabel.position = CGPoint(x: self.frame.midX + 120, y: self.frame.midY + 170)
        professorsLabel.zPosition = LayerAt.ButtonLabels.rawValue
        self.addChild(professorsLabel)
        
        moneyLabel = SKLabelNode(text: "\(moneyLogo)\(money)K")
        moneyLabel.fontColor = SKColor.white
        moneyLabel.fontSize = 30
        moneyLabel.fontName = textFontName
        moneyLabel.position = CGPoint(x: self.frame.midX + 270, y: self.frame.midY + 170)
        moneyLabel.zPosition = LayerAt.ButtonLabels.rawValue
        self.addChild(moneyLabel)

        let boxSize = CGSize(width: self.frame.maxY * 0.95, height: self.frame.maxX * 0.95)
        let boxPosition = CGPoint(x: self.frame.midX, y: -self.frame.maxY)
        infoBox = InfoBox(boxImg: "dialogbox", size: boxSize, position: boxPosition, z: LayerAt.DialogBox.rawValue, buttonImg: "button-blue")
        self.addChild(infoBox.node)
        
        let sz = CGSize(width: self.frame.maxY * 0.9, height: self.frame.maxX * 0.35)
        let ps = CGPoint(x: self.frame.midX, y: self.frame.maxY*0.42) // above top line(Y*0.3)
        talkingBox = InfoBox(boxImg: "dialogbox-small", size: sz, position: ps, z: LayerAt.TalkingBox.rawValue)
        self.addChild(talkingBox.node)
        
    }
    
    func setUpBuildings(){

        let mapX = campusMap.frame.midX
        let mapY = campusMap.frame.midY
        let sd: CGFloat = 96 // side of initial wood-sign image
        // sign-newhouse  is init image
        
        gateHouse = Building(image: "sign-newhouse", name: "The Gate House", year: 1835, order: 1,numOfStudents: 100, upGradeCost: 100, x: mapX+450, y: mapY-210, width: sd, height: sd)

        eas = Building(image: "sign-newhouse", name: "Edwin A. Stevens Building", year: 1870, order: 1,numOfStudents: 200, upGradeCost: 1000, x: mapX+850, y: mapY-580, width: sd, height: sd)
        
        carnagie = Building(image: "sign-newhouse", name: "Carnegie Laboratory", year: 1902, order: 2, numOfStudents: 500, upGradeCost: 2000, x: mapX+240, y: mapY-410, width: sd, height: sd)
        
        walkerGym = Building(image: "sign-newhouse", name: "Walker Gymnasium", year: 1916, order: 2, numOfStudents: 500, upGradeCost: 3100, x: mapX-100, y: mapY-50, width: sd, height: sd)
        
        burchard = Building(image: "sign-newhouse", name: "Burchard Building", year: 1958, order: 3, numOfStudents: 900, upGradeCost: 6100, x: mapX+520, y: mapY-500, width: sd, height: sd)
        
        howeCenter = Building(image: "sign-newhouse", name: "W.Howe Center", year: 1959, order: 3, numOfStudents: 1200, upGradeCost: 7300, x: mapX-280, y: mapY+350, width: sd, height: sd)
        
        library = Building(image: "sign-newhouse", name: "Samuel C. Williams Library", year: 1960, order: 4, numOfStudents: 1800, upGradeCost: 8000, x: mapX-360, y: mapY+9, width: sd, height: sd)
        
        babbio = Building(image: "sign-newhouse", name: "Babbio Center", year: 2006, order: 4, numOfStudents: 2200, upGradeCost: 9100, x: mapX+631, y: mapY-230, width: sd, height: sd)
        
        ship = Building(image: "sign-newhouse", name: "Ship", year: 1833, order: 5, numOfStudents: 100, upGradeCost: 100, x: mapX + 490, y: mapY + 330, width: sd, height: sd)

        buildingList.append(gateHouse)
        buildingList.append(eas)
        buildingList.append(carnagie)
        buildingList.append(walkerGym)
        buildingList.append(burchard)
        buildingList.append(howeCenter)
        buildingList.append(library)
        buildingList.append(babbio)
        buildingList.append(ship)

        for building in buildingList {
            campusMap.addChild(building.node)
            
            // and add Label for names
            let name = building.name 
            let label = SKLabelNode(text: name)
            label.fontName = textFontName
            label.fontSize = 20
            label.fontColor = UIColor.yellow
            label.position = building.node.position + CGPoint(x: 0, y: 60)
            label.zPosition = LayerAt.BuildingNameLabel.rawValue
            
            campusMap.addChild(label)
            buildingLabelOfName[name] = label
        }
/*      // open to see coordinate marks on map:
        let initx = Int(campusMap.frame.midX)
        let inity = Int(campusMap.frame.midY)
        for x in Int(campusMap.frame.minX)...Int(campusMap.frame.maxX) {
            for y in Int(campusMap.frame.minY)...Int(campusMap.frame.maxY) {
                if x % 50 == 0 && y % 50 == 0 {
                    let cord = SKLabelNode(text: "\(x - initx):\(y - inity)")
                    cord.fontName = textFontName
                    cord.fontSize = 12
                    cord.position = CGPoint(x: x, y: y)
                    cord.zPosition = 7
                    campusMap.addChild(cord)
                }
            }
        }
*/
    }

    func setUpButtons(){
        
        helpNode = SKLabelNode(text: "\(helpLogo)") // the book at left-bottom sceen.
        helpNode.fontSize = 50
        helpNode.position = CGPoint(x: -self.frame.midX - 330, y: -self.frame.midY - 190)
        helpNode.zPosition = LayerAt.ButtonLabels.rawValue
        self.addChild(helpNode)

        showNameNode = SKLabelNode(text: "\(showNameLogo)") //
        showNameNode.fontSize = 60
        showNameNode.position = CGPoint(x: -self.frame.midX - 330, y: -self.frame.midY - 123)
        showNameNode.zPosition = LayerAt.ButtonLabels.rawValue
        self.addChild(showNameNode)
        
        infoButton = SKSpriteNode(imageNamed: "button-info")
        infoButton.size = buttonSize
        infoButton.position = CGPoint(x: self.frame.midX - 36, y: self.frame.midY - 240) // - 180)
        infoButton.zPosition = LayerAt.ButtonLabels.rawValue
        self.addChild(infoButton)
        
        upgradeButton = SKSpriteNode(imageNamed: "button-hammer")
        upgradeButton.size = buttonSize
        upgradeButton.position = CGPoint(x: self.frame.midX + 36, y: self.frame.midY - 240) // - 180)
        upgradeButton.zPosition = LayerAt.ButtonLabels.rawValue
        self.addChild(upgradeButton)
        
    }
    
    func setUpQuize(){
        let randomSelect = Int(arc4random()) % (quizes.count / 5)
        self.quize = Quize(quizeNum: randomSelect)
    }
    
    func refrashTreasureBox(){
        self.treasureBox.isShowing = true // zPosition == 3
        //create treasure box
        let offset: CGFloat = 150
        let actualX = random(min: campusMap.frame.midX - offset, max: campusMap.frame.midX + offset)
        let actualY = random(min: campusMap.frame.midY - offset, max: campusMap.frame.midY + offset)
        // Position the box slightly off-screen along the right edge,
        treasureBox.node.position = CGPoint(x: actualX, y: actualY)
        
        setUpQuize() // get a new quize.
     }
    func setUpTreasure(){
        let tPosition = CGPoint(x: campusMap.frame.midX, y: campusMap.frame.midY)
        self.treasureBox = TreasureBox(img: "treasure-box-glow", initPosition: tPosition)
        
        campusMap.addChild(treasureBox.node)
        
        _ = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(GameScene.refrashTreasureBox), userInfo: nil, repeats: true)
        
    }
    func treasureBoxExplosionAction(){
        
        // action effect:
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = treasureBox.node.position
        explosion.zPosition = 6
        
        campusMap.addChild(explosion)
        
        campusMap.run(SKAction.wait(forDuration: 8), completion: {
            explosion.removeFromParent()
        })
    }
    
    
    func setUpTeaching() { // the new player guide, only run once. ---------------------
        
        let clr = UIColor.black
        let talkPosi = CGPoint(x: self.frame.midX + 30, y: self.frame.midY + 33)
        let wordInLn = 36  // for talking box paragraph.
        let fontSize: CGFloat = 27 // for talking box paragraph.
        selectedBuilding = gateHouse

        if teachingStep == 1 { // show welcome box, game info and task: build gatehouse.
            let midX = infoBox.node.frame.midX
            let midY = infoBox.node.frame.midY
            let maxX = infoBox.node.frame.maxX
            let maxY = infoBox.node.frame.maxY
            
            infoBox.node.removeAllChildren()

            let duckSize = CGSize(width: 160, height: 200)
            let duckPosi = CGPoint(x: midX - 236, y: midY - 76)
            infoBox.addTitle(text: "Welcome To Stevens")
            infoBox.addContent(image: "duck", imgSize: duckSize, atPosition: duckPosi)
            infoBox.addParagraph(pText: "Hi! My name is Atlanda Stevens. Let's make the world better. I will lead you to get ready for your great advanture in Stevens Institue of Technology! ", numOfCharInLine: 40, color: clr, fontSize: 30, fontName: textFontName, initPosition: CGPoint(x: midX , y: maxY - 40))
            let base: CGFloat = 160
            let offset:CGFloat = 33
            let sz: CGFloat = 23
            infoBox.addTextLabel(text: "\(professorLogo) = professors & students", color: clr, fontSize: sz, fontName: textFontName, atPosition: CGPoint(x: midX+60, y: maxY-base-offset))
            infoBox.addTextLabel(text: "\(moneyLogo) = money resource you own", color: clr, fontSize: sz, fontName: textFontName, atPosition: CGPoint(x: midX+60, y: maxY - base - offset * 2))
            infoBox.addTextLabel(text: "\(helpLogo) see all buildings on campus", color: clr, fontSize: sz, fontName: textFontName, atPosition: CGPoint(x: midX+60, y: maxY - base - offset * 3))
            infoBox.addTextLabel(text: "OK, now let's build first house⏩", color: clr, fontSize: sz, fontName: textFontName, atPosition: CGPoint(x: midX+60, y: maxY - base - offset * 4))

            infoBox.addTextLabel(text: "Tap to continue~ ", color: UIColor.brown, fontSize: 30, fontName: textFontNameBold, atPosition: CGPoint(x: midX + 30, y: midY-160))

            infoBox.moveBoxAtBottom(toshow: true, offSet: self.frame.maxY)
            
        }
        else if teachingStep == 2 { // move to gatehouse, tap it;
            
            infoBox.moveBoxAtBottom(toshow: false, offSet: self.frame.maxY)

            arrow = SKSpriteNode(imageNamed: "arrow-left")
            arrow.size = CGSize(width: 150, height: 150)
            arrow.position = gateHouse.node.position + CGPoint(x: -100, y: +10)
            arrow.zPosition = LayerAt.Arrow.rawValue
            let moveR = SKAction.move(by: CGVector(dx: -60, dy: 0), duration: 0.5)
            let moveL = SKAction.move(by: CGVector(dx:  60, dy: 0), duration: 0.5)
            let action = SKAction.repeatForever(SKAction.sequence([moveR, moveL]))
            arrow.run(action)
            campusMap.addChild(arrow)
            
            let moveToGateHouse = SKAction.move(by: CGVector(dx: -410, dy: 100), duration: 1)
            self.campusMap.run(moveToGateHouse)
            
            let words = "These signs are your buildings yet to build. Tap it. "
            talkingBox.addParagraph(pText: words, numOfCharInLine: wordInLn, color: clr, fontSize: fontSize, fontName: textFontName, initPosition: talkPosi)
            talkingBox.moveBoxAtTop(toshow: true, offSet: talkingBoxOffset)
            
        }
        else if teachingStep == 3 { // show arrow to open info-box;
            
            // talkingBox.moveBoxAtTop(toshow: false, offSet: talkingBoxOffset)
            talkingBox.node.removeAllChildren()
            arrow.removeFromParent()
            
            moveInfoAndUpgradeButtons(toshow: true)
            
            arrow = SKSpriteNode(imageNamed: "arrow-down")
            arrow.size = CGSize(width: 130, height: 130)
            arrow.position = gateHouse.node.position + CGPoint(x: -80, y: +10)
            arrow.zPosition = LayerAt.Arrow.rawValue
            let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 40), duration: 0.5)
            let moveDn = SKAction.move(by: CGVector(dx: 0, dy: -40), duration: 0.5)
            let action = SKAction.repeatForever(SKAction.sequence([moveUp, moveDn]))
            arrow.run(action)
            campusMap.addChild(arrow)
            
            let words = "Great! This is [info-button], tap it to read detail story. "
            talkingBox.addParagraph(pText: words, numOfCharInLine: wordInLn, color: clr, fontSize: fontSize, fontName: textFontName, initPosition: talkPosi)
            talkingBox.moveBoxAtTop(toshow: true, offSet: talkingBoxOffset)
            
            // talkingBox.moveBoxAtTop(toshow: false, offSet: talkingBoxOffset)
        }
        else if teachingStep == 4 { // open info box
            
            // talkingBox.moveBoxAtTop(toshow: false, offSet: talkingBoxOffset)
            talkingBox.node.removeAllChildren()
            
            arrow.removeAllActions()
            arrow.removeFromParent()
            let words = "Here is introduction of this house, it may help you to win extra \(moneyLogo) in Happy Quize. Tap to read more ~  "
            talkingBox.addParagraph(pText: words, numOfCharInLine: wordInLn, color: clr, fontSize: fontSize, fontName: textFontName, initPosition: talkPosi + CGPoint(x: 0, y: 10))
            talkingBox.moveBoxAtTop(toshow: true, offSet: talkingBoxOffset)
            
            showInfoBoxOf(currentBuilding: selectedBuilding)
            
        }
        else if teachingStep == 5 { // close hint, only show infoBox
            
            talkingBox.moveBoxAtTop(toshow: false, offSet: talkingBoxOffset)
            
        }
        else if teachingStep == 6 { // close info box, show arrow to upgrade-btn;
            
            infoBox.moveBoxAtBottom(toshow: false, offSet: self.frame.maxY)
            // talkingBox.moveBoxAtTop(toshow: false, offSet: talkingBoxOffset)
            // talkingBox.node.removeAllChildren()
            
            arrow.removeAllActions()
            arrow.size = CGSize(width: 130, height: 130)
            arrow.position = gateHouse.node.position + CGPoint(x: 10, y: 10)
            arrow.zPosition = LayerAt.Arrow.rawValue
            let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 60), duration: 0.5)
            let moveDn = SKAction.move(by: CGVector(dx: 0, dy: -60), duration: 0.5)
            let action = SKAction.repeatForever(SKAction.sequence([moveUp, moveDn]))
            arrow.run(action)
            campusMap.addChild(arrow)
            
            let words = "OK, now let's see how to build it. This is [upgrade] button, tap it.  "
            talkingBox.addParagraph(pText: words, numOfCharInLine: wordInLn, color: clr, fontSize: fontSize, fontName: textFontName, initPosition: talkPosi)
            talkingBox.moveBoxAtTop(toshow: true, offSet: talkingBoxOffset)
            
        }
        else if teachingStep == 7 { // open upgrade box:
            
            arrow.removeFromParent()
            // talkingBox.moveBoxAtTop(toshow: false, offSet: talkingBoxOffset)
            talkingBox.node.removeAllChildren()

            showUpGradBoxOf(currentBuilding: selectedBuilding)
            
            let words = "Use \(moneyLogo)\(selectedBuilding.upGradeCost) to build the Gate House. This box showing how many population you can get after upgrading.  "
            talkingBox.addParagraph(pText: words, numOfCharInLine: wordInLn, color: clr, fontSize: fontSize, fontName: textFontName, initPosition: talkPosi + CGPoint(x: 0, y: 10))
            // talkingBox.moveBoxAtTop(toshow: true, offSet: talkingBoxOffset)
            
            arrow = SKSpriteNode(imageNamed: "arrow-left")
            arrow.size = CGSize(width: 150, height: 150)
            arrow.position = CGPoint(x: self.frame.midX-160, y: self.frame.midY - 130)
            arrow.zPosition = LayerAt.Arrow.rawValue
            let moveR = SKAction.move(by: CGVector(dx: -50, dy: 0), duration: 0.5)
            let moveL = SKAction.move(by: CGVector(dx:  50, dy: 0), duration: 0.5)
            let action = SKAction.repeatForever(SKAction.sequence([moveR, moveL]))
//            let action = SKAction.repeat(SKAction.sequence([moveR, moveL]), count: 60)
            arrow.run(action)
//            arrow.run(action, completion: { arrow.removeFromParent() })
            self.addChild(arrow)
            
        }
        else if teachingStep == 8 { // upgrade the gate house
            
            arrow.removeFromParent()
            infoBox.moveBoxAtBottom(toshow: false, offSet: self.frame.maxY)
            // talkingBox.moveBoxAtTop(toshow: false, offSet: talkingBoxOffset)
            talkingBox.node.removeAllChildren()
            upGradeCurrentBuilding()
            
            let words = "😆Great! You build the Gate House! In this way you can build all houses based on reality of history of SIT.  "
            talkingBox.addParagraph(pText: words, numOfCharInLine: wordInLn, color: clr, fontSize: 20, fontName: textFontName, initPosition: talkPosi + CGPoint(x: 0, y: 10))
            talkingBox.moveBoxAtTop(toshow: true, offSet: talkingBoxOffset)
            
        }
        else if teachingStep == 9 {
            
            talkingBox.moveBoxAtTop(toshow: false, offSet: talkingBoxOffset)
            
            let duckSize = CGSize(width: 160, height: 200)
            let duckPosi = CGPoint(x: infoBox.node.frame.midX - 236, y: infoBox.node.frame.midY - 76)
            let word = "OK! Try to read more story and find the [treasure box] on campus, you will get surprize and earn more \(moneyLogo). Enjoyin your advanture in Stevens. "
            infoBox.addTitle(text: "Go Stevens Ducks")
            infoBox.addCloseButton()
            infoBox.addContent(image: "duck", imgSize: duckSize, atPosition: duckPosi)
            infoBox.addButton(withText: "OK")
            infoBox.addParagraph(pText: word, numOfCharInLine: 40, color: clr, fontSize: 30, fontName: textFontName, initPosition: CGPoint(x: infoBox.node.frame.midX , y: infoBox.node.frame.maxY - 50))
            infoBox.moveBoxAtBottom(toshow: true, offSet: self.frame.maxY)
            
        }
        else if teachingStep == 10 {
            
            infoBox.moveBoxAtBottom(toshow: false, offSet: self.frame.maxY)
            
        }
        else if teachingStep == 20 { // show FInish Box
            
            infoBox.addCloseButton()
            infoBox.addTitle(text: "All Buildings Done!")
            
            let wordPos = CGPoint(x: infoBox.node.frame.midX, y: infoBox.node.frame.midY + 50)
            infoBox.addTextLabel(text: "🏆Congradulations!🏆", color: UIColor.black, fontSize: 36, fontName: textFontNameBold, atPosition: wordPos)
            infoBox.addTextLabel(text: "You have build all main buildings on Campuse!", color: UIColor.black, fontSize: 27, fontName: textFontName, atPosition: wordPos + CGPoint(x: 0, y: -100))
            
            infoBox.moveBoxAtBottom(toshow: true, offSet: self.frame.maxY)
            
        }
        
        teachingStep += 1 // move on for next step on calling.
    }

    
    func setUpGame() { //--- set up ALL seen and campus map -------------------------------------
        
        setUpMap()
        
        setUpLabels()
        
        setUpButtons()
        
        setUpBuildings()
        
        setUpQuize()
        
        setUpTreasure()
        
        setUpTeaching()
        
    }
    
    
    override func didMove(to view: SKView) { // game begins!!!
        
        setUpGame()
       
//        run(SKAction.repeatForever(
//            SKAction.sequence([
//                SKAction.run(setUpTreasure),
//                SKAction.wait(forDuration: 6.0)])
//        ))
    }
    

    
    
    func moving(targetButton: SKNode,toShow: Bool, byOffset: CGFloat) {
        let currentPosition = targetButton.position
        var offset: CGFloat = 0
        let hiddingLine: CGFloat = -201 // the bottom line of landscape screen.
//        print("currY: \(currentPosition.y), hiddingline=\(hiddingLine), maxX=\(self.frame.maxX)")
        if toShow && (currentPosition.y < hiddingLine) {
            offset = byOffset // 70  // move up
        }
        if (!toShow) && (currentPosition.y > hiddingLine) { // already hidden, no need to hide
            offset = -byOffset // 70  // move down
        }
        
        if offset != 0 {
            let move = SKAction.move(by: CGVector(dx: 0, dy: offset), duration: 0.25)
            targetButton.run(move)
        }
    }
    
    
    func moveInfoAndUpgradeButtons(toshow: Bool) {
        let moveDelta: CGFloat = 70
        
        if !infoUpgradeBtnIsShowing && toshow {
            moving(targetButton: infoButton,    toShow: toshow, byOffset: moveDelta)
            moving(targetButton: upgradeButton, toShow: toshow, byOffset: moveDelta)
            infoUpgradeBtnIsShowing = true
        }else
        if infoUpgradeBtnIsShowing && !toshow {
            moving(targetButton: infoButton,    toShow: toshow, byOffset: moveDelta)
            moving(targetButton: upgradeButton, toShow: toshow, byOffset: moveDelta)
            infoUpgradeBtnIsShowing = false
        }
    }
    
    func selectingOn(building: Building){
        selectedBuilding = building // mark global var.
        moveInfoAndUpgradeButtons(toshow: true)
        
        // add selecting effect: name becomes larger.
        for lab in buildingLabelOfName {
            if lab.key == building.name {
                lab.value.fontName = textFontNameBold
                lab.value.fontSize = 26
            }else{ // set back to default value:
                lab.value.fontName = textFontName
                lab.value.fontSize = 20
            }
        }
        
        if selectedBuilding.reword > 0 { // research already done!
            money += Float(selectedBuilding.reword)
            selectedBuilding.reword = -1 // reset as none research.
            selectedBuilding.timmingLabel.zPosition = -5
        }
    }
    
    
    func showInfoBoxOf(currentBuilding: Building){
        let introBuilding = descriptionOf[currentBuilding.name]!
        infoBox.addTitle(text: currentBuilding.name)

        let buildingImg = buildingInfoImgOf[currentBuilding.name]!
        let buildingSize = CGSize(width: 270, height: 270)
        let imgPosition = CGPoint(x: infoBox.node.frame.minX+100, y: infoBox.node.frame.midY-30)
        infoBox.addContent(image: buildingImg, imgSize: buildingSize, atPosition: imgPosition)
        
        let paragraphPosition = CGPoint(x: infoBox.node.frame.minX + 400, y: infoBox.node.frame.maxY - 50)
        infoBox.addParagraph(pText: introBuilding, numOfCharInLine: 30, color: UIColor.brown, fontSize: 27, fontName: textFontName, initPosition: paragraphPosition)
        
        //moveInfoBox(toshow: true)
        infoBox.moveBoxAtBottom(toshow: true, offSet: self.frame.maxY)
    }
    
    
    func showCondictionsLabel(){
        
        var addLabelText: String = " "
        let txFontsize: CGFloat = 21
        let infoTextPos = infoBox.button.position
        
        if selectedBuilding.upGradeCost > money {
            addLabelText = "You need more \(moneyLogo)\(selectedBuilding.upGradeCost - money) for up grade."
        }
        else if selectedBuilding.order >= currentOrder + 2 {
            addLabelText = "First, you need to build:"
            var offset: CGFloat = 0
            var count = 0
            
            for building in buildingOrders {
                if count >= 2 { // show at most 2 names.
                    break  // open this to limite number of building name display.
                }
                if building.value == max(1, currentOrder + 1) {
                    offset += 23
                    count += 1
                    
                    let preBuildPosition = infoTextPos + CGPoint(x: 100, y: 90 - offset)
                    infoBox.addTextLabel(text: building.key, color: UIColor.red, fontSize: txFontsize, fontName: textFontNameBold, atPosition: preBuildPosition)
                }
            }
        }
        let addLabelPosition = infoTextPos + CGPoint(x: 110, y: 90)
        infoBox.addTextLabel(text: addLabelText, color: UIColor.red, fontSize: txFontsize, fontName: textFontName, atPosition: addLabelPosition)
    }
    
    func upGradeCurrentBuilding(){ // call at touches --> when upgrade button tapped.
        print("checking order: selected Building order: \(selectedBuilding.order), current: \(currentOrder)")
        // Yes upgrade:
        if (selectedBuilding.upGradeCost < money) && (selectedBuilding.order <= currentOrder + 1) {
            
            money -= selectedBuilding.upGradeCost
            if selectedBuilding.year > year {
                year = selectedBuilding.year
            }
            professors += selectedBuilding.containStudents
            if currentOrder < selectedBuilding.order {
                currentOrder = selectedBuilding.order
            }
            buildingOrders.removeValue(forKey: selectedBuilding.name)
            
            // moveInfoBox(toshow: false)
            infoBox.moveBoxAtBottom(toshow: false, offSet: self.frame.maxY)
            
            selectedBuilding.upgradeIn(parentNode: campusMap)
            
            if selectedBuilding.year >= 2006 {
                teachingStep = 20 // go to show FINISH infobox.
                _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: Selector("setUpTeaching"), userInfo: nil, repeats: false)
            }
        }
        else{ // No upgrade, show a message:
            
            showCondictionsLabel()
            
        }
    }
    
    func showUpGradBoxOf(currentBuilding: Building){
        infoBox.addTitle(text: currentBuilding.name)
        infoBox.addCloseButton()
        infoBox.addButton()
        
        let textRsch = "\(researchLogo) \(buildingResearchOf[currentBuilding.name]!)"
        let textProf = "➕ \(professorLogo)\(currentBuilding.containStudents)"
        var textTime = "\(hourglassLogo) "
        let getTime : TimeInterval = buildingUpgradeTimeOf[currentBuilding.name]!
        let upGradTime = getIntTimeFrom(getSec: getTime)
        if upGradTime.hor > 0 {
            textTime += "\(upGradTime.hor)h "
        }
        if upGradTime.min > 0 {
            textTime += "\(upGradTime.min)m "
        }
        textTime += "\(upGradTime.sec)s"

        var infoText : [String] = [" "]
        infoText.removeAll()
        infoText.append(textRsch)
        infoText.append(textTime)
        infoText.append(textProf)
        
        var msgOffset: CGFloat = 0
        for msg in infoText {
            msgOffset += 40
            let txPosition = CGPoint(x: infoBox.node.frame.midX + 60, y: infoBox.node.frame.maxY - 66 - msgOffset)
            infoBox.addTextLabel(text: msg, color: UIColor.brown, fontSize: 26, fontName: textFontNameBold, atPosition: txPosition)
        }
        
        showCondictionsLabel()
        
        let size = CGSize(width: 260, height: 260)
        let nextImgPosition = CGPoint(x: infoBox.node.frame.minX+100, y: infoBox.node.frame.midY-30)
        let infoImg = buildingInfoImgOf[selectedBuilding.name]!
        infoBox.addContent(image: infoImg, imgSize: size, atPosition: nextImgPosition)
        
        var buttonLogo: String
        if currentBuilding.upGradeCost < money {
            buttonLogo = moneyLogo  // if allow upgrade.
        }else{
            buttonLogo = "🙈You need \(moneyLogo)"  // if not enough money.
        }
        let msgMoney = "\(buttonLogo) \(currentBuilding.upGradeCost)k"
        if currentBuilding.upGradeCost < money {
            infoBox.addButton(withText: msgMoney, color: UIColor.white)
        }else{
            infoBox.addButton(withText: msgMoney, color: UIColor.red)
        }

        infoBox.moveBoxAtBottom(toshow: true, offSet: self.frame.maxY)
    }
    
    func showResearchingBoxOf(currentBuilding: Building) {
        
        let titlePosition = CGPoint(x: infoBox.node.frame.midX, y: infoBox.node.frame.maxY-33)
        infoBox.addTitle(text: "Research in \(currentBuilding.name)", fontSize: 30, atPosition: titlePosition)

        let image = researchingImageOf[currentBuilding.name]!
        let imgsize = CGSize(width: 260, height: 260)
        let imgPosition = CGPoint(x: infoBox.node.frame.minX+100, y: infoBox.node.frame.midY-30)
        infoBox.addContent(image: image, imgSize: imgsize, atPosition: imgPosition)

        
        let text = researchLogo + researchDescriptionOf[currentBuilding.name]!
        let textposition = CGPoint(x: infoBox.node.frame.midX+30, y: infoBox.node.frame.maxY-150)
        infoBox.addParagraph(pText: text, numOfCharInLine: 23, color: UIColor.brown, fontSize: 30, fontName: textFontNameBold, initPosition: textposition)
        
//        infoBox.addButton()
        
        var buttonLogo: String = "🙈Need \(moneyLogo)"  // if not enough money.
        if currentBuilding.upGradeCost < money {
            buttonLogo = moneyLogo  // if allow upgrade.
        }
        let msgMoney = "\(buttonLogo) \(currentBuilding.researchCost) k"
        if currentBuilding.researchCost < money {
            infoBox.addButton(withText: msgMoney, color: UIColor.white)
        }else{
            infoBox.addButton(withText: msgMoney, color: UIColor.red)
        }

        infoBox.moveBoxAtBottom(toshow: true, offSet: self.frame.maxY)
    }
    
    func doResearchInCurrentBuilding() {
        if selectedBuilding.level == 0 { // not allow to do research before upgrade.
            return
        }
        if selectedBuilding.timeToFinish == 0 { // not doing research, then start.
            self.money -= Float(selectedBuilding.researchCost)
            selectedBuilding.setupResearch()
        }else{
            let wordPos = CGPoint(x: talkingBox.node.frame.midX, y: talkingBox.node.frame.midY)
            talkingBox.addTextLabel(text: "Oops! You need to wait for current research finish. ", color: UIColor.black, fontSize: 23, fontName: textFontName, atPosition: wordPos)
            talkingBox.moveBoxAtTop(toshow: true, offSet: talkingBoxOffset)
        }
        infoBox.moveBoxAtBottom(toshow: false, offSet: self.frame.maxY)
    }
    
    
    //=== quize operation =======================================
    // yes I know, I got a typo of "Quiz" without 'e'
    func showQuizeBox() {
        infoBox.node.removeAllChildren()
        
        infoBox.addTitle(text: "Stevens Happy Quiz")
        infoBox.addCloseButton()
        infoBox.setAsQuizeBox(qz: quize)
        
        // moveInfoBox(toshow: true)
        infoBox.moveBoxAtBottom(toshow: true, offSet: self.frame.maxY)
        
        self.key = quize.key
        
        // reset next quize
        // setUpQuize() // put it into judge()
    }
    func closeQuizeBox(){
        // moveInfoBox(toshow: false)
        infoBox.moveBoxAtBottom(toshow: false, offSet: self.frame.maxY)
    }
    func quizeJudge(selecting: SKLabelNode){
        alreadySelect = true
        let keyLabel = SKLabelNode(text: selecting.text)
        keyLabel.fontName = selecting.fontName
        keyLabel.fontSize = selecting.fontSize
        keyLabel.position = selecting.position
        keyLabel.zPosition = selecting.zPosition + 1
        
        let keyImg = SKLabelNode()
        keyImg.fontSize = 50
        keyImg.fontName = textFontNameBold
        keyImg.position = CGPoint(x: selecting.position.x - 200, y: selecting.position.y)
        keyImg.zPosition = keyLabel.zPosition + 1
        
        if selecting.text == key {
            let getMoney = 100 + Int(arc4random() % 100)
            self.money += Float(getMoney)
            
            keyLabel.fontColor = UIColor.green
            keyImg.text = "😁+💰\(getMoney) k"
        }else{
            keyLabel.fontColor = UIColor.red
            keyImg.text = "😰❗️"
            
            let rightKey = SKLabelNode(text: "Key: \(key!)")
            rightKey.fontSize = 30
            rightKey.fontName = textFontNameBold
            rightKey.fontColor = UIColor.blue
            rightKey.position = CGPoint(x: infoBox.node.frame.midX, y: infoBox.node.frame.midY)
            rightKey.zPosition = selecting.zPosition
            infoBox.node.addChild(rightKey)
        }
        infoBox.node.addChild(keyLabel)
        infoBox.node.addChild(keyImg)
        
        let _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(GameScene.closeQuizeBox), userInfo: nil, repeats: false)
    }
    
    
    //helpNode settings
    func showHelpBox(){
        if helpIsOn && infoBox.isShowing {
            helpIsOn = false
        }else if !helpIsOn && !infoBox.isShowing {
            helpIsOn = true
        }
        infoBox.addTitle(text: "List Of All buildings")
        
        let midx = infoBox.node.frame.midX
        let maxy = infoBox.node.frame.maxY - 10
        var offset : CGFloat = 36
        for building in buildingList {
            offset += 30
            let name = building.name
            let lab = SKLabelNode(text: name)
            lab.fontName = textFontName
            lab.fontSize = 27
            lab.fontColor = UIColor.black
            lab.position = CGPoint(x: midx, y: maxy) - CGPoint(x: 0, y: offset)
            lab.zPosition = LayerAt.DialogBoxButton.rawValue
            infoBox.node.addChild(lab)
            
            buildingLabelNodeInHelp.append(lab)
            let x = building.node.position.x
            let y = building.node.position.y
            let pos = CGPoint(x: -x, y: -y)
            //            let pos = building.node.position // + (CGPoint(x: -820, y: 200))
            buildingLabelInHelp[name] = pos
        }
        infoBox.addCloseButton()
        infoBox.moveBoxAtBottom(toshow: true, offSet: self.frame.maxY)
        
        
        //        infoBox.setAsHelpBox(bn: linkName)
        //        infoBox.moveBoxAtBottom(toshow: true, offSet: self.frame.maxY)
    }
    
    
    
    // allow tapped to move the map:
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        //--- for teaching step ----------
        if teachingStep <= 10 { // do teaching guide.
            setUpTeaching() // do step++
            return
        }

        let touch = touches.first! as UITouch
        let locationOnScreen = touch.location(in: self)
        let locationOnMap = touch.location(in: campusMap)
        let locationOnInfoBox = touch.location(in: infoBox.node)
        
        for touch: AnyObject in touches {
            
            // Check if the location of the touch is within the button's bounds---------------------
            if helpNode.contains(locationOnScreen) && !infoBox.isShowing {
                showHelpBox()
            }
            else if showNameNode.contains(locationOnScreen) && !infoBox.isShowing {
                if showNameIsOn {
                    showNameIsOn = false
                    for lab in buildingLabelOfName { // hide labels below map.
                        lab.value.zPosition = -1
                    }
                }
                else {
                    showNameIsOn = true
                    for lab in buildingLabelOfName { // show labels out from map.
                        lab.value.zPosition = LayerAt.Buildings.rawValue
                    }
                }
            }
                // Interface buttons:-----------------------------------------------------------
            else if infoButton.contains(locationOnScreen) && !infoBox.isShowing {
                showInfoBoxOf(currentBuilding: selectedBuilding)
             }
            else if upgradeButton.contains(locationOnScreen) && !infoBox.isShowing {
                if selectedBuilding.level == 0 {
                    showUpGradBoxOf(currentBuilding: selectedBuilding)
                }else{
                    showResearchingBoxOf(currentBuilding: selectedBuilding)
                }
            }
            else if treasureBox.isShowing && treasureBox.node.contains(locationOnMap) {
                treasureBoxExplosionAction()
                showQuizeBox()
                treasureBox.isShowing = false // hide it after tapping!!!
                alreadySelect = false   // allow selectons listening to tap action.
            }
                // quize box listener:-----------------------------------------------------------
            else if !alreadySelect && infoBox.selectA.contains(locationOnInfoBox){
                userAnswer = infoBox.selectA.text
                quizeJudge(selecting: infoBox.selectA)
            }
            else if !alreadySelect && infoBox.selectB.contains(locationOnInfoBox){
                userAnswer = infoBox.selectB.text
                quizeJudge(selecting: infoBox.selectB)
            }
            else if !alreadySelect && infoBox.selectC.contains(locationOnInfoBox){
                userAnswer = infoBox.selectC.text
                quizeJudge(selecting: infoBox.selectC)
            }
                // infoBox listener: upgrade and research action.-------------------------------
            else if infoBox.closeButton.contains(locationOnInfoBox) {
                // moveInfoBox(toshow: false)
                infoBox.moveBoxAtBottom(toshow: false, offSet: self.frame.maxY)
            }
            else if helpIsOn && infoBox.isShowing {
                for label in buildingLabelNodeInHelp {
                    if label.contains(locationOnInfoBox) {
                        let getName = label.text
                        let positionSelected = buildingLabelInHelp[getName!]
                        let action = SKAction.move(to: positionSelected!, duration: 1)
                        campusMap.run(action)
                        
                        for building in buildingList {
                            if building.name == getName {
//                                selectedBuilding = building
                                selectingOn(building: building)
                            }
                        }
                    }
                }
                helpIsOn = false
                infoBox.moveBoxAtBottom(toshow: false, offSet: self.frame.maxY)
            }
            else if infoBox.isShowing && infoBox.button.contains(locationOnInfoBox) {
                if selectedBuilding.level == 0 {
                    upGradeCurrentBuilding()
                }else{ // level > 0, allow to:
                    doResearchInCurrentBuilding()
                }
            }
            else if infoBox.node.contains(locationOnInfoBox) { // this MUST behide buttonsss!!
                // tapping infoBox itself, do nothing.
            }
                // building Listener: ----------------------------------------------------------
            else if gateHouse.node.contains(locationOnMap) {
                selectingOn(building: gateHouse)
            }
            else if eas.node.contains(locationOnMap) {
                selectingOn(building: eas)
            }
            else if carnagie.node.contains(locationOnMap) {
                selectingOn(building: carnagie)
            }
            else if walkerGym.node.contains(locationOnMap) {
                selectingOn(building: walkerGym)
            }
            else if burchard.node.contains(locationOnMap) {
                selectingOn(building: burchard)
            }
            else if howeCenter.node.contains(locationOnMap) {
                selectingOn(building: howeCenter)
            }
            else if library.node.contains(locationOnMap){
                selectingOn(building: library)
            }
            else if babbio.node.contains(locationOnMap) {
                selectingOn(building: babbio)
            }
            else if ship.node.contains(locationOnMap) {
                selectingOn(building: ship)
            }
                // tapping on campusMap: --------------------------------------------------------
            else {
                moveInfoAndUpgradeButtons(toshow: false)
                infoBox.moveBoxAtBottom(toshow: false, offSet: self.frame.maxY)
                talkingBox.moveBoxAtTop(toshow: false, offSet: talkingBoxOffset)

                money += 1000 // for testing
            }
        }
        
    }
    
    

    
    // set bound to keep map inside screen:--------------------------------------
    func boundLayerPos(aNewPosition: CGPoint) -> CGPoint {
        var newPoint = aNewPosition
        
        // let windowSize = self.size
        let windowSize = self.frame.size
/*
        newPoint.x = CGFloat(min(newPoint.x,  (mapWidth / 2)  - (windowSize.width / 2)  ))
        newPoint.x = CGFloat(max(newPoint.x, -(mapWidth / 2)  + (windowSize.width / 2)  ))
        newPoint.y = CGFloat(min(newPoint.y,  (mapHeight / 2) - (windowSize.height / 2) ))
        newPoint.y = CGFloat(max(newPoint.y, -(mapHeight / 2) + (windowSize.height / 2) ))
 */
        newPoint.x = CGFloat(min(newPoint.x,  (mapWidth / 2)  - (windowSize.width / 2)  ))
        newPoint.x = CGFloat(max(newPoint.x, -(mapWidth / 2)  + (windowSize.width / 2)  ))
        newPoint.y = CGFloat(min(newPoint.y,  (mapHeight / 2) - (windowSize.height / 6.6) ))
        newPoint.y = CGFloat(max(newPoint.y, -(mapHeight / 2) + (windowSize.height / 6.6) ))

        return newPoint
    }
    func panToNewPosition(newPosition: CGPoint, target: SKSpriteNode){
        if target.contains(newPosition) {
            let currPosition = campusMap.position
            //let toPosition = CGPoint(x: currPosition.x + newPosition.x, y: currPosition.y + newPosition.y)
            let toPosition = currPosition + newPosition
            
            campusMap.position = self.boundLayerPos(aNewPosition: toPosition)
        }
    }
    // and handling pans , move map by move on screen:
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if infoBox.isShowing == true { // then not allow to move map.
            return
        }
        
        var translation = CGPoint(x: 0, y: 0)
        
        for touch in touches {
            let pointInScene = touch.location(in: self)
            let prePosition = touch.previousLocation(in: self)

            //translation = CGPoint(x: pointInScene.x - prePosition.x, y: pointInScene.y - prePosition.y)
            translation = pointInScene - prePosition
                
            panToNewPosition(newPosition: translation, target: campusMap)
        }

    }

    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    
}
