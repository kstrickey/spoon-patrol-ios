//
//  GameScene.swift
//  Moon Patrol
//
//  Created by Kevin on 8/7/17.
//  Copyright (c) 2017 Casual Programmer. All rights reserved.
//

import CoreMotion
import SpriteKit
import AVFoundation

var motionManager: CMMotionManager!

var backgroundMusicPlayer: AVAudioPlayer!

func playBackgroundMusic(_ filename: String) {
    let url = Bundle.main.url(forResource: filename, withExtension: nil)
    if (url == nil) {
        print("Could not find file: \(filename)")
        return
    }
    
    var error: NSError? = nil
    do {
        backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url!)
    } catch let error1 as NSError {
        error = error1
        backgroundMusicPlayer = nil
    }
    if backgroundMusicPlayer == nil {
        print("Could not create audio player: \(error!)")
        return
    }
    
    backgroundMusicPlayer.numberOfLoops = -1
    backgroundMusicPlayer.prepareToPlay()
    backgroundMusicPlayer.play()
}


struct PhysicsCategory {
    static let None             : UInt32 = 0
    static let All              : UInt32 = UInt32.max
    static let Patroller        : UInt32 = 0b10000
    static let FriendlyWeapon   : UInt32 = 0b01000
    static let Ground           : UInt32 = 0b00010
    static let DeathlyObstacle  : UInt32 = 0b00001
    static let AnyFriendly      : UInt32 = 0b11000
    static let AnyObstacle      : UInt32 = 0b00011
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var started: Bool = false
    let playingMusic: Bool
    
    let groundHeight: CGFloat = 80
    let groundSize: CGSize
    let ground: SKShapeNode
    let groundColor: UIColor = UIColor.green
    
    let patroller: Patroller
    
    let scoreboard: SKLabelNode
    
    var tiltForce: CGVector
    
    override init(size: CGSize) {
        if !AVAudioSession.sharedInstance().isOtherAudioPlaying {
            playingMusic = true
            playBackgroundMusic("March of the Spoons.mp3")
        } else {
            playingMusic = false
        }
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        groundSize = CGSize(width: size.width, height: groundHeight)
        ground = Ground(rectOf: groundSize)
        ground.fillColor = groundColor
        
        patroller = Patroller()
        
        tiltForce = CGVector(dx: 0, dy: 0)
        
        lastTime = 0.0
        totalTime = 0.0
        
        scoreboard = SKLabelNode(fontNamed: "Chalkduster")
        
        timeOfLastObstacle = minimumTimeBetweenObstacles
        likelihoodOfGroundObstacleSpawn = 0.3
        
        likelihoodOfFlyingPanSpawn = 0.0
        
        super.init(size: size)
        
        self.backgroundColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        if !started {
            start()
        }
    }
    
    func start() {
        // Physics world
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -0.8)
        physicsWorld.contactDelegate = self
        
        // Ground
        ground.position = CGPoint(x: self.size.width / 2, y: groundHeight / 2.0)
        ground.physicsBody = SKPhysicsBody(rectangleOf: groundSize)
        ground.physicsBody!.categoryBitMask = PhysicsCategory.Ground
        ground.physicsBody!.collisionBitMask = PhysicsCategory.AnyFriendly
        ground.physicsBody!.contactTestBitMask = PhysicsCategory.None
        ground.physicsBody!.affectedByGravity = false
        ground.physicsBody!.pinned = true
        ground.physicsBody!.allowsRotation = false
        addChild(ground)
        
        // Scoreboard
        scoreboard.fontSize = 25
        scoreboard.fontColor = UIColor.black
        scoreboard.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreboard.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        scoreboard.position = CGPoint(x: 0, y: 0)
        scoreboard.zPosition = CGFloat.greatestFiniteMagnitude
        addChild(scoreboard)
        
        // Patroller
        patroller.begin(groundHeight: groundHeight)
        addChild(patroller)
        
        started = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        let touch = touches.first!
        let location = touch.location(in: self)
        
        if location.x < self.size.width / 2 {
            patroller.jump()
        } else {
            patroller.attemptShot(currentTime: lastTime)
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Patroller contacted something
        if contact.bodyA.categoryBitMask == PhysicsCategory.Patroller || contact.bodyB.categoryBitMask == PhysicsCategory.Patroller {
            if contact.bodyA.categoryBitMask == PhysicsCategory.Ground || contact.bodyB.categoryBitMask == PhysicsCategory.Ground {
                patroller.jumping = false
            } else if contact.bodyA.categoryBitMask == PhysicsCategory.DeathlyObstacle || contact.bodyB.categoryBitMask == PhysicsCategory.DeathlyObstacle {
                youLose()
            }
        }
            
        // FriendlySpoon contacted something
        else if (contact.bodyA.node is FriendlySpoon && contact.bodyB.node is KTSpriteNode) || (contact.bodyB.node is FriendlySpoon && contact.bodyA.node is KTSpriteNode) {
            if (contact.bodyA.node as! KTSpriteNode).diesBySpoon() || (contact.bodyB.node as! KTSpriteNode).diesBySpoon() {
                // Both die spinning
                (contact.bodyA.node! as! KTSpriteNode).exitWithSpinningParabola()
                (contact.bodyB.node! as! KTSpriteNode).exitWithSpinningParabola()
                self.run(SKAction.playSoundFileNamed("blop.wav", waitForCompletion: false))
            }
        }
        
        // Flying pancake contacted ground
        else if contact.bodyA.node is PancakeBomb && contact.bodyB.node is Ground {
            (contact.bodyA.node as! PancakeBomb).beginMarch()
        } else if contact.bodyB.node is PancakeBomb && contact.bodyA.node is Ground {
            (contact.bodyB.node as! PancakeBomb).beginMarch()
        }
        
    }
    
    
    var totalTime: CFTimeInterval
    var lastTime: CFTimeInterval
    
    var timeOfLastObstacle: CFTimeInterval
    let minimumTimeBetweenObstacles = 1.0
    let maximumTimeBetweenObstacles = 6.0
    
    var likelihoodOfGroundObstacleSpawn: Double     // between 0 and 1, units per second
    
    var likelihoodOfFlyingPanSpawn: Double          // between 0 and 1, units per second (on average)
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        if lastTime == 0.0 {       // first iteration, lastTime has not been set yet
            lastTime = currentTime
            return
        }
        let timeElapsed = currentTime - lastTime
        totalTime += timeElapsed
        
        scoreboard.text = "   Meters patrolled: \(Double(round(10*totalTime)/10))"
        
        // Incorporate tilt
        if let accelerometerData = motionManager.accelerometerData {
            tiltForce.dx = CGFloat(-accelerometerData.acceleration.y * 70.0)
        }
        patroller.run(SKAction.applyForce(tiltForce, duration: timeElapsed))
        
        // Ensure patroller does not run off side
        if patroller.position.x < patroller.size.width {
            patroller.position.x = patroller.size.width
        } else if patroller.position.x > self.size.width - patroller.size.width {
            patroller.position.x = self.size.width - patroller.size.width
        }
        
        // If available, randomly spawn protruding obstacle
        if currentTime - timeOfLastObstacle >= minimumTimeBetweenObstacles {
            let likelihood = likelihoodOfGroundObstacleSpawn * timeElapsed
            if drand48() < likelihood || currentTime - timeOfLastObstacle > maximumTimeBetweenObstacles {
                let groundObstacle: GroundObstacle
                if drand48() < 0.5 {
                    groundObstacle = DivotObstacle()
                } else {
                    groundObstacle = ProtrudingObstacle()
                }
                addChild(groundObstacle)
                groundObstacle.beginMarch()
                timeOfLastObstacle = currentTime
            }
        }
        
        // Randomly spawn flying pan
        let probSpawn = likelihoodOfFlyingPanSpawn * timeElapsed   // prob. of new spawn in this update
        if probSpawn > drand48() {
            let flyingPan = FlyingPan()
            addChild(flyingPan)
            flyingPan.spawn()
        }
        
        if likelihoodOfFlyingPanSpawn <= 0.1 {
            likelihoodOfFlyingPanSpawn += timeElapsed / 300.0
        } else if likelihoodOfFlyingPanSpawn <= 1.0 {
            likelihoodOfFlyingPanSpawn += timeElapsed / 200.0
        }
        
        lastTime = currentTime
        
    }
    
    
    
    func youLose() {
        if playingMusic {
            backgroundMusicPlayer.stop()
        }
        let gameOverScene = GameOverScene(size: self.size)
        self.view!.presentScene(gameOverScene)
    }
    
}

