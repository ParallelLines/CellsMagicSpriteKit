//
//  GameScene.swift
//  CellsMagicSpriteKit
//
//  Created by Tatyana Khabirova on 20/08/2018.
//  Copyright © 2018 Tatyana Khabirova. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var automata: CellularAutomata!
    
    override func didMove(to view: SKView) {
        automata = CellularAutomata()
        automata.createGrid()
        addChild(automata)
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let clickedNodes = nodes(at: location).filter { $0 is AutomatonCell }
        guard clickedNodes.count != 0 else { return }
        for node in clickedNodes {
            automata.colorWave(from: node as! AutomatonCell)
        }
    }
}
