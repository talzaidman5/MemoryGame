//
//  StartControlled.swift
//  MemoryGame
//
//  Created by bobo on 22/05/2021.
//  Copyright © 2021 Tal. All rights reserved.
//
import UIKit

class StartController: UIViewController {
    var name: String = ""

    @IBOutlet weak var startGame_LBL_name: UITextField!
    @IBAction func StartGame(_ sender: Any){
        performSegue(withIdentifier: "startGame", sender: self)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if(segue.identifier == "startGame"){
            var vc = segue.destination as! ViewController
            vc.playerName = startGame_LBL_name.text!
        }
        else if (segue.identifier == "scoreList"){
            var vc = segue.destination as! Top10Controller
        }
        UserDefaults.standard.set(startGame_LBL_name.text, forKey: "name")

    }
    
    @IBAction func GoToScoreList(_ sender: Any) {
        performSegue(withIdentifier: "scoreList", sender: self)
    }
    
    
    
}
