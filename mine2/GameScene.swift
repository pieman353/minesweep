//
//  GameScene.swift
//  mine2
//
//  Created by Adam Piekarski on 4/24/19.
//  Copyright © 2019 Adam Piekarski. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if (touchedNode.name == "begin") {
            print("touched begin")
            touchedNode.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            //let newScene = SelectScene()
            let newScene = SelectScene(fileNamed: "SelectScene")
            newScene!.scaleMode = scaleMode
            let rev = SKTransition.fade(withDuration: 1.0)
            view?.presentScene(newScene!, transition: rev)
        }
        if (touchedNode.name == "scores") {
            touchedNode.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            let newScene = ScoreScene(fileNamed: "ScoreScene")
            newScene!.scaleMode = scaleMode
            let rev = SKTransition.fade(withDuration: 1.0)
            view?.presentScene(newScene!, transition: rev)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
    }
}
