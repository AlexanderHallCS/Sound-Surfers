//
//  EndViewController.swift
//  Sound Surfers
//
//  Created by Alexander Hall on 9/11/21.
//

import UIKit
import SpriteKit
import GameplayKit

class EndViewController: UIViewController {

    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var songLabel: UILabel!
    
    @IBOutlet var winOrLoseImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let labelFont = UIFont(name: "HelveticaNeue-Bold", size: 18)
        //let attributes :Dictionary = [NSAttributedString.Key.font : labelFont]
        //var attrString = NSAttributedString(string: "Foo", attributes:attributes)
        scoreLabel.text = "Score: \(score)"
        songLabel.text = "Song: \(selectedSong)"
        
        let scoreLabelAttributedText = NSMutableAttributedString.init(string: scoreLabel.text!)
        scoreLabelAttributedText.addAttribute((NSAttributedString.Key.font), value: labelFont!, range: NSRange(location: 0, length: 6))
        scoreLabel.attributedText = scoreLabelAttributedText
        
        
        let songLabelAttributedText = NSMutableAttributedString.init(string: songLabel.text!)
        songLabelAttributedText.addAttribute((NSAttributedString.Key.font), value: labelFont!, range: NSRange(location: 0, length: 6))
        songLabel.attributedText = songLabelAttributedText
        
        if(gameOver) {
            winOrLoseImage.image = UIImage(named: "GameOverText")
        } else {
            winOrLoseImage.image = UIImage(named: "YouWonText")
        }
    }

}
