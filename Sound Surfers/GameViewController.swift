//
//  GameViewController.swift
//  Sound Surfers
//
//  Created by Alexander Hall on 9/11/21.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController, AVAudioPlayerDelegate {

    var prevVC: StartViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene()
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .resizeFill
            
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.contentMode = .scaleToFill
        }
        NotificationCenter.default.addObserver(self, selector: #selector(segueToEnd), name: NSNotification.Name(rawValue: "segueToEnd"), object: nil)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    
    @objc func segueToEnd(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "segueToEnd"), object: nil)
        
        DispatchQueue.main.async { [weak self] in
            self?.performSegue(withIdentifier: "gameToEnd", sender: self)
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
