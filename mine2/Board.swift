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
    var revealed: [[Int]]
    var firstX: Int
    var firstY: Int
    
    init(boardSize: Int, x: Int, y: Int) {
        size = boardSize
        firstX = x
        firstY = y
        board = Array(repeating: Array(repeating: "*", count: size), count: size)
        bombs = [[Int]]()
        adjacentBombs = Array(repeating: Array(repeating: 0, count: size), count: size)
        revealed = Array(repeating: Array(repeating: 0, count: size), count: size)
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
        for _ in 0...(size+1) {
            var rand1 = Int.random(in: 0..<size)
            var rand2 = Int.random(in: 0..<size)
            while (bombs.contains([rand1, rand2]) && (rand1 == firstX && rand2 == firstY)) {
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
                    adjacentBombs[i][j] = numAdjacentBombs(i: i, j: j)
                }
                else {
                    adjacentBombs[i][j] = 9
                }
            }
        }
    }
    
    func numAdjacentBombs(i: Int, j: Int) -> Int {
        var numBombs = 0
        numBombs = numBombs + isValidBomb(x: i - 1, y: j - 1)
        numBombs = numBombs + isValidBomb(x: i - 1, y: j)
        numBombs = numBombs + isValidBomb(x: i - 1, y: j + 1)
        
        numBombs = numBombs + isValidBomb(x: i + 1, y: j - 1)
        numBombs = numBombs + isValidBomb(x: i + 1, y: j)
        numBombs = numBombs + isValidBomb(x: i + 1, y: j + 1)
        
        numBombs = numBombs + isValidBomb(x: i, y: j - 1)
        numBombs = numBombs + isValidBomb(x: i, y: j + 1)
        
        return numBombs
    }
    
    func isCovered(x: Int, y: Int) -> Bool {
        return board[x][y] == "x"
    }
    
    func touch(x: Int, y: Int) -> Int {
        self.printBoard()
        board[x][y] = "y"
        if isBomb(x: x, y: y) {
            self.printBoard()
            return checkWin()
        }
        else {
            reveal(x: x, y: y)
            self.printBoard()
            return checkWin()
        }
    }
    
    func checkWin() -> Int {
        for i in 0..<size {
            for j in 0..<size {
                if board[i][j] == "*" {
                    if !bombs.contains([i, j]) {
                        return -1
                    }
                }
            }
        }
        /*if numAst == bombs.count {
            return 1
        }
        return -1 */
        return 1
    }
    
    func reveal(x: Int, y: Int) {
        revealCell(x: x - 1, y: y - 1)
        revealCell(x: x - 1, y: y)
        revealCell(x: x - 1, y: y + 1)
        
        revealCell(x: x + 1, y: y - 1)
        revealCell(x: x + 1, y: y)
        revealCell(x: x + 1, y: y + 1)
        
        revealCell(x: x, y: y - 1)
        revealCell(x: x, y: y + 1)
    }
    
    func revealCell(x: Int, y: Int) {
        if !(x >= 0 && x < size && y >= 0 && y < size) {
            return
        }
        if revealed[x][y] == 1 {
            return
        }
        if !isBomb(x: x, y: y) && adjacentBombs[x][y] == 0 {
            revealed[x][y] = 1
            board[x][y] = "y"
            reveal(x: x, y: y)
        }
        else {
            revealed[x][y] = 1
            if !isBomb(x: x, y: y) {
                board[x][y] = "x"
            }
        }
    }
}
