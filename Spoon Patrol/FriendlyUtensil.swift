//
//  FriendlySpoon.swift
//  Moon Patrol
//
//  Created by Kevin on 8/12/17.
//  Copyright © 2017 Casual Programmer. All rights reserved.
//

import Foundation
import SpriteKit

class FriendlyUtensil: KTSpriteNode {
    
    let facingUp: Bool
    
    let utensilSpeed = 300.0       // points per second
    
    init(facingUp: Bool) {
        self.facingUp = facingUp
        var name: String
        let rand = Int.random(in: 0 ..< 3)
        if rand == 0 {
            name = "utensil A"
        } else if rand == 1 {
            name = "utensil B"
        } else {
            name = "utensil C"
        }
        super.init(texture: SKTexture(imageNamed: name), color: UIColor(), size: CGSize(width: 50, height: 10))
        
        self.size = CGSize(width: 50, height: 10)
        self.zPosition = 500
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        if facingUp {
            self.physicsBody!.affectedByGravity = false
        }
        self.physicsBody!.categoryBitMask = PhysicsCategory.FriendlyWeapon
        self.physicsBody!.collisionBitMask = PhysicsCategory.Ground
        self.physicsBody!.contactTestBitMask = PhysicsCategory.DeathlyObstacle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fire(patrollerPosition: CGPoint, patrollerSize: CGSize) {
        if facingUp {
            self.zRotation = CGFloat(Double.pi / 2)
            self.position = CGPoint(x: patrollerPosition.x, y: patrollerPosition.y)
            let dist = self.scene!.size.height - self.position.y + self.size.height
            self.run(SKAction.sequence([SKAction.moveTo(y: self.position.y + dist, duration: Double(dist) / utensilSpeed), SKAction.removeFromParent()]))
        } else {
            self.position = CGPoint(x: patrollerPosition.x, y: patrollerPosition.y + patrollerSize.height / 3)
            self.physicsBody!.velocity = CGVector(dx: 0, dy: 10)
            let dist = self.scene!.size.width - self.position.x + self.size.width
            self.run(SKAction.sequence([SKAction.group([SKAction.applyForce(CGVector(dx: 0, dy: -15), duration: Double(dist) / utensilSpeed), SKAction.moveTo(x: self.position.x + dist, duration: Double(dist) / utensilSpeed)]), SKAction.removeFromParent()]))
        }
    }
    
}
