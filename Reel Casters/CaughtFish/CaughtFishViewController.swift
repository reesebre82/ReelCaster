//
//  CaughtFishViewController.swift
//  Reel Casters
//
//  Created by Brendan Reese on 3/2/20.
//  Copyright © 2020 BrendanReese. All rights reserved.
//

import UIKit
import FirebaseFirestore

protocol AddCatchDelegate {
    func segueAddCatch()
    func exitAddCatch(didChange: Bool)
}

class CaughtFishViewController: UIViewController, AddCatchDelegate{
    
    var statusBarHeight: CGFloat = 0
    var segueDelegate: SegueDelegate?
    var updateSizeDelegate: UpdateSizeDelegate?
    var teamName = UILabel()
    var catchWeightLabel = UILabel()
    var addCatchButton = UIButton()
    var addCatchVC = AddCatchViewController()
    var catches = [Catch]()
    var contentScroll = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        view.backgroundColor = UIColor.white
        
        
        addContentHeader()
        addHeader()
        addContentView()
        loadContentsFromFirebase()
    }
    
    func addContentView(){
        contentScroll = UIScrollView(frame: CGRect(x: 0, y: addCatchButton.frame.maxY + view.frame.height * 0.15, width: view.frame.width, height: view.frame.height * 0.6))
    }
    
    func loadContentsFromFirebase(){
        resetContent()
        
        DispatchQueue.global(qos: .background).async {
            self.catches = [Catch]()
            print("loading")
            let name = UserDefaults.standard.string(forKey: "teamName")
            if name == nil{ return }
            let db = Firestore.firestore()
            print(name!)
            db.collection("User").document(name!).collection("catches").getDocuments()
            {
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let year = document.data()["year"] as! String
                        let month = document.data()["month"] as! String
                        let day = document.data()["day"] as! String
                        let weight = document.data()["weight"] as! String
                        let photo = document.data()["photoURL"] as! String
                        let aCatch = Catch(uuid: document.documentID, year: year, month: month, day: day, weight: weight, requireImage: photo)
                        self.catches.append(aCatch)
                    }
                    DispatchQueue.main.async {
                        self.displayContent()
                    }
                }
            }
        }
    }
    
    func resetContent(){
        for view in contentScroll.subviews{
            view.removeFromSuperview()
            print("removed")
        }
    }
    
    func displayContent(){
        var score = 0.0
        var y = view.frame.height * 0.075 / 2
        for aCatch in catches{
            if aCatch.requireImage == "false"{
                let singleCatch = aCatch.createPost(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.85, height: view.frame.height * 0.075), center: CGPoint(x: contentScroll.center.x, y: y))
                let tap = UITapGestureRecognizer(target: self, action: #selector(updateCatchInformation(sender: )))
                singleCatch.addGestureRecognizer(tap)
                contentScroll.addSubview(singleCatch)
            }
            else{
                if score == 0.0 { y *=  3}
                else{ y += (view.frame.height * 0.075) }
                contentScroll.addSubview(aCatch.createPost(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.85, height: view.frame.height * 0.075 * 2 * 1.5), center: CGPoint(x: contentScroll.center.x, y: y)))
                y += (view.frame.height * 0.075)
            }

            y += view.frame.height * 0.075 * 1.5
            score += aCatch.weight.doubleValue
        }
        contentScroll.contentSize = CGSize(width: contentScroll.frame.width, height: y)
        view.addSubview(contentScroll)
        
        updateSize(score)
    }
    
    @objc func updateCatchInformation(sender: UITapGestureRecognizer){
        
        var weightText = ""
        var dayText = ""
        var monthText = ""
        
        for case let i as UILabel in sender.view!.subviews{
            if i.tag == 0{
                dayText = String(i.text!.suffix(2))
                if dayText[0] == " " { dayText = String(i.text!.suffix(1)) }
                monthText = String(i.text!.prefix(4))
            }
            if i.tag == 1{
                weightText = i.text!
            }
        }
    }
    
    func addContentHeader(){
        let contentView = UIView(frame: CGRect(x: 0, y: view.frame.height * 0.115, width: view.frame.width, height: view.frame.height - view.frame.height * 0.115))
        let icon = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.frame.width * 0.55, height: contentView.frame.width * 0.55))
        icon.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.165)
        if hasNotch(){ icon.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.14) }
        icon.image = UIImage(named: "BassGreen")
        contentView.addSubview(icon)
        
        addCatchButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.85, height: view.frame.height * 0.075))
        addCatchButton.center = CGPoint(x: view.frame.width / 2,  y: icon.frame.maxY)
        addCatchButton.setTitle("Add Catch", for: .normal)
        addCatchButton.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        addCatchButton.layer.cornerRadius = 12.0
        addCatchButton.setTitleColor(.black, for: .normal)
        addCatchButton.titleLabel?.font = UIFont(name: "Inkfree", size: 20)
        addCatchButton.layer.masksToBounds = true
        addCatchButton.addTarget(self, action: #selector(segueAddCatch), for: .touchUpInside)
        contentView.addSubview(addCatchButton)
        
        catchWeightLabel = UILabel(frame: CGRect(x: 0, y: 0, width: icon.frame.width * 0.3, height: icon.frame.height * 0.8))
        catchWeightLabel.center = CGPoint(x: icon.frame.width / 2, y: icon.frame.height * 0.35)
        catchWeightLabel.text = "0.0"
        catchWeightLabel.textColor = .black
        catchWeightLabel.font = UIFont(name: "Inkfree", size: 27)
        catchWeightLabel.adjustsFontSizeToFitWidth = true
        catchWeightLabel.textAlignment = .center
        icon.addSubview(catchWeightLabel)
        
        view.addSubview(contentView)
    }
    
    func addHeader(){
        let background = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.115))
        background.tag = 2
        view.addSubview(background)
        
        let bgimage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.115))
        bgimage.image = UIImage(named: "Title_Head_HOME")
        bgimage.tag = 2
        background.addSubview(bgimage)
        
        let defaults = UserDefaults.standard
        let team = defaults.string(forKey: "teamName") ?? "NULL"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.segueIntroScreen))
        
        teamName = UILabel(frame: CGRect(x: background.frame.midX, y: background.frame.midY, width: background.frame.width * 0.65, height: background.frame.height / 2))
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
        
        let cf = UILabel(frame: CGRect(x: background.frame.midX, y: background.frame.midY, width: background.frame.width / 2, height: background.frame.height / 2))
        cf.text = "Caught Fish"
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
        let fishTap = UITapGestureRecognizer(target: self, action: #selector(self.segueAnglerStatus))
        fishButtonBackground.addGestureRecognizer(fishTap)
        background.addSubview(fishButtonBackground)
        
        let fishButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.075, height: view.frame.width * 0.075))
        fishButton.center = CGPoint(x: view.frame.width * 0.1, y: (cf.center.y + teamName.center.y) / 2)
        fishButton.setImage(UIImage(named: "ButtonFISH"), for: .normal)
        fishButton.tag = 1
        fishButton.addTarget(self, action: #selector(segueAnglerStatus), for: .touchUpInside)
        background.addSubview(fishButton)
        
    }
    
    @objc func segueAddCatch(){
        addCatchVC = AddCatchViewController()
        addCatchVC.addCatchDelegate = self
        addCatchVC.view.frame = self.view.frame
        
        present(addCatchVC, animated: true, completion: {
            self.addCatchVC.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
        
    }
    
    @objc func exitAddCatch(didChange: Bool) {
        addCatchVC.dismiss(animated: true, completion: nil)
        if(didChange){
            loadContentsFromFirebase() // true false if update is required
        }
    }
    
    @objc func segueAnglerStatus(sender: UIButton){
        segueDelegate?.segueAngler()
    }
    
    
    @objc func segueIntroScreen(){
        segueDelegate?.segueIntro(time: 0.5)
    }
    
    func updateSize(_ size: Double){
        let alteredSize = size.rounded(toPlaces: 2);
        catchWeightLabel.text = "\(alteredSize)"
        updateSizeDelegate?.weightUpdated(size: alteredSize)
        //size
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
