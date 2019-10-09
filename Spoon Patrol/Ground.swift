//
//  Ground.swift
//  Spoon Patrol
//
//  Created by Kevin Trickey on 6/19/19.
//  Copyright © 2019 Kevin Trickey. All rights reserved.
//

import Foundation
import SpriteKit

class Ground: SKSpriteNode {
    
    init(groundWidth: CGFloat, groundHeight: CGFloat) {
        super.init(texture: SKTexture(imageNamed: "granite"), color: UIColor(), size: CGSize(width: groundWidth, height: groundHeight))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
