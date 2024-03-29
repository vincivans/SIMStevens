//
//  InfoBox.swift
//  stevens
//
//  Created by Xin Zou on 11/2/16.
//  Copyright © 2016 Stevens. All rights reserved.
//

import Foundation
import SpriteKit


class InfoBox {
    var node: SKSpriteNode!
    var isShowing: Bool!
    var buttonImage:String!
    var button: SKSpriteNode!
    var closeButton: SKSpriteNode!
    
    var quizeQuestion: SKLabelNode!
    var selectA, selectB, selectC : SKLabelNode!
    
    // dialog box, has bit-button and close-button, NO quize buttons.
    init (boxImg:String, size:CGSize, position:CGPoint, z:CGFloat, buttonImg:String) {
        
        self.node = SKSpriteNode(imageNamed: boxImg)
        self.node.size = size
        self.node.position = position
        self.node.zPosition = z
        self.isShowing = false
        
        self.buttonImage = buttonImg
        self.addButton()
        
        self.addCloseButton()
        
        // for dialog box, we do not use them, but still need to init them: 
        self.quizeQuestion = SKLabelNode()
        self.selectA = SKLabelNode()
        self.selectB = SKLabelNode()
        self.selectC = SKLabelNode()
    }
    
    // small info box, without bit-button and close-button, NO quize buttons
    init(boxImg:String, size:CGSize, position:CGPoint, z:CGFloat) {
        
        self.node = SKSpriteNode(imageNamed: boxImg)
        self.node.size = size
        self.node.position = position
        self.node.zPosition = z
        self.isShowing = false
        
        // self.button = SKSpriteNode()  // no button but need to init it.
        self.button = makeMuteButton()
        
        // self.closeButton = SKSpriteNode() // no button but need to init it.
        self.closeButton = makeMuteButton()
    }

    
    
    
    // quize box:
    func setAsQuizeBox(qz:Quize){
        let titleOffset: CGFloat = 120   // from top to title
        let selectionOffset: CGFloat = 190        // from top to selections
        let seleOffset: CGFloat = 46    // line distence between selections.
        
        // self.quizeQuestion = SKLabelNode(text: qz.title)
        let titlePos = CGPoint(x: self.node.frame.midX, y: titleOffset)
        addParagraph(pText: qz.title, numOfCharInLine: 46, color: UIColor.brown, fontSize: 38, fontName: "AmericanTypewriter", initPosition: titlePos)
        self.selectA = SKLabelNode(text: qz.a)
        self.selectB = SKLabelNode(text: qz.b)
        self.selectC = SKLabelNode(text: qz.c)
        
        // setUpQuizeLabel(selected: self.quizeQuestion, Yoffset: titleOffset)
        setUpQuizeLabel(selected: self.selectA, Yoffset: selectionOffset +  seleOffset)
        setUpQuizeLabel(selected: self.selectB, Yoffset: selectionOffset + (seleOffset * 2))
        setUpQuizeLabel(selected: self.selectC, Yoffset: selectionOffset + (seleOffset * 3))
        
        // self.node.addChild(quizeQuestion)
        self.node.addChild(selectA)
        self.node.addChild(selectB)
        self.node.addChild(selectC)
        
    }
    
    func setUpQuizeLabel(selected: SKLabelNode, Yoffset: CGFloat){
        selected.fontName = "AmericanTypewriter-Bold"
        selected.fontSize = 30
        selected.fontColor = UIColor.brown
        selected.position = CGPoint(x: self.node.frame.midX, y: self.node.frame.maxY - Yoffset)
        selected.zPosition = self.node.zPosition + 1
    }
    
    // making button do NOT show in info box.
    func makeMuteButton() -> SKSpriteNode {
        let btn = SKSpriteNode()
        btn.size = CGSize(width: 1, height: 1)
        btn.position = CGPoint(x: -3000, y: -3000)
        btn.zPosition = 0 // do not show it
        return btn
    }
    
    
    //=== box operations ========================================
    
    func addButton(){
        self.button = SKSpriteNode(imageNamed: buttonImage)
        self.button.position = CGPoint(x: self.node.frame.midX, y: self.node.frame.minY+56)
        self.button.zPosition = self.node.zPosition + 1
        self.button.size = CGSize(width: 330, height: 50)
        self.node.addChild(button)
    }
    func addButton(withText: String) {
        self.addButton() // add button first!
        
        let lab = SKLabelNode(text: withText)
        lab.fontName = textFontNameBold
        lab.fontSize = 26
        lab.fontColor = UIColor.white
        lab.position = self.button.position + CGPoint(x: 0, y: -10)
        lab.zPosition = self.button.zPosition + 1
        self.node.addChild(lab)
    }
    func addButton(withText: String, color: UIColor) {
        self.addButton() // add button first!
        
        let lab = SKLabelNode(text: withText)
        lab.fontName = textFontNameBold
        lab.fontSize = 26
        lab.fontColor = color
        lab.position = self.button.position + CGPoint(x: 0, y: -10)
        lab.zPosition = self.button.zPosition + 1
        self.node.addChild(lab)
    }
    
    func addCloseButton() {
        self.closeButton = SKSpriteNode()
        self.closeButton.size = CGSize(width: 50, height: 50)
        self.closeButton.position = CGPoint(x: node.frame.maxX-23, y: node.frame.maxY-23)
        self.closeButton.zPosition = self.node.zPosition + 1
        self.node.addChild(closeButton)
    }
    
    func addTitle(text:String, fontSize:CGFloat, atPosition:CGPoint) {
        
        let title = SKLabelNode(text: text)
        title.fontSize = fontSize
        title.fontColor = UIColor.white
        title.fontName = "AmericanTypewriter-Bold"
        title.position = atPosition
        title.zPosition = self.node.zPosition + 1
        self.node.addChild(title)
        
    }
    
    func addTitle(text:String) { // use default title.
        let title = SKLabelNode(text: text)
        title.fontSize = 30
        title.fontColor = UIColor.white
        title.fontName = "AmericanTypewriter-Bold"
        title.position = CGPoint(x: self.node.frame.midX, y: self.node.frame.maxY - 33)
        title.zPosition = self.node.zPosition + 1
        self.node.addChild(title)
    }
    
    func addTextLabel(text:String, color:UIColor, fontSize:CGFloat, fontName:String, atPosition:CGPoint){
        
        let label = SKLabelNode(text: text)
        label.fontSize = fontSize
        label.fontName = fontName
        label.fontColor = color
        label.position = atPosition
        label.zPosition = self.node.zPosition + 2 // button is at layer 1
        self.node.addChild(label)
        
    }
    
    func addParagraph(pText:String, numOfCharInLine:Int, color: UIColor, fontSize:CGFloat, fontName:String, initPosition:CGPoint) {
        
        let numOfcharInLineMin = max(15, numOfCharInLine) // letters at least in one line
        var idx: Int = 1
        var paragraph: [String] = [""]
        var readyToEndLine = false
        
        var newLine = " "
        paragraph.removeAll()
        for i in pText.characters.indices { // break text into lines.
            if i <= pText.characters.endIndex {
                newLine.append(pText[i])
                if idx % numOfcharInLineMin == 0 {
                    readyToEndLine = true
                }
            }
            if readyToEndLine && pText[i] == " " {
                paragraph.append(newLine)
                newLine = "" // reset newline as empty.
                readyToEndLine = false
            }
            if idx == pText.characters.count {
                newLine.append(pText[i])
                paragraph.append(newLine) // end of searching getText
                readyToEndLine = true
            }
            idx += 1
        }
        // build nodes for all lines:
        var lineOffset: CGFloat = 0
        for line in paragraph {
            lineOffset += 27
            
            let aLine = SKLabelNode(text: line)
            aLine.fontSize = 23
            aLine.fontColor = color
            aLine.fontName = fontName
            aLine.position = CGPoint(x: initPosition.x, y: initPosition.y - lineOffset)
            aLine.zPosition = self.node.zPosition + 1
            
            self.node.addChild(aLine)
        }
    }
    
    
    func addContent(image:String, imgSize:CGSize, atPosition:CGPoint){
        
        let content = SKSpriteNode(imageNamed: image)
        content.size = imgSize
        content.position = atPosition
        content.zPosition = self.node.zPosition + 1
        self.node.addChild(content)
        
    }

    
    //=== box moving action =====================================
    
    fileprivate func movingUpward(targetButton: SKNode, toShow: Bool, byOffset: CGFloat) {
        let currentPosition = targetButton.position
        var offset: CGFloat = 0
        let hiddingLine: CGFloat = -201 // the bottom line of landscape screen.
        // print("currY: \(currentPosition.y), hiddingline=\(hiddingLine), maxX=\(self.frame.maxX)")
        if toShow && (currentPosition.y < hiddingLine) {
            offset = byOffset // move up
        }
        if (!toShow) && (currentPosition.y > hiddingLine) { // already hidden, no need to hide
            offset = -byOffset // move down
        }
        
        if offset != 0 {
            let move = SKAction.move(by: CGVector(dx: 0, dy: offset), duration: 0.25)
            targetButton.run(move)
        }
    }
    
    fileprivate func movingDownward(targetButton: SKNode, toShow: Bool, byOffset: CGFloat) {
        let currentPosition = targetButton.position
        var offset: CGFloat = 0
        let hiddingLine: CGFloat = 200 // the upper line of landscape screen.
        // print("currY: \(currentPosition.y), hiddingline=\(hiddingLine)")
        if toShow && (currentPosition.y > hiddingLine) { // already hidden, no need to hide
            offset = -byOffset // move down to show
        }
        if (!toShow) && (currentPosition.y < hiddingLine) {
            offset = byOffset // move up to hide
        }
        
        if offset != 0 {
            let move = SKAction.move(by: CGVector(dx: 0, dy: offset), duration: 0.25)
            targetButton.run(move)
        }
    }

    
    func moveBoxAtBottom(toshow: Bool, offSet: CGFloat) { // offSet == self.frame.maxY
        if self.isShowing && !toshow { // move down to hide
            movingUpward(targetButton: self.node, toShow: false, byOffset: offSet)
            self.node.removeAllChildren()
            
            self.isShowing = false // now already closed.
        }
        else if !self.isShowing && toshow {
                movingUpward(targetButton: self.node, toShow: true, byOffset: offSet)
                for child in self.node.children {
                    movingUpward(targetButton: child, toShow: true, byOffset: offSet)
                }
                self.isShowing = true // now already closed.
        }
    }
    
    func moveBoxAtTop(toshow: Bool, offSet: CGFloat) {
        if self.isShowing && !toshow { // move up to hide
            print("move up to hide, offSet = \(offSet)")
            movingDownward(targetButton: self.node, toShow: false, byOffset: offSet)
            self.node.removeAllChildren()
            
            self.isShowing = false
        }
        else if !self.isShowing && toshow { // move down to show
            print("move down to show, offSet = \(offSet)")
            movingDownward(targetButton: self.node, toShow: true, byOffset: offSet)
            for child in self.node.children {
                movingDownward(targetButton: child, toShow: true, byOffset: offSet)
            }
            self.isShowing = true
        }
    }


}


