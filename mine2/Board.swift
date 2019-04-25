//
//  Board.swift
//  mine2
//
//  Created by Adam Piekarski on 4/24/19.
//  Copyright © 2019 Adam Piekarski. All rights reserved.
//

import Foundation

class Board {
    var size: Int
    var board: [[Character]]
    
    init(boardSize: Int) {
        size = boardSize
        board = Array(repeating: Array(repeating: "*", count: size), count: size)
    }
    
    func printBoard() {
        for row in board {
            for elem in row {
                print("\(elem)", terminator:"")
            }
            print("")
        }
    }
    
    
}
