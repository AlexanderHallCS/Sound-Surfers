//
//  GameScene.swift
//  test
//
//  Created by Matthew Tran on 9/11/21.
//

import SpriteKit
import GameplayKit
import DSWaveformImage
import AVFoundation

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private let waveformImageDrawer = WaveformImageDrawer()
    private let audioURL = Bundle.main.url(forResource: "mechanism", withExtension: "mp3")!
    private var waveformSprite : SKSpriteNode?
    
    private var audioPlayer : AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        audioPlayer = try! AVAudioPlayer(contentsOf: audioURL)
        audioPlayer!.prepareToPlay()
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        
        
        print("\(audioURL)")
        let config = Waveform.Configuration(
            size: CGSize(width: 8192/3, height: 200),
            backgroundColor: .clear,
            style: .striped(.init(color: UIColor(red: 1, green: 92/255.0, blue: 103/255.0, alpha: 1), width: 5, spacing: 5)),
            position: .bottom,
            verticalScalingFactor: 0.5
        )
        
        waveformImageDrawer.waveformImage(fromAudioAt: audioURL, with: config) { image in
            DispatchQueue.main.async {
                let waveformSprite = SKSpriteNode(texture: SKTexture(image: image!))
                waveformSprite.zPosition = 1000;
                waveformSprite.anchorPoint = CGPoint(x: 0, y: 0.5)
                waveformSprite.position.x = self.size.width / 2
                print(waveformSprite.position)
                self.addChild(waveformSprite)
                self.waveformSprite = waveformSprite
                self.audioPlayer!.play()
            }
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if let waveformSprite = self.waveformSprite, let audioPlayer = audioPlayer {
            let currentTimeNormalized = audioPlayer.currentTime / audioPlayer.duration
            let spriteInitialX = size.width / 2
            let spriteWidth = waveformSprite.size.width
            waveformSprite.position.x = spriteInitialX - CGFloat(currentTimeNormalized) * spriteWidth
        }
    }
}
