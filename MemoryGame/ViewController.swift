//
//  ViewController.swift
//  MemoryGame
//
//  Created by bobo on 30/04/2021.
//  Copyright © 2021 Tal. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var Main_Game_LBL_card1: UIButton!
    @IBOutlet weak var Main_Game_LBL_card2: UIButton!
    @IBOutlet weak var Main_Game_LBL_card3: UIButton!
    @IBOutlet weak var Main_Game_LBL_card4: UIButton!
    @IBOutlet weak var Main_Game_LBL_card5: UIButton!
    @IBOutlet weak var Main_Game_LBL_card6: UIButton!
    @IBOutlet weak var Main_Game_LBL_card7: UIButton!
    @IBOutlet weak var Main_Game_LBL_card8: UIButton!
    @IBOutlet weak var Main_Game_LBL_card9: UIButton!
    @IBOutlet weak var Main_Game_LBL_card10: UIButton!
    @IBOutlet weak var Main_Game_LBL_card11: UIButton!
    @IBOutlet weak var Main_Game_LBL_card12: UIButton!
    @IBOutlet weak var Main_Game_LBL_card13: UIButton!
    @IBOutlet weak var Main_Game_LBL_card14: UIButton!
    @IBOutlet weak var Main_Game_LBL_card15: UIButton!
    @IBOutlet weak var Main_Game_LBL_card16: UIButton!
    @IBOutlet weak var Main_Game_LBL_moves: UILabel!
    @IBOutlet weak var Main_Game_LBL_timer: UILabel!
    @IBOutlet weak var Main_Game_LBL_startAgain: UIButton!

        let game = MemoryGame()
        var cards = [Card]()
        var buttons = [UIButton]()
        var images = [UIImage]()
        var moves: Int = 0
        var playerName: String = ""
        var ifFinish: Bool = false
        var time = 0
        var timer = Timer()
        var hideImage = UIImage()
        var scores = [score]()
        var myLocation : PlayerLocation!
        var locationManager: CLLocationManager!

    
        override func viewDidLoad() {
            super.viewDidLoad()
            hideImage = #imageLiteral(resourceName: "CoolClips_vc013463")
            images = [#imageLiteral(resourceName: "turtle"), #imageLiteral(resourceName: "jellyfish"), #imageLiteral(resourceName: "crab"), #imageLiteral(resourceName: "whale"),#imageLiteral(resourceName: "octopus") , #imageLiteral(resourceName: "fish") ,#imageLiteral(resourceName: "dolphin") ,#imageLiteral(resourceName: "starfish") ]
            buttons = [Main_Game_LBL_card1,Main_Game_LBL_card2,Main_Game_LBL_card3,Main_Game_LBL_card4,Main_Game_LBL_card5,Main_Game_LBL_card6,Main_Game_LBL_card7,Main_Game_LBL_card8,
                        Main_Game_LBL_card9,Main_Game_LBL_card10,Main_Game_LBL_card11,Main_Game_LBL_card12,Main_Game_LBL_card13,Main_Game_LBL_card14,Main_Game_LBL_card15,Main_Game_LBL_card16]
      
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()


            self.initGame()
        }
        
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if game.isPlaying {
            resetGame()
        }
    }
    
    func startTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    func storeData(){
        self.scores = DataManager.getDataFromtorage()
        let nameTemp = UserDefaults.standard.string(forKey: "name")

        let score : score = score( time : self.time, loc: self.myLocation, name : nameTemp!)
        insertScore(myScore : score)
        DataManager.saveScoresListInStorage(scoresList: self.scores)
    }
    
    func insertScore(myScore : score){
        
        if(scores.isEmpty){
            scores.append(myScore)
            return
        }
                
        if(!insertToListByTime(myScore: myScore) && scores.count < 10){
            self.scores.insert(myScore, at: scores.count)
        }
        
        if(scores.count > 10){
            scores.remove(at: scores.count - 1)
        }
        
    }
    
    func insertToListByTime(myScore : score) -> Bool{
        for i in  0 ..< scores.count {
            if(myScore.time < scores[i].time){
                scores.insert(myScore, at: i)
                return true
            }
        }
        
        return false
    }
    @objc func updateTimer(){
        time += 1
        Main_Game_LBL_timer.text = "Timer: "+String(time)
    }
    
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        if let nav = self.navigationController {
                   nav.popViewController(animated: true)
               }
    }
    
    
    @IBAction func cardClicked(_ sender: UIButton) {
        self.moves+=1
        Main_Game_LBL_moves.text = "Moves: " + String(moves)
        sender.imageView?.layer.transform = CATransform3DIdentity
        ifFinish = game.cardSelected(findCardByTag(button :sender))
        if (ifFinish){
            finishGame()
        }
    }
    
    func finishGame(){
        timer.invalidate()
        Main_Game_LBL_startAgain.isHidden = false
        saveData();
        storeData()
    }
    
    func saveData(){
        UserDefaults.standard.set(time, forKey: "timer")
        UserDefaults.standard.set(moves, forKey: "moves")
    }

    
    func findCardByTag(button: UIButton)->Card?{
        for card in cards {
            if (card.tag == button.tag){
               return card
            }
        }
        return nil
    }
    
    func initGame() {
        Main_Game_LBL_startAgain.isHidden = true
        self.startTimer()
        buttons.shuffle()
        time = 0
        moves = 0
        Main_Game_LBL_moves.text = "Moves: " + String(moves)
        cards = game.newGame(buttonsArray: self.buttons, imagesArray: self.images)
        hideCards()
    }
    
    func resetGame() {
        timer.invalidate()
        game.restartGame()
        initGame()
    }
    

    func hideCards() {
        for button in self.buttons{
            button.imageView?.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
        }
    }
   
}


extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            myLocation = PlayerLocation(lat: lat, lon: lon)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        myLocation = PlayerLocation(lat: 0, lon: 0)
    }
}

