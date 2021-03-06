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

var score = 0
var gameOver = false

var selectedSong = ""

class GameScene: SKScene, SKPhysicsContactDelegate, AVAudioPlayerDelegate {
    var filesAndTrackNames: [(String,String)] = [
                        ("mechanism","(Camellia) - Heart of Android : Even If It's Only By Mechanism"),
                        ("SmashMouthAllStar","Smash Mouth - All Star"),
                        ("RickAstleyNeverGonnaGiveYouUp","Rick Astley - Never Gonna Give You Up"),
                        ("HOMEResonance","Home - Resonance"),
                        ("HOMEPyxis","HOME - Pyxis")]
    private var audioURL : URL?
    private var waveSpriteCtl : WaveSpriteController?
    private var gameVC : GameViewController?
    let player = SKSpriteNode(imageNamed: "Surfer")
    let background = SKSpriteNode(imageNamed: "GameBG")
    
    let playerCategory: UInt32 = 0x1 << 0
    let groundCategory: UInt32 = 0x1 << 1
    
    var scoreLabel = SKLabelNode()
    
    private var sceneIsPaused = false
    
    override func didMove(to view: SKView) {
        
        let fileAndSongName = filesAndTrackNames[Int.random(in: 1..<filesAndTrackNames.count)]
        selectedSong = fileAndSongName.1
        audioURL = Bundle.main.url(forResource: fileAndSongName.0, withExtension: "mp3")!
        self.physicsWorld.contactDelegate = self
        
        //Background
        background.size = self.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1;
        addChild(background)
        
        //Player
        self.addChild(player)
        player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Surfer"), size: CGSize(width: 50, height: 100))
        player.size = CGSize(width: 70, height: 70)
        player.physicsBody?.allowsRotation = false
        
        //Physics
        physicsWorld.gravity = CGVector(dx: 0, dy: -3.34)

        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.collisionBitMask = groundCategory
        player.physicsBody?.contactTestBitMask = groundCategory
        
        scoreLabel.position = CGPoint(x: self.frame.width/3, y: self.frame.height/3)
        scoreLabel.text = "Score: \(score)";
        scoreLabel.fontSize = 40
        addChild(scoreLabel)

        //Generate the waves
        try! WaveSpriteController.fromURL(audioURL!, viewDimensions: self.size) { wsc in
            DispatchQueue.main.async {
                self.waveSpriteCtl = wsc
                if let wsc = wsc {
                    wsc.sprite.position = CGPoint(x: -self.size.width/2, y: -self.size.height/2
                    )
                    wsc.audioPlayer.delegate = self
                    self.addChild(wsc.sprite)
                    wsc.play()
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let _: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        sceneIsPaused = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "segueToEnd"), object: nil)
    }
    
    func checkOOB() {
        if((player.position.x < -self.size.width/2 || player.position.y < -self.size.height/2) && !gameOver) {
            gameOver = true
            DispatchQueue.main.async {
                self.waveSpriteCtl?.audioPlayer.stop();
            }
            sceneIsPaused = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "segueToEnd"), object: nil)
            return
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(!sceneIsPaused) {
            waveSpriteCtl?.update()
            checkOOB()
            score += 1
            scoreLabel.text = "Score: \(score)";
        }
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
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func touchUp(atPoint pos: CGPoint) {
        player.texture = SKTexture(imageNamed: "Surfer")
    }
}
