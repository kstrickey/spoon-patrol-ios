//
//  KTSpriteNode.swift
//  Moon Patrol
//
//  Created by Kevin on 9/4/17.
//  Copyright © 2017 Casual Programmer. All rights reserved.
//

import Foundation
import SpriteKit


class KTSpriteNode: SKSpriteNode {
    
    func animateForever(baseImageRootName: String, numberOfBaseImages: Int, baseImagePeriod: Double = 1.0) {
        /* Runs action forever to animate this node. */
        var textures = [SKTexture]()
        for i in 0..<numberOfBaseImages {
            textures.append(SKTexture(imageNamed: baseImageRootName + " \(i)"))
        }
        self.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: baseImagePeriod / Double(numberOfBaseImages))))
    }
    
    func exitWithSpinningParabola(exitImageRootName: String? = nil, numberOfExitImages: Int? = nil, exitImagePeriod: Double = 1.0) {
        /* Edits sprite such that it cannot interact with anything and spins it down off the screen in a nice parabola.
         If exitImageRootName is not nil, will change texture to the asset with this name. If exitImageMaxNumber is also not nil, will change to animation of the textures with that root name. */
        
        // No more interaction
        self.physicsBody!.categoryBitMask = PhysicsCategory.None
        self.physicsBody!.collisionBitMask = PhysicsCategory.None
        self.physicsBody!.contactTestBitMask = PhysicsCategory.None
        
        // Change textures if applicable
        if exitImageRootName != nil {
            if numberOfExitImages == nil {
                self.texture = SKTexture(imageNamed: exitImageRootName!)
            } else {
                self.animateForever(baseImageRootName: exitImageRootName!, numberOfBaseImages: numberOfExitImages!, baseImagePeriod: exitImagePeriod)
            }
        }
        
        // Actions
        self.zPosition = CGFloat.greatestFiniteMagnitude
        self.physicsBody!.mass = 10000
        self.physicsBody!.angularVelocity = CGFloat((-0.5 + drand48()) * 10.0)
        self.physicsBody!.velocity = CGVector(dx: (-0.5 + drand48()) * 300.0, dy: (0.5 + drand48()) * 200.0)
        let gravityAction = SKAction.applyForce(CGVector(dx: 0, dy: -1000.0 * self.physicsBody!.mass), duration: 5)
        let removeAction = SKAction.removeFromParent()
        self.run(SKAction.sequence([gravityAction, removeAction]))
    }
    
    func diesBySpoon() -> Bool {
        // Override function. Must return a Bool indicating whether it dies upon contact with FriendlySpoon.
        return false
    }
    
}
