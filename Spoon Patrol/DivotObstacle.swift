//
//  DivotObstacle.swift
//  Moon Patrol
//
//  Created by Kevin on 9/10/17.
//  Copyright © 2017 Casual Programmer. All rights reserved.
//

import Foundation
import SpriteKit


class DivotObstacle: GroundObstacle {
    
    let rootFlameTextureName = "cauldron"
    let numberOfFlameTextures = 2
    let flamePeriod = 0.7
    
    init() {
        super.init(size: CGSize(width: 75, height: 75))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func beginMarch() {
        self.position = CGPoint(x: self.scene!.size.width + self.size.width / 2, y: (self.scene! as! GameScene).groundHeight - self.size.height / 4)
        self.animateForever(baseImageRootName: rootFlameTextureName, numberOfBaseImages: numberOfFlameTextures, baseImagePeriod: flamePeriod)
        let obstacleAction = SKAction.moveTo(x: -self.size.width, duration: Double((self.scene!.size.width + self.size.width * 3 / 2) / self.groundSpeed))
        self.run(SKAction.sequence([obstacleAction, SKAction.removeFromParent()]))
    }
    
}
