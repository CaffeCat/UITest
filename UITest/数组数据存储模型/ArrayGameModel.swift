//
//  ArrayGameModel.swift
//  UITest
//
//  Created by caffe on 2019/7/31.
//  Copyright © 2019 caffe. All rights reserved.
//

import Foundation

class GameModel {
    
    var dimension = 0
    var tiles:Array<Int>
    
    init(dimension: Int) {
        
        self.dimension = dimension
        self.tiles = Array<Int>.init(repeating: 0, count: self.dimension * self.dimension)
    }
    
    //找出空位置
    func emptyPositions() -> [Int] {
        
        var emptyTiles = Array<Int>()
        for index in 0 ..< (dimension * dimension) {
            if tiles[index] == 0 {
                emptyTiles.append(index)
            }
        }
        return emptyTiles
    }
    
    //位置是否已满
    func isFull() -> Bool {
        if emptyPositions().count == 0 {
            return true
        }
        return false
    }
    
    //输出当前数据模型
    func printTiles() {
        print(tiles)
        print("输出当前数据模型")
        let count = tiles.count
        for index in 0 ..< count {
            if (index + 1) % dimension == 0 {
                print(tiles[index])
            }else {
                print("\(tiles[index])\t")
            }
        }
        print("")
    }
    
    //设置某个位置的值
    func setPosition(row: Int, col: Int, value: Int) -> Bool{
        assert(row >= 0 && row < dimension)
        assert(col >= 0 && col < dimension)
        
        //取得定位index: 3行4列 index = 2*4 + 3 = 11
        let index = dimension * row + col
        let val = tiles[index]
        if val > 0 {
            print("该位置(\(row), \(col))已经有值了")
            return false
        }
        tiles[index] = value
        return true
    }
}

class GameModelBA {
    var dimension = 0
    var tiles:[[Int]]
    
    init(dimension: Int) {
        self.dimension = dimension
        self.tiles = Array.init(repeating: Array.init(repeating: 0, count: self.dimension),
                                count: self.dimension)
    }
    
    //找出空位置
    func emptyPositions() -> [Int] {
        var emptyTiles = Array<Int>()
        //var index: Int
        for row in 0 ..< self.dimension {
            for col in 0 ..< self.dimension {
                if tiles[row][col] == 0 {
                    emptyTiles.append(tiles[row][col])
                }
            }
        }
        return emptyTiles
    }
    
    //设置值
    func setPosition(row: Int, col: Int, value: Int) -> Bool {
        
        assert(row >= 0 && row < dimension)
        assert(col >= 0 && col < dimension)
        
        let val = self.tiles[row][col]
        if val > 0 {
            print("该位置(\(row), \(col))已经有值了")
            return false
        }
        printTiles()
        
        //tiles[row][col] = value
        var rdata = Array.init(repeating: 0, count: self.dimension)
        for index in 0 ..< self.dimension {
            rdata[index] = tiles[row][index]
        }
        rdata[col] = value
        tiles[row] = rdata
        return true
    }
    
    //输出数据的当前模型
    func printTiles() {
        print(tiles)
        print("输出模型数据内容")
        for row in 0 ..< self.dimension {
            for col in 0 ..< self.dimension {
                print("\(tiles[row][col])\t")
            }
            print("")
        }
        print("")
    }
    
    //位置是否已经满了
    func isFull() -> Bool {
        if emptyPositions().count == 0 {
            return true
        }
        return false
    }
}

// MARK: - 自定义矩阵数据结构
struct Martix {
    
    let rows: Int, columns: Int
    var grid: [Int]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array.init(repeating: 0, count: rows * columns)
    }
    
    //越界检查
    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    //下标
    subscript(row: Int, column: Int) -> Int {
        get{
            assert(indexIsValidForRow(row: row, column: column), "数据越界")
            return grid[row*columns + column]
        }
        set (newValue) {
            assert(indexIsValidForRow(row: row, column: column), "数据越界")
            grid[row*columns + column] = newValue
        }
    }
}

class GameModelMatrix {
    var dimension = 0
    var tiles: Martix
    
    init(dimension: Int) {
        self.dimension = dimension
        self.tiles = Martix.init(rows: dimension, columns: dimension)
    }
    
    //找出空位置
    func emptyPosition() -> [Int] {
        var emptyTiles = Array<Int>()
        // var index: Int
        for row in 0 ..< self.dimension {
            for col in 0 ..< self.dimension {
                let value = tiles[row, col]
                if value == 0 {
                    emptyTiles.append(self.tiles[row, col])
                }
            }
        }
        return emptyTiles
    }
    
    //设置值
    func setPosition(row: Int, col: Int, value: Int) -> Bool {
        assert(row >= 0 && row < self.dimension)
        assert(col >= 0 && col < self.dimension)
        
        let val = tiles[row, col]
        if val > 0 {
            print("该位置(\(row), \(col))已经有值了")
            return false
        }
        printTiles()
        tiles[row, col] = value
        printTiles()
        return true
    }
    
    //输出当前数据模型
    func printTiles() {
        print(tiles)
        print("输出数据模型内容")
        for row in 0 ..< self.dimension {
            for col in 0 ..< self.dimension {
                print("\(tiles[row, col])\t")
            }
            print("")
        }
        print("")
    }
    
    //位置是否已满
    func isFull() -> Bool {
        if emptyPosition().count == 0 {
            return true
        }
        return false
    }
}
