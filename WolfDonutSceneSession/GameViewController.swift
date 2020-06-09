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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup World
        setupWorld()
        //Setup Player
        setupPlayer()
        //Setup Camera
        
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
