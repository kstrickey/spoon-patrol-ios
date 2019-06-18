//
//  GameViewController.swift
//  Moon Patrol
//
//  Created by Kevin on 8/7/17.
//  Copyright (c) 2017 Casual Programmer. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var started = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !started {
            started = true
            let scene = TitleScene(size: view.bounds.size)
            let skView = view as! SKView
            skView.showsPhysics = true
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .resizeFill
            skView.presentScene(scene)
        }
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

