//
//  AnglerStatusViewController.swift
//  Reel Casters
//
//  Created by Brendan Reese on 3/4/20.
//  Copyright © 2020 BrendanReese. All rights reserved.
//

import UIKit

class AnglerStatusViewController: UIViewController {
    
    var statusBarHeight: CGFloat = 0
    var teamName = UILabel()
    var segueDelegate: SegueDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //Sets statusBarHeight
        statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        view.backgroundColor = UIColor.white
        addHeader()
        addContent(weight: 0.0)
    }
    
    func addHeader(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.segueIntroScreen))
        
        let background = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.115))
        background.tag = 2
        view.addSubview(background)
        
        let bgimage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.115))
        bgimage.image = UIImage(named: "Title_Head_ANGLERSTAT")
        bgimage.tag = 2
        background.addSubview(bgimage)
        
        let defaults = UserDefaults.standard
        let team = defaults.string(forKey: "teamName") ?? "NULL"
        
        teamName = UILabel(frame: CGRect(x: 0, y: 0, width: background.frame.width * 0.75, height: background.frame.height / 2))
        teamName.center = background.center
        if(hasNotch()){teamName.center = CGPoint(x: background.center.x, y: background.center.y + (background.frame.height - statusBarHeight)/4)}
        teamName.text = "Team \(team)"
        teamName.textColor = UIColor.white
        teamName.font = UIFont.init(name: "Inkfree", size: 24)
        teamName.textAlignment = .center
        teamName.tag = 9
        teamName.addGestureRecognizer(tap)
        teamName.isUserInteractionEnabled = true
        background.addSubview(teamName)
        
        let cf = UILabel(frame: CGRect(x: background.frame.minX, y: background.frame.midY, width: background.frame.width / 2, height: background.frame.height / 2))
        cf.text = "Angler Status"
        cf.textColor = UIColor.white
        cf.font = UIFont.init(name: "AndaleMono", size: 10)
        cf.textAlignment = .center
        cf.tag = 8
        cf.addGestureRecognizer(tap)
        cf.isUserInteractionEnabled = true
        cf.center = CGPoint(x: view.frame.width / 2, y: teamName.center.y + 20)
        background.addSubview(cf)
        
        let fishButtonBackground = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.125, height: view.frame.width * 0.125))
        fishButtonBackground.center = CGPoint(x: view.frame.width * 0.1, y: (cf.center.y + teamName.center.y) / 2)
        fishButtonBackground.tag = 1
        let fishTap = UITapGestureRecognizer(target: self, action: #selector(self.segueCaughtFish))
        fishButtonBackground.addGestureRecognizer(fishTap)
        background.addSubview(fishButtonBackground)
        
        let fishButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.075, height: view.frame.width * 0.075))
        fishButton.center = CGPoint(x: view.frame.width * 0.9, y: (cf.center.y + teamName.center.y) / 2)
        fishButton.setImage(UIImage(named: "ButtonHOME"), for: .normal)
        fishButton.tag = 4
        fishButton.addTarget(self, action: #selector(self.segueCaughtFish), for: .touchUpInside)
        background.addSubview(fishButton)
        
    }
    
    func removeContent(){
        for view in self.view.subviews{
            if view.tag == 1125{
                view.removeFromSuperview()
            }
        }
    }
    
    func addContent(weight: Double){
        removeContent()
        let fish = ASD.getFish(weight: weight)
        print("\(fish.0), \(fish.1)")
        
        let fishPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width * (2/3), height: view.frame.width * (2/3)))
        fishPhoto.image = UIImage(named: fish.0)
        fishPhoto.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.335)
        if hasNotch(){
            fishPhoto.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.3)
        }
        fishPhoto.tag = 1125
        view.addSubview(fishPhoto)
    }
    
    @objc func segueCaughtFish(sender: UIButton){
        segueDelegate?.segueCatch()
    }
    
    
    @objc func segueIntroScreen(){
        segueDelegate?.segueIntro(time: 0.5)
    }
    
    func hasNotch() -> Bool{
        if(UIDevice.modelName == "iPhone X"){return true}
        if(UIDevice.modelName == "iPhone XS"){return true}
        if(UIDevice.modelName == "iPhone XS Max"){return true}
        if(UIDevice.modelName == "iPhone XR"){return true}
        if(UIDevice.modelName == "iPhone 11"){return true}
        if(UIDevice.modelName == "iPhone 11 Pro"){return true}
        if(UIDevice.modelName == "iPhone 11 Pro Max"){return true}
        
        if(UIDevice.modelName == "Simulator iPhone X"){return true}
        if(UIDevice.modelName == "Simulator iPhone XS"){return true}
        if(UIDevice.modelName == "Simulator iPhone XS Max"){return true}
        if(UIDevice.modelName == "Simulator iPhone XR"){return true}
        if(UIDevice.modelName == "Simulator iPhone 11"){return true}
        if(UIDevice.modelName == "Simulator iPhone 11 Pro"){return true}
        if(UIDevice.modelName == "Simulator iPhone 11 Pro Max"){return true}
        
        return false
    }
}
