//
//  GameScene.swift
//  Sound Surfers
//
//  Created by Alexander Hall on 9/11/21.
//

import SpriteKit
import GameplayKit
import DSWaveformImage
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    private let audioURL = Bundle.main.url(forResource: "mechanism", withExtension: "mp3")!
    private var waveSpriteCtl : WaveSpriteController?
    let player = SKSpriteNode(imageNamed: "Surfer")
    let background = SKSpriteNode(imageNamed: "GameBG")
    
    let playerCategory: UInt32 = 0x1 << 0
    let groundCategory: UInt32 = 0x1 << 1
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        //Background
        background.size = self.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1;
        addChild(background)
        
        //Player
        self.addChild(player)
        player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "surfer"), size: CGSize(width: 50, height: 100))
        player.size = CGSize(width: 70, height: 70)
        player.physicsBody?.allowsRotation = false
        
        //Physics
        physicsWorld.gravity = CGVector(dx: 0, dy: -1.02)

        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.collisionBitMask = groundCategory
        player.physicsBody?.contactTestBitMask = groundCategory
        

        //Generate the waves
        try! WaveSpriteController.fromURL(audioURL, viewDimensions: self.size) { wsc in
            DispatchQueue.main.async {
                self.waveSpriteCtl = wsc
                if let wsc = wsc {
                    wsc.sprite.position = CGPoint(x: -self.size.width/2, y: -self.size.height/2)
                    self.addChild(wsc.sprite)
                    wsc.play()
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        if collision == groundCategory | playerCategory {
            print("Clllision")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        waveSpriteCtl?.update()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
        }
    }

    func touchDown(atPoint pos: CGPoint) {
        jump()
    }

    func jump() {
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func touchUp(atPoint pos: CGPoint) {
        player.texture = SKTexture(imageNamed: "Surfer")
    }
}
