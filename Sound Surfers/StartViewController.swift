//
//  GameViewController.swift
//  Sound Surfers
//
//  Created by Alexander Hall on 9/11/21.
//

import UIKit
import SpriteKit
import GameplayKit

class StartViewController: UIViewController {
    
    var tappedScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            let scene = StartScene()
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .resizeFill
            
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.contentMode = .scaleToFill
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !tappedScreen {
            tappedScreen = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.performSegue(withIdentifier: "startToGame", sender: nil)
            })
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
