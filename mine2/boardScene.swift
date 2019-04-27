//
//  boardScene.swift
//  mine2
//
//  Created by Adam Piekarski on 4/24/19.
//  Copyright © 2019 Adam Piekarski. All rights reserved.
//

import UIKit
import SpriteKit

class boardScene: SKScene {
    //var board: Board
    //var camera: SKCameraNode?
    
    var cam: SKCameraNode?
    var previousCameraScale = CGFloat()
    
    override func didMove(to view: SKView) {
        cam = SKCameraNode()
        self.camera = cam
        self.addChild(cam!)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinchFrom(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (self.handleTapFrom(recognizer:)))
        self.view?.addGestureRecognizer(tapGesture)
        self.view?.addGestureRecognizer(pinchGesture)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch in touches {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            let deltaY = location.y - previousLocation.y
            let deltaX = location.x - previousLocation.x
            cam!.position.y += deltaY
            cam!.position.x += deltaX
        }
        
    }
    
    @objc func handleTapFrom(recognizer: UITapGestureRecognizer) {
        if recognizer.state != .ended {
            return
        }
        let recognizerLoc = recognizer.location(in: recognizer.view!)
        let loc = self.convertPoint(fromView: recognizerLoc)
        guard let map = childNode(withName: "tileMap") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        let col = map.tileColumnIndex(fromPosition: loc)
        let row = map.tileRowIndex(fromPosition: loc)
        let tile = map.tileDefinition(atColumn: col, row: row)
        print("Column: \(col), Row: \(row)")
    }
    
    @objc func handlePinchFrom(_ sender: UIPinchGestureRecognizer) {
        print("pinch!")
        guard let camera = self.camera else {
            return
        }
        if sender.state == .began {
            previousCameraScale = camera.xScale
        }
        camera.setScale(previousCameraScale * 1 / sender.scale)        }
    
    
    /*(init(b: Board) {
        board = b
        super.init()
        //board = b
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } */
}
