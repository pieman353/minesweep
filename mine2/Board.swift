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
    var bombs: [[Int]]
    
    init(boardSize: Int) {
        size = boardSize
        board = Array(repeating: Array(repeating: "*", count: size), count: size)
        bombs = [[Int]]()
        addBombs()
        printBombs()
    }
    
    func printBoard() {
        for row in board {
            for elem in row {
                print("\(elem)", terminator:"")
            }
            print("")
        }
    }
    
    func printBombs() {
        for arr in bombs {
            print("\(arr)")
        }
    }
    
    func addBombs() {
        for _ in 1...(size+1) {
            var rand1 = Int.random(in: 0..<size)
            var rand2 = Int.random(in: 0..<size)
            while (bombs.contains([rand1, rand2])) {
                rand1 = Int.random(in: 0..<size)
                rand2 = Int.random(in: 0..<size)
            }
            bombs.append([rand1, rand2])
        }
    }
    
    func isBomb(x: Int, y: Int) -> Bool {
        return bombs.contains([x, y])
    }
    
}
