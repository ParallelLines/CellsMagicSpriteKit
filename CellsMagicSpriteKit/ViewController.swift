//
//  ViewController.swift
//  CellsMagicSpriteKit
//
//  Created by Tatyana Khabirova on 20/08/2018.
//  Copyright © 2018 Tatyana Khabirova. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                scene.size.height = CGFloat(695)
                scene.size.width = CGFloat(695)
                // Present the scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
}

