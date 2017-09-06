//
//  Menu.swift
//  Falldown
//
//  Created by John Quinn on 8/30/17.
//  Copyright © 2017 Dilldrup LLC. All rights reserved.
//

import SpriteKit
import WatchKit

class Menu: WKInterfaceController {
    
    var highScore = UserDefaults.standard.integer(forKey: "HIGHSCORE")
    var latestScore = UserDefaults.standard.integer(forKey: "LATESTSCORE")
    
    @IBOutlet var highScoreLabel: WKInterfaceLabel!
    
    @IBOutlet var latestScoreLabel: WKInterfaceLabel!
    
    //NEED TO FIGURE OUT HOW TO SET SCORE ANY TIME SOMEBODY RETURNS
    
    override func awake(withContext context: Any?) {
        
            highScoreLabel.setText("High Score: \(highScore)")
        
            latestScoreLabel.setText("Latest Score: \(latestScore)")
        
        }
    
    @IBAction func playButtonPressed() {
        
        WKInterfaceController.reloadRootControllers(withNames: ["Game"], contexts: ["Game"]) // USE THIS CODE BECAUSE IT DOESN'T SHOW THE CANCEL BUTTON WHEN PRESENTING THE GAME

    }
    
    
}

