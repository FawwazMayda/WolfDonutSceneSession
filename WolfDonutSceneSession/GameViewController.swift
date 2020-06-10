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
    
    //Camera
    private var cameraNode = SCNNode()
    private var lookAtTarget = SCNNode()
    var activeCamera : SCNNode?
    static let CameraOrientationSensitivity: Float = 0.05
    
    var cameraDirection = vector_float2.zero {
        didSet{
            let l = simd_length(cameraDirection)
            if l > 1.0 {
                cameraDirection *= 1/1
            }
            cameraDirection.y = 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup World
        setupWorld()
        //Setup Player
        setupPlayer()
        //Setup Camera
        loadCamera()
        setupDonut()
        
        
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
        
        let grassNode = scene?.rootNode.childNode(withName: "Grass", recursively: true)!
        grassNode?.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        
        scnView.scene = scene
        scnView.allowsCameraControl = false
        
        
    }
    
    func setupPlayer() {
        player = Player()
        player?.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        if let currentPlayer = player {
            scene?.rootNode.addChildNode(currentPlayer)
        }
    }
    
    func setupDonut() {
        for _ in 1...20 {
            let donut = Donut()

            let xPos = Float.random(in: -6...6)
            let zPos = Float.random(in: -6...6)
            donut.position = SCNVector3(xPos,0,zPos)
            donut.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            scene?.rootNode.addChildNode(donut)
        }
    }
    
    func loadCamera() {
        //The lookAtTarget node will be placed slighlty above the character using a constraint
        weak var weakSelf = self

        self.lookAtTarget.constraints = [ SCNTransformConstraint.positionConstraint(
                                        inWorldSpace: true, with: { (_ node: SCNNode, _ position: SCNVector3) -> SCNVector3 in
            guard let strongSelf = weakSelf else { return position }

            var worldPosition = strongSelf.player!.simdWorldPosition
            worldPosition.y = strongSelf.player!.baseAltitude + 0.5
            return SCNVector3(worldPosition)
        })]

        scene?.rootNode.addChildNode(lookAtTarget)

        scene?.rootNode.enumerateHierarchy({(_ node: SCNNode, _ _: UnsafeMutablePointer<ObjCBool>) -> Void in
            if node.camera != nil {
                self.setupFollowCamera(node)
            }
        })

        self.cameraNode.camera = SCNCamera()
        self.cameraNode.name = "mainCamera"
        self.cameraNode.camera!.zNear = 0.1
        self.cameraNode.camera!.zFar = 200
        scene?.rootNode.addChildNode(cameraNode)
    }
    
    func setupFollowCamera(_ cameraNode: SCNNode) {
        // look at "lookAtTarget"
        let lookAtConstraint = SCNLookAtConstraint(target: self.lookAtTarget)
        lookAtConstraint.influenceFactor = 0.07
        lookAtConstraint.isGimbalLockEnabled = true

        // distance constraints
        let follow = SCNDistanceConstraint(target: self.lookAtTarget)
        let distance = CGFloat(simd_length(cameraNode.simdPosition))
        follow.minimumDistance = distance
        follow.maximumDistance = distance

        // configure a constraint to maintain a constant altitude relative to the character
        let desiredAltitude = abs(cameraNode.simdWorldPosition.y)
        weak var weakSelf = self

        let keepAltitude = SCNTransformConstraint.positionConstraint(inWorldSpace: true, with: {(_ node: SCNNode, _ position: SCNVector3) -> SCNVector3 in
                guard let strongSelf = weakSelf else { return position }
                var position = float3(position)
                position.y = strongSelf.player!.baseAltitude + desiredAltitude
                return SCNVector3( position )
            })

        let accelerationConstraint = SCNAccelerationConstraint()
        accelerationConstraint.maximumLinearVelocity = 1500.0
        accelerationConstraint.maximumLinearAcceleration = 50.0
        accelerationConstraint.damping = 0.05

        // use a custom constraint to let the user orbit the camera around the character
        let transformNode = SCNNode()
        let orientationUpdateConstraint = SCNTransformConstraint(inWorldSpace: true) { (_ node: SCNNode, _ transform: SCNMatrix4) -> SCNMatrix4 in
            guard let strongSelf = weakSelf else { return transform }
            if strongSelf.activeCamera != node {
                return transform
            }

            // Slowly update the acceleration constraint influence factor to smoothly reenable the acceleration.
            accelerationConstraint.influenceFactor = min(1, accelerationConstraint.influenceFactor + 0.01)

            let targetPosition = strongSelf.lookAtTarget.presentation.simdWorldPosition
            let cameraDirection = strongSelf.cameraDirection
            if cameraDirection.allZero() {
                return transform
            }

            // Disable the acceleration constraint.
            accelerationConstraint.influenceFactor = 0

            let characterWorldUp = strongSelf.player!.presentation.simdWorldUp

            transformNode.transform = transform

            let q = simd_mul(
                simd_quaternion(GameViewController.CameraOrientationSensitivity * cameraDirection.x, characterWorldUp),
                simd_quaternion(GameViewController.CameraOrientationSensitivity * cameraDirection.y, transformNode.simdWorldRight)
            )

            transformNode.simdRotate(by: q, aroundTarget: targetPosition)
            return transformNode.transform
        }
        cameraNode.constraints = [follow, keepAltitude, accelerationConstraint, orientationUpdateConstraint, lookAtConstraint]
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
