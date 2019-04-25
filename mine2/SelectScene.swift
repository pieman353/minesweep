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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*if let label = self.label {
         label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
         }
         
         for t in touches { self.touchDown(atPoint: t.location(in: self)) } */
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        var boardSize = 0
        /*if (touchedNode.name == "begin") {
            print("touched begin")
            touchedNode.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            //let newScene = SelectScene()
            let newScene = SKScene(fileNamed: "SelectScene")
            newScene!.scaleMode = scaleMode
            let rev = SKTransition.fade(withDuration: 1.0)
            view?.presentScene(newScene!, transition: rev)
        } */
        switch (touchedNode.name) {
        case "9x9":
            boardSize = 9
        case "16x16":
            boardSize = 16
        default:
            boardSize = 30
        }
    }}
