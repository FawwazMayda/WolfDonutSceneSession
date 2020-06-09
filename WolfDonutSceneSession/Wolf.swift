//
//  Wolf.swift
//  WolfDonutSceneSession
//
//  Created by Muhammad Fawwaz Mayda on 09/06/20.
//  Copyright © 2020 Muhammad Fawwaz Mayda. All rights reserved.
//

import UIKit
import SceneKit

enum WolfState {
    case idle,walking,running
}

class Wolf: SCNNode {
    private var wolfWalking : SCNNode = SCNNode()
    private var wolfIdle : SCNNode = SCNNode()
    private var wolfRunning: SCNNode = SCNNode()
    private var activeNode : SCNNode?
    
    override init() {
        super.init()
        loadWolfState()
        setWolfState(state: .walking)
    }
    func loadWolfState() {
        guard
            let walkingScene = SCNScene(named: "art.scnassets/Wolf/Wolf_Walking.scn"),
            let idleScene = SCNScene(named: "art.scnassets/Wolf/Wolf_Idle.scn"),
            let runningScene = SCNScene(named: "art.scnassets/Wolf/Wolf_Running.scn") else { return }
        
        /*
        wolfWalking = walkingScene.rootNode
        wolfIdle = idleScene.rootNode
        wolfRunning = runningScene.rootNode
        */
        
        wolfWalking.addChildNode(walkingScene.rootNode)
        wolfIdle.addChildNode(idleScene.rootNode)
        wolfRunning.addChildNode(runningScene.rootNode)
        
        print("Adding 1")
    }
    
    func setWolfState(state: WolfState) {
        activeNode?.removeFromParentNode()
        activeNode = nil
        switch state {
        case .idle:
            activeNode = wolfIdle
        case .running:
            activeNode = wolfRunning
        case .walking:
            activeNode = wolfWalking
        }
        addChildNode(activeNode!)
        print("Adding 2")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
