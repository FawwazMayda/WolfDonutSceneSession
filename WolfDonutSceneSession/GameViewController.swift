//
//  GameViewController.swift
//  WolfDonutSceneSession
//
//  Created by Muhammad Fawwaz Mayda on 09/06/20.
//  Copyright © 2020 Muhammad Fawwaz Mayda. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    @IBOutlet var scnView: SCNView!
    private var scene : SCNScene?
    private var player : Player?
    var hud : HUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup World
        setupWorld()
        //Setup Player
        setupPlayer()
        //Setup Camera
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hud = HUD(size: view.bounds.size)
        hud?.joyStick.trackingHandler = updatePlayerPosition
        
        hud?.joyStick.beginHandler  = { [weak self] in
            self?.updatePlayerState(.running)
        }
        
        hud?.joyStick.stopHandler = { [weak self] in
            self?.updatePlayerState(.idle)
        }
        scnView.overlaySKScene = hud?.scene
        
    }
    func setupWorld() {
        scene = SCNScene(named: "art.scnassets/GameScene.scn")
        scene?.background.contents = UIImage(named: "art.scnassets/textures/Background_sky")
        scnView.scene = scene
        scnView.allowsCameraControl = true
    }
    
    func setupPlayer() {
        player = Player()
        if let currentPlayer = player {
            scene?.rootNode.addChildNode(currentPlayer)
        }
    }
    
    func updatePlayerPosition(_ joyStickData: AnalogJoystickData) {
        player?.updateWolfPosition(joyStickData, velocityMultiplier: 0.0008)
    }
    
    func updatePlayerState(_ state: WolfState) {
        player?.changeWolfState(state)
    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
