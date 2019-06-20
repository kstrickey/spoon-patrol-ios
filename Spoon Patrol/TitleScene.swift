//
//  TitleScene.swift
//  Moon Patrol
//
//  Created by Kevin on 8/8/17.
//  Copyright © 2017 Casual Programmer. All rights reserved.
//

import Foundation
import SpriteKit

class TitleScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        let title = SKLabelNode(fontNamed: "Chalkduster")
        title.text = "SPOON PATROL"
        title.fontSize = 50
        title.fontColor = SKColor.white
        title.position = CGPoint(x: size.width / 2, y: size.height / 3 * 2)
        addChild(title)
        
        let patroller = Patroller(baseX: size.width / 2)
        self.addChild(patroller)
        patroller.begin(groundHeight: size.height / 4)
        patroller.physicsBody!.isDynamic = false
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        start()
    }
    
    func start() {
        self.view!.presentScene(GameScene(size: self.size))
    }
    
    
}

