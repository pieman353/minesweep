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
    var timerLabel: SKLabelNode?
    var firstTap: Bool?
    /*var timerValue = 0 {
        didSet {
            timerLabel!.text! = "\(minutes):\(seconds)"
        }
    } */
    var minutes = 0
    var seconds = 0 {
        didSet {
            print("did set!")
            timerLabel!.text! = String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    override func didMove(to view: SKView) {
        timerLabel = childNode(withName: "timer") as? SKLabelNode
        firstTap = false
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
            let deltaY = previousLocation.y - location.y
            let deltaX = previousLocation.x - location.x
            cam!.position.y += deltaY
            cam!.position.x += deltaX
        }
        
    }
    
    func startTimer() {
        print("Timer")
        let wait = SKAction.wait(forDuration: 1)
        let block = SKAction.run({
            [unowned self] in
            if self.seconds + 1 == 60 {
                self.seconds = 0
                self.minutes = self.minutes + 1
            }
            else {
                self.seconds = self.seconds + 1
            }
            print("\(self.minutes):\(self.seconds)")
        })
        let sequence = SKAction.sequence([wait, block])
        run(SKAction.repeatForever(sequence), withKey: "time")
    }
    
    @objc func handleTapFrom(recognizer: UITapGestureRecognizer) {
        if recognizer.state != .ended {
            return
        }
        if !firstTap! {
            firstTap = true
            startTimer()
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
