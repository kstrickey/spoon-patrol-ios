//
//  PancakeBomb.swift
//  Spoon Patrol
//
//  Created by Kevin Trickey on 6/19/19.
//  Copyright © 2019 Kevin Trickey. All rights reserved.
//

import Foundation
import SpriteKit

class PancakeBomb: GroundObstacle {
    
    let projectileRootName = "pancake"
    let projectileNumberOfTextures = 1
    let projectileTexturePeriod = 1.0
    
    let groundRootName = "ground pancake"
    let groundNumberOfTextures = 1
    let groundTexturePeriod = 1.0
    
    var isStillProjectile = true            // becomes false when hits ground
    
    init() {
        super.init(size: CGSize(width: 50, height: 15))
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.affectedByGravity = true
        self.physicsBody!.allowsRotation = true
        self.physicsBody!.categoryBitMask = PhysicsCategory.DeathlyObstacle
        self.physicsBody!.collisionBitMask = PhysicsCategory.AnyFriendly
        self.physicsBody!.contactTestBitMask = PhysicsCategory.AnyFriendly | PhysicsCategory.Ground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spawnAt(position: CGPoint) {
        // Executes a spinning parabola until it hits the ground, at which point it becomes a GroundObstacle.
        self.position = position
        self.animateForever(baseImageRootName: projectileRootName, numberOfBaseImages: projectileNumberOfTextures, baseImagePeriod: projectileTexturePeriod)
        self.physicsBody!.mass = 8000
        self.physicsBody!.angularVelocity = CGFloat((-0.5 + drand48()) * 10.0)
        self.physicsBody!.velocity = CGVector(dx: (-0.5 + drand48()) * 300.0, dy: (0.5 + drand48()) * 200.0)
        let gravityAction = SKAction.applyForce(CGVector(dx: 0, dy: -1000.0 * self.physicsBody!.mass), duration: 5)
        
        self.run(gravityAction)
        // When the GameScene detects collision with ground, will call beginMarch.
    }
    
    override func beginMarch() {
        // Converts to a ground pancake and begins march from current location
        
        isStillProjectile = false
        self.removeAllActions()
        self.size = CGSize(width: 50, height: 50)
        self.zRotation = 0.0
        self.position.y = (self.scene! as! GameScene).groundHeight
        // Convert to a regular GroundObstacle (code from GroundObstacle.init)
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.categoryBitMask = PhysicsCategory.DeathlyObstacle
        self.physicsBody!.collisionBitMask = PhysicsCategory.None
        
        self.position = CGPoint(x: self.position.x, y: (self.scene! as! GameScene).groundHeight + self.size.height / 4)
        self.animateForever(baseImageRootName: groundRootName, numberOfBaseImages: groundNumberOfTextures, baseImagePeriod: groundTexturePeriod)
        let obstacleAction = SKAction.moveTo(x: -self.size.width, duration: Double((self.position.x + self.size.width) / self.groundSpeed))
        self.run(SKAction.sequence([obstacleAction, SKAction.removeFromParent()]))
    }
    
    override func diesBySpoon() -> Bool {
        return true
    }
    
}
