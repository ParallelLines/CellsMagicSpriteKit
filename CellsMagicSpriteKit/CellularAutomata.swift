//
//  CellularAutomata.swift
//  CellsMagicSpriteKit
//
//  Created by Tatyana Khabirova on 21/08/2018.
//  Copyright © 2018 Tatyana Khabirova. All rights reserved.
//

import Cocoa
import SpriteKit

class CellularAutomata: SKSpriteNode {
    
    var cells: [[AutomatonCell]]!
    let gridWidth = 35
    let gridHeight = 35
    let margin: CGFloat = 5
    let defaultColor = NSColor(red: 1, green: 0.6, blue: 0.8, alpha: 1)
    let cellSize: CGFloat = 15
    
    func createGrid() {
        cells = createCellArray()
        position = CGPoint(x: 50, y: 50)
    }
    
    func position(for cell: AutomatonCell) -> CGPoint {
        let x = (cellSize + margin/2) * CGFloat(cell.col)
        let y = (cellSize + margin/2) * CGFloat(cell.row)
        return CGPoint(x: x, y: y)
    }
    
    func createCellArray() -> [[AutomatonCell]] {
        var rows = [[AutomatonCell]]()
        for i in 0 ..< gridHeight {
            var row = [AutomatonCell]()
            for j in 0 ..< gridWidth {
                let cell = AutomatonCell(color: defaultColor, size: CGSize(width: cellSize, height: cellSize))
                cell.col = j
                cell.row = i
                cell.position = position(for: cell)
                row.append(cell)
                addChild(cell)
            }
            rows.append(row)
        }
        return rows
    }
    
    func colorWave(from cell: AutomatonCell) {
        //color the clicked cell
        let cell = cells[cell.row][cell.col]
        var newColor = generateNewColor(previousColor: cell.color)
        cell.run(changeColor(for: cell, newColor: newColor, delayFactor: 0))
        
        let maxRadius = findMaxDistance(from: cell) + 1
        newColor = generateNewColor(previousColor: newColor)

        for i in 1 ..< Int(maxRadius) {
            colorRing(around: cell, radius: Double(i), color: newColor)
            newColor = generateNewColor(previousColor: newColor)
        }
        
        calm()
    }
    
    func colorRing(around centerCell: AutomatonCell, radius: Double, color: NSColor) {
        var actions = [AutomatonCell: SKAction]()
        for row in cells {
            for cell in row {
                if !cell.colorChanged {
                    let distance = cell.calculateDistance(to: centerCell)
                    if distance >= radius && distance < radius + 1 {
                        actions[cell] = changeColor(for: cell, newColor: color, delayFactor: distance)
                    }
                }
            }
        }
        
        for (cell, action) in actions {
            cell.run(action)
        }
    }
    
    func changeColor(for cell: AutomatonCell, newColor: NSColor, delayFactor: Double) -> SKAction {
        let delay = SKAction.wait(forDuration: TimeInterval(delayFactor) * 0.1)
        let coloration = SKAction.colorize(with: newColor, colorBlendFactor: 1.0, duration: 0.07)
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.07)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.05)
        let scale = SKAction.sequence([scaleUp, scaleDown])
        let colorAndScale = SKAction.group([coloration, scale])
        let allActions = SKAction.sequence([delay, colorAndScale])
        cell.colorChanged = true
        return allActions
    }
    
    func generateNewColor(previousColor: NSColor) -> NSColor {
        let delta: CGFloat = 0.1
        var channels = [previousColor.redComponent, previousColor.greenComponent, previousColor.blueComponent]
        let randomNum = Int(arc4random_uniform(3))
        let randomSign = Int(arc4random_uniform(2))
        
        //1 - color should be in between 0.3 and 1
        //2 - should change randomly by +delta or -delta
        switch channels[randomNum] {
        case 0...0.1:
            channels[randomNum] = channels[randomNum] + delta
        case 0.9...1:
            channels[randomNum] = channels[randomNum] - delta
        default:
            if randomSign == 0 {
                channels[randomNum] = channels[randomNum] - delta
            } else {
                channels[randomNum] = channels[randomNum] + delta
            }
        }
        return NSColor(red: channels[0], green: channels[1], blue: channels[2], alpha: 1)
    }
    
    func findMaxDistance(from cell: AutomatonCell) -> Double {
        let dist1 = cell.calculateDistance(to: cells[0][0])
        let dist2 = cell.calculateDistance(to: cells[gridWidth - 1][0])
        let dist3 = cell.calculateDistance(to: cells[0][gridHeight - 1])
        let dist4 = cell.calculateDistance(to: cells[gridWidth - 1][gridHeight - 1])
        
        return max(dist1, dist2, dist3, dist4)
    }
    
    func calm() {
        for row in cells {
            for cell in row {
                cell.colorChanged = false
            }
        }
    }
    
}

class AutomatonCell: SKSpriteNode {
    var row: Int = 0
    var col: Int = 0
    var colorChanged = false
    
    func calculateDistance(to anotherCell: AutomatonCell) -> Double {
        return sqrt(pow(Double(self.col - anotherCell.col), 2) + pow(Double(self.row - anotherCell.row), 2))
    }
    
    func addGlow(radius: Float = 30) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius":radius])
    }
}
