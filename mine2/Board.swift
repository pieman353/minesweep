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
    var adjacentBombs: [[Int]]
    var bombs: [[Int]]
    
    init(boardSize: Int) {
        size = boardSize
        board = Array(repeating: Array(repeating: "*", count: size), count: size)
        bombs = [[Int]]()
        adjacentBombs = Array(repeating: Array(repeating: 0, count: size), count: size)
        addBombs()
        adjacentBombsGen()
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
    
    func printAdjacentBombs() {
        for row in adjacentBombs {
            for elem in row {
                print("\(elem) ", terminator:"")
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
    
    func isValidBomb(x: Int, y: Int) -> Int {
        if x >= 0 && x < size && y >= 0 && y < size && bombs.contains([x, y]) {
            return 1
        }
        else {
            return 0
        }
    }
    
    func adjacentBombsGen() {
        for i in 0..<size {
            for j in 0..<size {
                if !isBomb(x: i, y: j) {
                    var numBombs = 0
                    numBombs = numBombs + isValidBomb(x: i - 1, y: j - 1)
                    numBombs = numBombs + isValidBomb(x: i - 1, y: j)
                    numBombs = numBombs + isValidBomb(x: i - 1, y: j + 1)
                    
                    numBombs = numBombs + isValidBomb(x: i + 1, y: j - 1)
                    numBombs = numBombs + isValidBomb(x: i + 1, y: j)
                    numBombs = numBombs + isValidBomb(x: i + 1, y: j + 1)
                    
                    numBombs = numBombs + isValidBomb(x: i, y: j - 1)
                    numBombs = numBombs + isValidBomb(x: i, y: j + 1)
                    
                    adjacentBombs[i][j] = numBombs
                }
                else {
                    adjacentBombs[i][j] = 9
                }
            }
        }
    }
    
    func isCovered(x: Int, y: Int) -> Bool {
        return board[x][y] == "*"
    }
}
