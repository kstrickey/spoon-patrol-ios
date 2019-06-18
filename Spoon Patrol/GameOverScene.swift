//
//  GameOverScene.swift
//  Moon Patrol
//
//  Created by Kevin on 9/1/17.
//  Copyright © 2017 Casual Programmer. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        let label = SKLabelNode(text: "You lose")
        label.position = CGPoint(x: 100, y: 100)
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view!.presentScene(TitleScene(size: self.size))
    }
    
}

