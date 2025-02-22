//
//  Patroller.swift
//  Moon Patrol
//
//  Created by Kevin on 8/12/17.
//  Copyright © 2017 Casual Programmer. All rights reserved.
//

import Foundation
import SpriteKit


class Patroller: KTSpriteNode {
    
    // Rotating images
    let walkingImageRootName = "teapot"
    let numberOfWalkingImages = 2
    let walkingImagePeriod = 0.2      // seconds to rotate through all images
    
    let numberOfShootingImages = 1
    let shootingCycleLength = 0.1
    let shootTextures: [SKTexture]
    
    // Position
    let baseX: CGFloat
    
    
    let jumpSpeed: CGFloat = 100.0
    var jumping: Bool
    
    let minTimeBetweenForwardShots = 1.0
    var timeOfLastForwardShot: TimeInterval
    let minTimeBetweenUpwardShots = 0.3
    var timeOfLastUpwardShot: TimeInterval
    
    init(baseX: CGFloat = 100) {
        // Shooting images
        var tex = [SKTexture]()
        for i in 0..<numberOfShootingImages {
            tex.append(SKTexture(imageNamed: "teapot boiling \(i)"))
        }
        shootTextures = tex
        
        // Size and position
        self.baseX = baseX
        let size = CGSize(width: 100, height: 100)
        
        jumping = false
        
        timeOfLastForwardShot = 0.0
        timeOfLastUpwardShot = 0.0
        
        super.init(texture: shootTextures[0], color: UIColor(), size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* Called after init, when gameplay starts. Initializes position etc. */
    func begin(groundHeight: CGFloat) {
        self.zPosition = 1000
        self.position = CGPoint(x: baseX, y: groundHeight + self.size.height / 2 + 1)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width/2, height: self.size.height*3/5), center: CGPoint(x: -self.size.width/8, y: 0.0))
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.categoryBitMask = PhysicsCategory.Patroller
        self.physicsBody!.collisionBitMask = PhysicsCategory.AnyObstacle
        self.physicsBody!.contactTestBitMask = PhysicsCategory.AnyObstacle
        
        // Start walking animation
        self.animateForever(baseImageRootName: walkingImageRootName, numberOfBaseImages: numberOfWalkingImages, baseImagePeriod: walkingImagePeriod)
    }
    
    func attemptShot(currentTime: TimeInterval) {
        if currentTime - timeOfLastUpwardShot >= minTimeBetweenUpwardShots {
            self.run(SKAction.animate(with: shootTextures, timePerFrame: shootingCycleLength / Double(shootTextures.count)))
            
            // Shoot spoon
            let upSpoon = FriendlyUtensil(facingUp: true)
            self.parent!.addChild(upSpoon)
            upSpoon.fire(patrollerPosition: self.position, patrollerSize: self.size)
            timeOfLastUpwardShot = currentTime
            
            if currentTime - timeOfLastForwardShot >= minTimeBetweenForwardShots {
                let rightSpoon = FriendlyUtensil(facingUp: false)
                self.parent!.addChild(rightSpoon)
                rightSpoon.fire(patrollerPosition: self.position, patrollerSize: self.size)
                timeOfLastForwardShot = currentTime
            }
            
            // Sound effect
            self.run(SKAction.playSoundFileNamed("pop cork.wav", waitForCompletion: false))
        }
    }
    
    
    func jump() {
        if !jumping {
            jumping = true
            self.physicsBody!.velocity.dy = jumpSpeed
        }
    }
    
    
    
}
