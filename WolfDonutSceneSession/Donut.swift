//
//  Donut.swift
//  WolfDonutSceneSession
//
//  Created by Muhammad Fawwaz Mayda on 10/06/20.
//  Copyright © 2020 Muhammad Fawwaz Mayda. All rights reserved.
//

import Foundation
import SceneKit

class Donut: SCNNode {
    override init() {
        super.init()
        
        let donutScene = SCNScene(named: "art.scnassets/donut.scn")!
        let donutNode = donutScene.rootNode.childNode(withName: "donut", recursively: true)!
        
        let rotateDonutAction = SCNAction.rotateBy(x: 0, y: CGFloat(Double.pi), z: CGFloat(Double.pi), duration: 3.0)
        
        donutNode.runAction(SCNAction.repeatForever(rotateDonutAction))
        addChildNode(donutNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}
