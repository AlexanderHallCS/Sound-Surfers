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
    
    private let waveformImageDrawer = WaveformImageDrawer()
    private let audioURL = Bundle.main.url(forResource: "mechanism", withExtension: "mp3")!
    private var waveformSprite : SKSpriteNode?
    
    private var waveSpriteCtl : WaveSpriteController?
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "GameBG")

        background.size = self.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1;
        addChild(background)
        
        try! WaveSpriteController.fromURL(audioURL) { wsc in
            DispatchQueue.main.async {
                self.waveSpriteCtl = wsc
                if let wsc = wsc {
                    self.addChild(wsc.sprite)
                }
                wsc?.play()
            }
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {}
    
    func touchMoved(toPoint pos : CGPoint) {}
    
    func touchUp(atPoint pos : CGPoint) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    
    override func update(_ currentTime: TimeInterval) {
        waveSpriteCtl?.update()
    }
}
