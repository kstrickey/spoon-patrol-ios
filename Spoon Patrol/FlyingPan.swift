//
//  UFO.swift
//  Moon Patrol
//
//  Created by Kevin on 9/11/17.
//  Copyright © 2017 Casual Programmer. All rights reserved.
//

import Foundation
import SpriteKit

class FlyingPan: KTSpriteNode {
    
    let rootName = "flying pan"
    let numberOfTextures = 1
    let texturePeriod = 1.0
    
    var shootingAnimationTextures: [SKTexture]      // set the number, etc. in init
    let shootingAnimationPeriod = 0.7
    
    init() {
        shootingAnimationTextures = [SKTexture]()
        for i in 0..<1 {
            shootingAnimationTextures.append(SKTexture(imageNamed: "flying pan shooting \(i)"))
        }
        
        super.init(texture: .none, color: UIColor(), size: CGSize(width: 100, height: 20))
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.categoryBitMask = PhysicsCategory.DeathlyObstacle
        self.physicsBody!.collisionBitMask = PhysicsCategory.AnyFriendly
        self.physicsBody!.contactTestBitMask = PhysicsCategory.AnyFriendly
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spawn(spawnPoint: Optional<CGPoint> = nil) {
        
        if spawnPoint == nil {
            // Randomly spawn from either the top or one of the sides
            if drand48() < 0.333 {
                // Spawn from top
                self.position = CGPoint(x: CGFloat(drand48()) * self.scene!.size.width, y: self.scene!.size.height + self.size.height)
            } else {
                let groundHeight: Double = Double((self.scene! as! GameScene).groundHeight)
                let spawnHeight: Double = groundHeight + (Double(self.scene!.size.height) - groundHeight) / 2.0 * (1.0 + drand48())
                if drand48() < 0.5 {
                    // Spawn from left
                    self.position = CGPoint(x: Double(-self.size.width), y: spawnHeight)
                } else {
                    // Spawn from right
                    self.position = CGPoint(x: Double(self.scene!.size.width + self.size.width), y: spawnHeight)
                }
            }
        }
        
        self.animateForever(baseImageRootName: rootName, numberOfBaseImages: numberOfTextures, baseImagePeriod: texturePeriod)
        
        // Set the forces for the Flying Pan's flight pattern
        let devx = (self.scene!.size.width * CGFloat(3.0/4.0) - self.size.width * CGFloat(2.0)) * CGFloat(drand48())
        let devy = self.scene!.size.height / CGFloat(4.0) * CGFloat(drand48())
        // Home base is where the flying pan will generally center around, with strong forces always pushing it back toward its home base after deviations
        let homeBase = CGPoint(x: CGFloat(2.0) * self.size.width + devx, y: self.scene!.size.height / CGFloat(2.0) + devy)
        
        var actionSequence = [SKAction]()
        actionSequence.append(SKAction.move(to: homeBase, duration: 3.0))
        for _ in 0...5 {
            let v = CGVector(dx: 40.0 * drand48() - 20.0, dy: 10.0 * drand48() - 5.0)
            actionSequence.append(SKAction.applyForce(v, duration: 1.0))
        }
        
        self.run(SKAction.repeatForever(SKAction.sequence(actionSequence)))
        
        // Preset the firing of pancakes
        var firingSequence = [SKAction]()
        for _ in 0...10 {
            firingSequence.append(SKAction.wait(forDuration: 1.0 + 7.0 * drand48()))
            firingSequence.append(SKAction.run(firePancake))
        }
        self.run(SKAction.repeatForever(SKAction.sequence(firingSequence)))
    }
    
    func firePancake() {
        // Fires a pancake, if positioned appropriately
        if self.position.x < self.scene!.size.width && self.position.x > self.size.width && self.position.y > (self.scene! as! GameScene).groundHeight + self.size.height * 2 && self.position.y < self.scene!.size.height {
            let pcb = PancakeBomb()
            self.scene!.addChild(pcb)
            pcb.spawnAt(position: self.position)
            
            // Animate pan in throwing motion
            self.run(SKAction.animate(with: shootingAnimationTextures, timePerFrame: shootingAnimationPeriod))
            
            // Sound effect
            self.run(SKAction.playSoundFileNamed("arrow.wav", waitForCompletion: false))
        }
    }
    
    override func diesBySpoon() -> Bool {
        return true
    }
    
}

