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
    
    private var audioPlayer : AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "GameBG")

        background.size = self.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1;
        addChild(background)
        
        audioPlayer = try! AVAudioPlayer(contentsOf: audioURL)
        audioPlayer!.prepareToPlay()
        
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
    
    
    func touchDown(atPoint pos : CGPoint) {}
    
    func touchMoved(toPoint pos : CGPoint) {}
    
    func touchUp(atPoint pos : CGPoint) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    
    override func update(_ currentTime: TimeInterval) {
        if let waveformSprite = self.waveformSprite, let audioPlayer = audioPlayer {
            let currentTimeNormalized = audioPlayer.currentTime / audioPlayer.duration
            let spriteInitialX = size.width / 2
            let spriteWidth = waveformSprite.size.width
            waveformSprite.position.x = spriteInitialX - CGFloat(currentTimeNormalized) * spriteWidth
        }
    }
}
