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
    
    override func didMove(to view: SKView) {
        let camera = SKCameraNode(fileNamed: "cam")
    }
    
    @objc func handlePinch(pinchGesture: UIPinchGestureRecognizer) {
        if pinchGesture.state == .began || pinchGesture.state == .changed {
            
            let currentScale: CGFloat = (camera!.xScale)
            let minScale: CGFloat = 0.5
            let maxScale: CGFloat = 2.0
            let zoomSpeed: CGFloat = 0.5
            var deltaScale = pinchGesture.scale
            
            deltaScale = ((deltaScale - 1) * zoomSpeed) + 1
            deltaScale = min(deltaScale, maxScale / currentScale)
            deltaScale = max(deltaScale, minScale / currentScale)
            
            camera?.xScale = deltaScale
            camera?.yScale = deltaScale
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
