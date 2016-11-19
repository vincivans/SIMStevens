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
        case ButtonLabels = 4
        case DialogBox = 5
        case DialogBoxButton = 6
        case DialogBoxImg = 7
    }
    func random()->CGFloat{//random generator
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max-min)+min
    }
    
    let textFontName:     String = "AmericanTypewriter"
    let textFontNameBold: String = "AmericanTypewriter-Bold"
    
    let moneyLogo : String = "💰"
    let professorLogo: String = "🎓"
    let researchLogo: String = "🚀"
    let hourglassLogo: String = "⌛️"
    let helpLogo = "📕"
    
    var campusMap : SKSpriteNode! // the map here!!!!!!
    var mapWidth : CGFloat!
    var mapHeight: CGFloat!
    var mapCarmmerLocation: CGPoint!
    
    var helpNode: SKLabelNode!
    var moneyLabel: SKLabelNode!
    var money : Float = 10.0 { // unit as K.
        didSet { /*
            if money <= 999.0 {
                moneyLabel.text = "\(moneyLogo)\(money)k"
            }else{
                moneyLabel.text = "\(moneyLogo)\(money / 1000.0)M"
            } */
            moneyLabel.text = "\(moneyLogo)\(money)k"
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
    var infoBox : InfoBox!
    var infoBoxIsShowing = false

    var gateHouse : Building!
    var eas : Building!
    var carnagie: Building!
    var walkerGym: Building!
    var burchard : Building!
    var howeCenter : Building!
    var library: Building!
    var babbio : Building!
    var ship: Building!

    var infoButton = SKSpriteNode()
    var upgradeButton = SKSpriteNode()
    var infoUpgradeBtnIsShowing = false
    
    let buttonSize = CGSize(width: 53, height: 50)

    var treasureBox: TreasureBox!
    var treasureBoxIsOnMap: Bool = false
    
    var quize: Quize!
    var key: String!
    var userAnswer: String!
    var alreadySelect: Bool = false
    
    
    //=== set up all items above ===========================================================
    
    func setUpMap(){
        
        campusMap = SKSpriteNode(imageNamed: "Stevens_map2.jpg")
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
/*
        infoBox = SKSpriteNode(imageNamed: "dialogbox")
        infoBox.size = CGSize(width: self.frame.maxY * 0.95, height: self.frame.maxX * 0.95)
        infoBox.position = CGPoint(x: self.frame.midX, y: -self.frame.maxY)
        infoBox.zPosition = LayerAt.DialogBox.rawValue
        infoBox.addChild(closeButton)
        self.addChild(infoBox)
*/
        let boxSize = CGSize(width: self.frame.maxY * 0.95, height: self.frame.maxX * 0.95)
        let boxPosition = CGPoint(x: self.frame.midX, y: -self.frame.maxY)
        infoBox = InfoBox(boxImg: "dialogbox", size: boxSize, position: boxPosition, z: LayerAt.DialogBox.rawValue, buttonImg: "button-blue")
        self.addChild(infoBox.node)
        
    }
    
    func setUpBuildings(){

        let mapX = campusMap.frame.midX
        let mapY = campusMap.frame.midY
        let sd: CGFloat = 96 // side of initial wood-sign image
        // sign-newhouse  is init image
        
        gateHouse = Building(image: "", name: "The Gate House", year: 1835, level: 0, order: 1,numOfStudents: 100, upGradeCost: 100, x: mapX+400, y: mapY-123, width: sd, height: sd)

        eas = Building(image: "Spaceship", name: "Edwin A. Stevens Building", year: 1870, level: 0, order: 1,numOfStudents: 200, upGradeCost: 1000, x: mapX+300, y: mapY-200, width: sd, height: sd)
        
        carnagie = Building(image: "sign-newhouse", name: "Carnegie Laboratory", year: 1902, level: 0, order: 2, numOfStudents: 500, upGradeCost: 2000, x: mapX-360, y: mapY+400, width: sd, height: sd)
        
        walkerGym = Building(image: "sign-newhouse", name: "Walker Gymnasium", year: 1916, level: 0, order: 2, numOfStudents: 500, upGradeCost: 3100, x: mapX-150, y: mapY+300, width: sd, height: sd)
        
        burchard = Building(image: "sign-newhouse", name: "Burchard Building", year: 1958, level: 0, order: 3, numOfStudents: 900, upGradeCost: 6100, x: mapX-10, y: mapY+10, width: sd, height: sd)
        
        howeCenter = Building(image: "sign-newhouse", name: "W.Howe Center", year: 1959, level: 0, order: 3, numOfStudents: 1200, upGradeCost: 7300, x: mapX-230, y: mapY+200, width: sd, height: sd)
        
        library = Building(image: "sign-newhouse", name: "Samuel C. Williams Library", year: 1960, level: 0, order: 4, numOfStudents: 1800, upGradeCost: 8000, x: mapX-100, y: mapY+260, width: sd, height: sd)
        
        babbio = Building(image: "sign-newhouse", name: "Babbio Center", year: 2006, level: 0, order: 4, numOfStudents: 2200, upGradeCost: 9100, x: mapX+360, y: mapY-70, width: sd, height: sd)
        
        ship = Building(image: "sign-newhouse", name: "Ship", year: 1833, level: 0, order: 5, numOfStudents: 100, upGradeCost: 100, x: mapX + 600, y: mapY - 230, width: sd, height: sd)
        
        campusMap.addChild(gateHouse.node)
        campusMap.addChild(eas.node)
        campusMap.addChild(carnagie.node)
        campusMap.addChild(walkerGym.node)
        campusMap.addChild(burchard.node)
        campusMap.addChild(howeCenter.node)
        campusMap.addChild(library.node)
        campusMap.addChild(babbio.node)
        campusMap.addChild(ship.node)
        
    }

    func setUpButtons(){
        
        helpNode = SKLabelNode(text: "\(helpLogo)") // the book at left-bottom sceen.
        helpNode.fontSize = 50
        helpNode.position = CGPoint(x: -self.frame.midX - 330, y: -self.frame.midY - 190)
        helpNode.zPosition = LayerAt.ButtonLabels.rawValue
        self.addChild(helpNode)
        
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
        
        //Determine where to add the box:
        // Position the box slightly off-screen along the right edge,
        let tPosition = CGPoint(x: campusMap.frame.midX, y: campusMap.frame.midY)

        self.treasureBox = TreasureBox(img: "treasure-box-glow", initPosition: tPosition)
        
        campusMap.addChild(treasureBox.node)
        
        _ = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(GameScene.refrashTreasureBox), userInfo: nil, repeats: true)
        
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

    
    func setUpGame() { //--- set up ALL seen and campus map -------------------------------------
        
        setUpMap()
        
        setUpLabels()
        
        setUpButtons()
        
        setUpBuildings()
        
        setUpQuize()
        
        setUpTreasure()
        
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
    func moveInfoBox(toshow: Bool) {
        if infoBoxIsShowing && !toshow {
            moving(targetButton: infoBox.node, toShow: false, byOffset: self.frame.maxY)
            infoBox.node.removeAllChildren()
            
            infoBoxIsShowing = false // now already closed.
        }else
        if !infoBoxIsShowing && toshow {
            moving(targetButton: infoBox.node, toShow: true, byOffset: self.frame.maxY)
            for child in infoBox.node.children {
                moving(targetButton: child, toShow: true, byOffset: self.frame.maxY)
            }
            infoBoxIsShowing = true // yes now it is showing
        }
    }
    
    func selectingOn(building: Building){
        selectedBuilding = building // mark global var.
        moveInfoAndUpgradeButtons(toshow: true)
    }
    
    
    func showInfoBoxOf(currentBuilding: Building){
        let titlePosition = CGPoint(x: infoBox.node.frame.midX, y: infoBox.node.frame.maxY-33)
        let introBuilding = descriptionOf[currentBuilding.name]!
        infoBox.addTitle(text: currentBuilding.name, fontSize: 36, atPosition: titlePosition)

        let buildingImg = buildingImageOf[currentBuilding.name]!
        let buildingSize = CGSize(width: 270, height: 270)
        let imgPosition = CGPoint(x: infoBox.node.frame.minX+100, y: infoBox.node.frame.midY-30)
        infoBox.addContent(image: buildingImg, imgSize: buildingSize, atPosition: imgPosition)
        
        let paragraphPosition = CGPoint(x: infoBox.node.frame.minX + 400, y: infoBox.node.frame.maxY - 50)
        infoBox.addParagraph(pText: introBuilding, numOfCharInLine: 30, color: UIColor.brown, fontSize: 27, fontName: textFontName, initPosition: paragraphPosition)
        
        moveInfoBox(toshow: true)
    }
    
    
    func showCondictionsLabel(){
        
        var addLabelText: String = " "
        let txFontsize: CGFloat = 21
        
        if selectedBuilding.upGradeCost > money {
            addLabelText = "You need more \(moneyLogo)\(selectedBuilding.upGradeCost - money) for up grade."
        }else
        if selectedBuilding.order >= currentOrder + 2 {
//        if selectedBuilding.year > year && selectedBuilding.order > currentOrder {
            addLabelText = "First, you need to build:"
            var offset: CGFloat = 0
            var count = 0
            
            for building in buildingOrders {
                if count == 2 { // show at most 2 names.
                    // break  // open this to limite number of building name display.
                }
                if building.value == max(1, currentOrder + 1) {
                    print("get building \(building.key), order \(building.value)")
                    offset += 23
                    count += 1
                    
                    let preBuildPosition = CGPoint(x: infoBox.button.position.x + 90, y: infoBox.button.position.y + 106 - offset)
                    infoBox.addTextLabel(text: building.key, color: UIColor.red, fontSize: txFontsize, fontName: textFontNameBold, atPosition: preBuildPosition)
                }
            }
        }
        let addLabelPosition = CGPoint(x: infoBox.button.position.x + 90, y: infoBox.button.position.y + 110)
        infoBox.addTextLabel(text: addLabelText, color: UIColor.red, fontSize: txFontsize, fontName: textFontName, atPosition: addLabelPosition)
    }
    
    func upGradeCurrentBuilding(){
        print("checking order: selected Building order: \(selectedBuilding.order), current: \(currentOrder)")
        // Yes upgrade:
        if selectedBuilding.upGradeCost < money && selectedBuilding.order <= currentOrder + 1 {
            
            money -= selectedBuilding.upGradeCost
            year = selectedBuilding.year
            professors += selectedBuilding.containStudents
            currentOrder = selectedBuilding.order
            buildingOrders.removeValue(forKey: selectedBuilding.name)
            print("after upgrade, current order : \(currentOrder)")
            
            moveInfoBox(toshow: false)
            
            selectedBuilding.upgradeIn(parentNode: campusMap)
            
        }else{ // No upgrade, show a message:
            
            showCondictionsLabel()
            
        }
    }
    
    func showUpGradBoxOf(currentBuilding: Building){
        infoBox.addTitle(text: currentBuilding.name)
        infoBox.addCloseButton()
        infoBox.addButton()
        
        let textRsch = "New Skill\(researchLogo) \(buildingResearchOf[currentBuilding.name]!)"
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
            let txPosition = CGPoint(x: infoBox.node.frame.midX + 30, y: infoBox.node.frame.maxY - 41 - msgOffset)
            infoBox.addTextLabel(text: msg, color: UIColor.brown, fontSize: 26, fontName: textFontNameBold, atPosition: txPosition)
        }
        
        showCondictionsLabel()
        
        let size = CGSize(width: 260, height: 260)
        let nextImgPosition = CGPoint(x: infoBox.node.frame.minX+100, y: infoBox.node.frame.midY-30)
        infoBox.addContent(image: "house15", imgSize: size, atPosition: nextImgPosition)
        
        
        var buttonLogo: String = "🙈Need \(moneyLogo)"  // if not enough money.
        if currentBuilding.upGradeCost < money {
            buttonLogo = moneyLogo  // if allow upgrade.
        }
        let msgMoney = "\(buttonLogo) \(currentBuilding.upGradeCost)k"
        var btnfontColor: UIColor!
        if currentBuilding.upGradeCost < money {
            btnfontColor = UIColor.white
        }else{
            btnfontColor = UIColor.red
        }
        let btnPosition = CGPoint(x: infoBox.button.frame.midX, y: infoBox.button.frame.midY - 10)
        infoBox.addTextLabel(text: msgMoney, color: btnfontColor, fontSize: 26, fontName: textFontNameBold, atPosition: btnPosition)
        
        moveInfoBox(toshow: true)
    }
    
    func showResearchingBoxOf(currentBuilding: Building) {
        
        let titlePosition = CGPoint(x: infoBox.node.frame.midX, y: infoBox.node.frame.maxY-33)
        infoBox.addTitle(text: "Research in \(currentBuilding.name)", fontSize: 30, atPosition: titlePosition)

        let image = researchingImageOf[currentBuilding.name]!
        let imgsize = CGSize(width: 260, height: 260)
        let imgPosition = CGPoint(x: infoBox.node.frame.minX+100, y: infoBox.node.frame.midY-30)
        infoBox.addContent(image: image, imgSize: imgsize, atPosition: imgPosition)

        
        let text = researchLogo + researchDescriptionOf[currentBuilding.name]!
        let textposition = CGPoint(x: infoBox.node.frame.midX+30, y: infoBox.node.frame.maxY-90)
        infoBox.addParagraph(pText: text, numOfCharInLine: 23, color: UIColor.brown, fontSize: 30, fontName: textFontNameBold, initPosition: textposition)
        
        infoBox.addButton()
        
        var buttonLogo: String = "🙈Need \(moneyLogo)"  // if not enough money.
        var buttonTextColor = UIColor.white
        if currentBuilding.upGradeCost < money {
            buttonLogo = moneyLogo  // if allow upgrade.
        }
        let msgMoney = "\(buttonLogo) \(currentBuilding.upGradeCost)k"
        if currentBuilding.upGradeCost < money {
            buttonTextColor = UIColor.white
        }else{
            buttonTextColor = UIColor.red
        }
        let buttonTextPosition = CGPoint(x: infoBox.button.frame.midX, y: infoBox.button.frame.midY-10)
        infoBox.addTextLabel(text: msgMoney, color: buttonTextColor, fontSize: 26, fontName: textFontNameBold, atPosition: buttonTextPosition)
        
        moveInfoBox(toshow: true)
    }
    
    func doResearchInCurrentBuilding() {
        
    }
    
    
    //=== quize operation =======================================
    
    func showQuizeBox() {
        infoBox.node.removeAllChildren()
        
        infoBox.addTitle(text: "Stevens Happy Quize")
        infoBox.addCloseButton()
        infoBox.setAsQuizeBox(qz: quize)
        
        moveInfoBox(toshow: true)
        
        self.key = quize.key
        
        // reset next quize
        // setUpQuize() // put it into judge()
    }
    func closeQuizeBox(){
        moveInfoBox(toshow: false)
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
            keyImg.text = "😁💰+\(getMoney)k"
        }else{
            keyLabel.fontColor = UIColor.red
            keyImg.text = "😰❗️"
        }
        infoBox.node.addChild(keyLabel)
        infoBox.node.addChild(keyImg)
        
        let _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(GameScene.closeQuizeBox), userInfo: nil, repeats: false)
    }
    
    
    // allow tapped to move the map:
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let locationOnScreen = touch.location(in: self)
        let locationOnMap = touch.location(in: campusMap)
        let locationOnInfoBox = touch.location(in: infoBox.node)
        
        for touch: AnyObject in touches {
            
            // Check if the location of the touch is within the button's bounds
            if helpNode.contains(locationOnScreen) && !infoBoxIsShowing {
                print("help node tapped!!! pop out helping box!")
                // moveInfoBox(toshow: true)
                
                // showQuizeBox()
            }
            else if infoButton.contains(locationOnScreen) && !infoBoxIsShowing {
                showInfoBoxOf(currentBuilding: selectedBuilding)
                // print("now infoBox at: \(infoBox.position)")
            }
            else if upgradeButton.contains(locationOnScreen) && !infoBoxIsShowing {
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
            else if !alreadySelect && infoBox.selectA.contains(locationOnInfoBox){
                userAnswer = infoBox.selectA.text
                quizeJudge(selecting: infoBox.selectA)
                print("user selection = \(userAnswer)")
                print("the key is: \(key)")
            }
            else if !alreadySelect && infoBox.selectB.contains(locationOnInfoBox){
                userAnswer = infoBox.selectB.text
                quizeJudge(selecting: infoBox.selectB)
                print("user selection = \(userAnswer)")
                print("the key is: \(key)")
            }
            else if !alreadySelect && infoBox.selectC.contains(locationOnInfoBox){
                userAnswer = infoBox.selectC.text
                quizeJudge(selecting: infoBox.selectC)
                print("user selection = \(userAnswer)")
                print("the key is: \(key)")
            }
            else if infoBox.closeButton.contains(locationOnInfoBox) {
                print("box close button tapped...close box.")
                moveInfoBox(toshow: false)
            }
            else if infoBoxIsShowing && infoBox.button.contains(locationOnInfoBox) {
                if selectedBuilding.level == 0 {
                    upGradeCurrentBuilding()
                }else{ // level > 0, allow to:
                    doResearchInCurrentBuilding()
                    print("do research in current building()")
                }
            }
            else if infoBox.node.contains(locationOnInfoBox) { // this MUST behide buttonsss!!
                // tapping itself, do nothing.
            }
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
//                print("ship tapped!!!!!!")
//                selectedBuilding = ship.node
//                showInfoAndUpgradeButtons()
                selectingOn(building: ship)
            }
            else { // tapping at campusMap:
                moveInfoAndUpgradeButtons(toshow: false)
                moveInfoBox(toshow: false)
                money += 500
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
        newPoint.y = CGFloat(min(newPoint.y,  (mapHeight / 2) - (windowSize.height / 6.1) ))
        newPoint.y = CGFloat(max(newPoint.y, -(mapHeight / 2) + (windowSize.height / 6.1) ))

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
        if infoBoxIsShowing { // then not allow to move map.
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
