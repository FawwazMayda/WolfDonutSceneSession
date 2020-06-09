//
//  HUD.swift
//  WolfDonutSceneSession
//
//  Created by Muhammad Fawwaz Mayda on 09/06/20.
//  Copyright © 2020 Muhammad Fawwaz Mayda. All rights reserved.
//

import Foundation
import SpriteKit

class HUD {
    private var _scene : SKScene!
    var joyStick : AnalogJoystick!
    var scene : SKScene {
        return _scene
    }
    
    init(size : CGSize) {
        _scene = SKScene(size: size)
        joyStick = AnalogJoystick(diameter: size.width/2, colors: nil, images: (substrate: #imageLiteral(resourceName: "jStick"), stick: #imageLiteral(resourceName: "jSubstrate")))
        joyStick.position = CGPoint(x: size.width/2, y: size.width/2)
        _scene.addChild(joyStick)
    }
    
}
