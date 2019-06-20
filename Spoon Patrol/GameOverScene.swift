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
    
    var playingMusic: Bool
    
    init(size: CGSize, score: Double, playingMusic: Bool) {
        self.playingMusic = playingMusic
        
        super.init(size: size)
        
        let youLose = SKLabelNode(text: "You lose!")
        youLose.fontName = "Chalkduster"
        youLose.fontSize = 20
        youLose.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        youLose.position = CGPoint(x: size.width/2, y: size.height - 20)
        self.addChild(youLose)
        
        let credits = SKSpriteNode(imageNamed: "credits slide")
        credits.setScale(size.width*2/3 / credits.size.width)
        credits.anchorPoint = CGPoint(x: 0.5, y: 0)
        credits.position = CGPoint(x: size.width/2, y: 0)
        self.addChild(credits)
        
        let patroller = Patroller(baseX: size.width/2)
        self.addChild(patroller)
        patroller.begin(groundHeight: credits.size.height + 10)
        patroller.physicsBody!.isDynamic = false
        
        let scoreLabel = SKLabelNode(text: "Patrolled\n\(Double(round(10*score)/10)) meters")
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontSize = 15
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: size.width/4, y: patroller.position.y)
        addChild(scoreLabel)
        
        let highscore = Double(round(10*UserDefaults.standard.double(forKey: "patrollerHighscore"))/10)
        let highscoreLabel = SKLabelNode(text: "Best patrol:\n\(highscore) meters")
        highscoreLabel.fontName = "Chalkduster"
        highscoreLabel.fontSize = 15
        highscoreLabel.fontColor = UIColor.white
        highscoreLabel.position = CGPoint(x: size.width/4*3, y: patroller.position.y)
        addChild(highscoreLabel)
        
        if score > highscore {
            highscoreLabel.text = "Prev. best:\n\(highscore) meters"
            youLose.text = "New best!"
            UserDefaults.standard.set(score, forKey: "patrollerHighscore")
        }
        
        if playingMusic {
            playBackgroundMusic(filename: "thief in the night.mp3")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if playingMusic {
            backgroundMusicPlayer.stop()
        }
        self.view!.presentScene(TitleScene(size: self.size))
    }
    
}

