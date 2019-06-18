//
//  UFO.swift
//  Moon Patrol
//
//  Created by Kevin on 9/11/17.
//  Copyright © 2017 Casual Programmer. All rights reserved.
//

import Foundation
import SpriteKit

class UFO: KTSpriteNode {
    
    
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.categoryBitMask = PhysicsCategory.DeathlyObstacle
        self.physicsBody!.collisionBitMask = PhysicsCategory.AnyFriendly
        self.physicsBody!.contactTestBitMask = PhysicsCategory.AnyFriendly
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
