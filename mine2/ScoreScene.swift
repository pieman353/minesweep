//
//  ScoreScene.swift
//  mine2
//
//  Created by Adam Piekarski on 4/30/19.
//  Copyright © 2019 Adam Piekarski. All rights reserved.
//

import UIKit
import CoreData
import SpriteKit

class ScoreScene: SKScene {
    
    var scorelabel: SKLabelNode?
    
    override func didMove(to view: SKView) {
        readScores()
        
        // Get label node from scene and store it for use later
        //print("ran")
        
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
    
    func readScores() {
        scorelabel = childNode(withName: "scorelabel") as? SKLabelNode!
        let del: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let con: NSManagedObjectContext = del.persistentContainer.viewContext
        let ent = NSEntityDescription.entity(forEntityName: "Entity", in: con)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        let sort = NSSortDescriptor(key: #keyPath(Entity.score), ascending: true)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        scorelabel!.text = ""
        scorelabel!.numberOfLines = 50
        scorelabel!.preferredMaxLayoutWidth = 500
        do {
            let result = try con.fetch(request)
            for data in result as! [NSManagedObject] {
                //print(data.value(forKey: "score" as! String))
                scorelabel!.text = scorelabel!.text! + "\((data.value(forKey: "name" as! String!))!): \((data.value(forKey: "score" as! String!))!)\n"
            }
        } catch {
            print("Failed")
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
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if touchedNode.name == "back" {
            touchedNode.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            let s = GameScene(fileNamed: "GameScene")
            s?.scaleMode = scaleMode
            let r = SKTransition.fade(withDuration: 1.0)
            view?.presentScene(s!, transition: r)
        }
        
    }}
