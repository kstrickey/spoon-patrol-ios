//
//  GroundObstacle.swift
//  Moon Patrol
//
//  Created by Kevin on 8/12/17.
//  Copyright © 2017 Casual Programmer. All rights reserved.
//

import Foundation
import SpriteKit


class GroundObstacle: KTSpriteNode {
    
    let groundSpeed = CGFloat(200.0)
    
    init(size: CGSize) {
        super.init(texture: .none, color: UIColor(), size: size)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.categoryBitMask = PhysicsCategory.DeathlyObstacle
        self.physicsBody!.collisionBitMask = PhysicsCategory.None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginMarch() {
        preconditionFailure("This method must be overridden")
    }
    
}
