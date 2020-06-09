//
//  Player.swift
//  WolfDonutSceneSession
//
//  Created by Muhammad Fawwaz Mayda on 09/06/20.
//  Copyright © 2020 Muhammad Fawwaz Mayda. All rights reserved.
//

import SceneKit

class Player: SCNNode {
    private var wolf : Wolf?
    override init() {
        super.init()
        //load wolf
        loadWolf()
        //load camera
        //load lighting
        loadLight()
        
    }
    
    func loadWolf() {
        self.wolf = Wolf()
        addChildNode(wolf!)
    }
    
    func changeWolfState(_ state: WolfState) {
        self.wolf?.setWolfState(state: state)
    }
    
    func loadLight() {
        // Create a spotlight at the player
        let spotLight = SCNLight()
        spotLight.type = SCNLight.LightType.directional
        spotLight.spotInnerAngle = 40.0
        spotLight.spotOuterAngle = 80.0
        spotLight.castsShadow = true
        spotLight.color = UIColor.white
        let spotLightNode = SCNNode()
        spotLightNode.light = spotLight
        spotLightNode.position = SCNVector3(x: 1.0, y: 5.0, z: -2.0)
        self.addChildNode(spotLightNode)
        
        let constraint2 = SCNLookAtConstraint(target: self)
        constraint2.isGimbalLockEnabled = true
        spotLightNode.constraints = [constraint2]

        // Create additional omni light
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.omni
        lightNode.light!.color = UIColor.darkGray
        lightNode.position = SCNVector3(x: 0, y: 10.00, z: -2)
        self.addChildNode(lightNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
