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
    }
    
    func loadWolf() {
        self.wolf = Wolf()
        addChildNode(wolf!)
    }
    
    func changeWolfState(_ state: WolfState) {
        self.wolf?.setWolfState(state: state)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
