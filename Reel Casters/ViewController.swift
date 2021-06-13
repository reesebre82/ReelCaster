//
//  ViewController.swift
//  Reel Casters
//
//  Created by Brendan Reese on 3/2/20.
//  Copyright © 2020 BrendanReese. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SegueDelegate, UpdateSizeDelegate {

    var scrollView = UIScrollView()
    var caughtFishVC: CaughtFishViewController?
    var anglerStatusVC: AnglerStatusViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
    }

    
    override func viewDidAppear(_ animated: Bool) {
        scrollView = UIScrollView(frame: self.view.frame)
        self.view.addSubview(scrollView)
        
        addAnglerStatusPage()
        addCatchFishPage()
        
        scrollView.contentSize = CGSize(width: self.view.frame.width * 2, height: self.view.frame.height)
        scrollView.isScrollEnabled = false
        scrollView.contentOffset = CGPoint(x: self.view.frame.width, y: 0)
        scrollView.isUserInteractionEnabled = true

        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore  {
            segueIntro(time: 0)
        }
    }
    
    
    func addAnglerStatusPage(){
        anglerStatusVC = AnglerStatusViewController()
        anglerStatusVC!.view.frame = self.view.bounds
        self.addChild(anglerStatusVC!)
        scrollView.addSubview((anglerStatusVC!.view))
        anglerStatusVC!.didMove(toParent: self)
        
        anglerStatusVC?.segueDelegate = self

        moveVC(0.0, anglerStatusVC!.view)
    }
    
    func addCatchFishPage(){
        caughtFishVC = CaughtFishViewController()
        caughtFishVC!.view.frame = self.view.bounds
        self.addChild(caughtFishVC!)
        scrollView.addSubview((caughtFishVC!.view))
        caughtFishVC!.didMove(toParent: self)
        
        caughtFishVC?.segueDelegate = self
        caughtFishVC?.updateSizeDelegate = self
        moveVC(1, caughtFishVC!.view)
    }
    
    func moveVC(_ to: CGFloat, _ currentView: UIView){
        let x = currentView.frame.width * to
        currentView.frame = CGRect(x: x, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    
    //SegueDelegate
    func segueCatch() {
        scrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
    }
    
    func segueIntro(time: TimeInterval) {
        let introVC = IntroScreenViewController()
        introVC.view.frame = self.view.bounds
        self.addChild(introVC)
        introVC.segueDelegate = self
        let introView = introVC.view!

        
        introView.frame = CGRect(x: 0, y: -introView.frame.height, width: introView.frame.width, height: introView.frame.height)
        introView.alpha = 1
        
        view.addSubview(introView)
        
        UIView.animate(withDuration: time,
                       animations: { () -> Void in
                        introView.frame = CGRect(x: 0, y: 0, width: introView.frame.width, height: introView.frame.height)
        },completion: nil)
            
    }
    
    func exitIntro(time: TimeInterval, newName: String, introVC: IntroScreenViewController) {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore  {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        caughtFishVC!.teamName.text = "Team \(newName)"
        anglerStatusVC!.teamName.text = "Team \(newName)"
        
        let defaults = UserDefaults.standard
        defaults.set("\(newName)", forKey: "teamName")
        
        caughtFishVC?.loadContentsFromFirebase()
        let introView = introVC.view!
        introView.frame = CGRect(x: 0, y: 0, width: introView.frame.width, height: introView.frame.height)
        introView.alpha = 1
        
        UIView.animate(withDuration: time,
                       animations: { () -> Void in
                        introView.frame = CGRect(x: 0, y: -introView.frame.height, width: introView.frame.width, height: introView.frame.height)
        },completion: {
            (finished: Bool) in
            introView.removeFromSuperview()
            introVC.removeFromParent()
        })
    }
    
    func segueAngler() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
    func weightUpdated(size: Double) {
        anglerStatusVC?.addContent(weight: size)
    }

}
