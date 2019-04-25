//
//  SelectScene.swift
//  mine2
//
//  Created by Adam Piekarski on 4/24/19.
//  Copyright © 2019 Adam Piekarski. All rights reserved.
//

import UIKit
import SpriteKit

class SelectScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
       print("ran")
        
        // Create shape node to use during mouse interaction
        /*let w = (self.size.width + self.size.height) * 0.05
         self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
         
         if let spinnyNode = self.spinnyNode {
         spinnyNode.lineWidth = 2.5
         
         spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
         spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
         SKAction.fadeOut(withDuration: 0.5),
         SKAction.removeFromParent()]))
         } */
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*if let label = self.label {
         label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
         }
         
         for t in touches { self.touchDown(atPoint: t.location(in: self)) } */
        guard let touch = touches.first else {
            return
        }
        print("Select screen!")
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        touchedNode.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        var boardSize = 0
        switch (touchedNode.name) {
        case "9x9":
            boardSize = 9
        case "16x16":
            boardSize = 16
        default:
            boardSize = 30
        }
        print("\(boardSize)")
        var b = Board(boardSize: boardSize)
        /*let newScene = SKScene(fileNamed: "SelectScene")
        newScene!.scaleMode = scaleMode
        let rev = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(newScene!, transition: rev) */
        //let newScene = boardScene(b: b)
        let newScene = boardScene(fileNamed: "boardScene")
        newScene?.scaleMode = scaleMode
        let rev = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(newScene!, transition: rev)
        
    }
    
}
