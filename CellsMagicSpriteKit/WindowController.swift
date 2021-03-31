//
//  WindowController.swift
//  CellsMagicSpriteKit
//
//  Created by Tatyana Khabirova on 21/08/2018.
//  Copyright © 2018 Tatyana Khabirova. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        window?.styleMask = [window!.styleMask, .fullSizeContentView]
//        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
        window?.isMovableByWindowBackground = true
    }

}
