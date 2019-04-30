//
//  boardScene.swift
//  mine2
//
//  Created by Adam Piekarski on 4/24/19.
//  Copyright © 2019 Adam Piekarski. All rights reserved.
//

import UIKit
import CoreData
import SpriteKit

class boardScene: SKScene {
    //var board: Board
    //var camera: SKCameraNode?
    
    var board: Board?
    var sequence: SKAction?
    var cam: SKCameraNode?
    var previousCameraScale = CGFloat()
    var timerLabel: SKLabelNode?
    var firstTap: Bool?
    var backButton: SKLabelNode?
    /*var timerValue = 0 {
        didSet {
            timerLabel!.text! = "\(minutes):\(seconds)"
        }
    } */
    var map: SKTileMapNode?
    var firstTouch: Bool?
    var minutes = 0
    var seconds = 0 {
        didSet {
            //print("did set!")
            timerLabel!.text! = String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    override func didMove(to view: SKView) {
        //board = Board(boardSize: 9)
        firstTouch = false
        timerLabel = childNode(withName: "timer") as? SKLabelNode
        firstTap = false
        cam = SKCameraNode()
        map = childNode(withName: "tileMap") as? SKTileMapNode
        //self.addChild(map!)
        backButton = childNode(withName: "back") as? SKLabelNode
        backButton!.removeFromParent()
        timerLabel!.removeFromParent()
        self.cam!.addChild(backButton!)
        self.cam!.addChild(timerLabel!)
        self.camera = cam
        self.addChild(cam!)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinchFrom(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (self.handleTapFrom(recognizer:)))
        self.view?.addGestureRecognizer(tapGesture)
        self.view?.addGestureRecognizer(pinchGesture)
        /*self.camera?.addChild(backButton!)
        self.camera?.addChild(timerLabel!) */
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
            //print("\(self.minutes):\(self.seconds)")
        })
        
        sequence = SKAction.sequence([wait, block])
        run(SKAction.repeatForever(sequence!), withKey: "time")
    }
    
    @objc func handleTapFrom(recognizer: UITapGestureRecognizer) {
        if recognizer.state != .ended {
            return
        }
        if !firstTap! {
            firstTap = true
            startTimer()
        }
        /*let recognizerLoc = recognizer.location(in: recognizer.view!)
        let loc = self.convertPoint(fromView: recognizerLoc)
        guard let map = childNode(withName: "tileMap") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        let col = map.tileColumnIndex(fromPosition: loc)
        let row = map.tileRowIndex(fromPosition: loc)
        let tile = map.tileDefinition(atColumn: col, row: row) */
        //tile!.textures[0] = SKTexture(imageNamed: "Grass_Grid_Center")
        //print("Column: \(col), Row: \(row)")
    }
    
    func updateTileImages() {
        for x in 0..<9 {
            for y in 0..<9 {
                let t = childNode(withName: "\(x)\(y)") as? SKSpriteNode
                if board!.board[x][y] == "y" {
                    if board!.isBomb(x: x, y: y) {
                        t!.texture = SKTexture(imageNamed: "Images/9")
                    }
                    else {
                        if board!.adjacentBombs[x][y] == 0 {
                        t!.texture = SKTexture(imageNamed: "Images/unexplored.png")
                        }
                        else {
                            t!.texture = SKTexture(imageNamed: "Images/\(board!.adjacentBombs[x][y])")
                        }
                    }
                }
                else if board!.board[x][y] == "x" {
                    if board!.isBomb(x: x, y: y) {
                        t!.texture = SKTexture(imageNamed: "Images/9")
                    }
                    else {
                        var mines = board!.adjacentBombs[x][y]
                        if mines == 9 {
                            t!.color = .red
                        }
                        else {
                            t!.texture = SKTexture(imageNamed: "Images/\(mines)")
                            
                        }
                    }
                    
                }
                else {
                    t!.color = .red
                }
            }
        }
    }
    
    @objc func handlePinchFrom(_ sender: UIPinchGestureRecognizer) {
        print("pinch!")
        guard let camera = self.camera else {
            return
        }
        if sender.state == .began {
            previousCameraScale = camera.xScale
        }
        camera.setScale(previousCameraScale * 1 / sender.scale)
        
    }
    
    func lose() {
        removeAction(forKey: "time")
        let alert = UIAlertController(title: "Game over", message: "You lost!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction!) in
            self.homeScreen()
        }
        alert.addAction(OKAction)
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func homeScreen() {
        let newScene = GameScene(fileNamed: "GameScene")
        newScene?.scaleMode = scaleMode
        let rev = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(newScene!, transition: rev)
        
    }
    
    func configureTextField(textField: UITextField!) {
        textField.text = "Enter your name"
    }
    
    func win() {
        removeAction(forKey: "time")
        let alert = UIAlertController(title: "Hooray!", message: "You won!", preferredStyle: .alert)
        alert.addTextField(configurationHandler: configureTextField)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction!) in
            let val = alert.textFields?.first?.text
            self.saveScore(name: val!, score: self.timerLabel!.text!)
            self.homeScreen()
        }
        alert.addAction(OKAction)
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func saveScore(name: String, score: String) {
        let del: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let con: NSManagedObjectContext = del.persistentContainer.viewContext
        let ent = NSEntityDescription.entity(forEntityName: "Entity", in: con)
        let newScore = NSManagedObject(entity: ent!, insertInto: con)
        newScore.setValue(name, forKey: "name")
        newScore.setValue(score, forKey: "score")
        do {
            try con.save()
        } catch {
            print("Failed saving")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /*if let label = self.label {
         label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
         }
         
         for t in touches { self.touchDown(atPoint: t.location(in: self)) } */
        guard let touch = touches.first else {
            return
        }
        //print("Select screen!")
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        //touchedNode.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        /*var boardSize = 0
        switch (touchedNode.name) {
        case "9x9":
            boardSize = 9
        case "16x16":
            boardSize = 16
        default:
            boardSize = 30
        } */
        //print("\(boardSize)")
        //var b = Board(boardSize: boardSize)
        /*let newScene = SKScene(fileNamed: "SelectScene")
         newScene!.scaleMode = scaleMode
         let rev = SKTransition.fade(withDuration: 1.0)
         view?.presentScene(newScene!, transition: rev) */
        //let newScene = boardScene(b: b)
        if touchedNode.name == "back" {
            touchedNode.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            let newScene = SelectScene(fileNamed: "SelectScene")
            newScene?.scaleMode = scaleMode
            let rev = SKTransition.fade(withDuration: 1.0)
            view?.presentScene(newScene!, transition: rev)
        }
        else if touchedNode.name != nil && touchedNode.name!.count == 2 {
            var name = touchedNode.name
            var x = Int(String(Array(name!)[0]))
            var y = Int(String(Array(name!)[1]))
            if (!firstTouch!) {
                board = Board(boardSize: 9, x: x!, y: y!)
                firstTouch = true
            }
            updateTileImages()
            var result = board!.touch(x: x!, y: y!)
            if board!.isBomb(x: x!, y: y!) {
                lose()
            }
            /*if result == -1 {
                print("Lost!")
                lose()
            } */
            if result == 1 {
                print("Won!")
                win()
            }
            updateTileImages()
        }
        
    }
    
    /*(init(b: Board) {
        board = b
        super.init()
        //board = b
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } */
}
