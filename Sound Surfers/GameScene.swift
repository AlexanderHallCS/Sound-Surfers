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

class GameScene: SKScene {
    private let audioURL = Bundle.main.url(forResource: "mechanism", withExtension: "mp3")!
    
    private var waveSpriteCtl : WaveSpriteController?
    
    let background = SKSpriteNode(imageNamed: "GameBG")
    
    override func didMove(to view: SKView) {
        
        background.size = self.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1;
        addChild(background)
        
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
    
    override func update(_ currentTime: TimeInterval) {
        waveSpriteCtl?.update()
    }
}
