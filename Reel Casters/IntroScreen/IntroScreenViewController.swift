//
//  IntroScreenViewController.swift
//  Reel Casters
//
//  Created by Brendan Reese on 3/3/20.
//  Copyright © 2020 BrendanReese. All rights reserved.
//

import UIKit

class IntroScreenViewController: UIViewController, UITextFieldDelegate {
    
    private var nameTextField = UITextField()
    var segueDelegate: SegueDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        setup()
    }
    
    
    func setup(){
        let exitTap = UITapGestureRecognizer(target: self, action: #selector(self.exitIntroScreen))

        let introView = UIView(frame: view.frame)
        introView.tag = 512
        
        let backgroundImage = UIImage(named: "INTRO_BG")
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgroundImageView.image = backgroundImage
        introView.addSubview(backgroundImageView)
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.3))
        title.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.15)
        title.font = UIFont(name: "Inkfree", size: 49)
        title.text = "Reel Casters"
        title.textColor = UIColor.white
        title.textAlignment = .center
        introView.addSubview(title)
        
        let tfOverlay = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.8, height: view.frame.width * 0.8))
        tfOverlay.center = introView.center
        tfOverlay.alpha = 0.2
        tfOverlay.backgroundColor = UIColor.white
        tfOverlay.layer.cornerRadius = 20.0
        tfOverlay.layer.masksToBounds = true
        introView.addSubview(tfOverlay)
        
        let enterTeamName = UILabel(frame: CGRect(x: 0, y: 0, width: tfOverlay.frame.width, height: tfOverlay.frame.height * 0.2))
        enterTeamName.center = CGPoint(x: tfOverlay.center.x, y: tfOverlay.center.y - tfOverlay.frame.height * 0.23)
        enterTeamName.font = UIFont(name: "Inkfree", size: 28)
        enterTeamName.text = "Enter your team name"
        enterTeamName.textAlignment = .center
        enterTeamName.textColor = UIColor.white
        introView.addSubview(enterTeamName)
        
        let tfBackgroundImage = UIImage(named:"INTRO_BAR")
        let tfBackgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: introView.frame.width * 0.6, height: introView.frame.height * 0.065))
        tfBackgroundImageView.image = tfBackgroundImage
        tfBackgroundImageView.center = CGPoint(x: introView.center.x, y: introView.center.y + 20)
        introView.addSubview(tfBackgroundImageView)
        
        
        let continueButtonOverlay = UIView(frame: CGRect(x: 0, y: 0, width: tfOverlay.frame.width, height: view.frame.height * 0.075))
        continueButtonOverlay.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.9)
        continueButtonOverlay.backgroundColor = UIColor.white
        continueButtonOverlay.alpha = 0.2
        continueButtonOverlay.layer.cornerRadius = 12.0
        continueButtonOverlay.layer.masksToBounds = true
        continueButtonOverlay.tag = 92
        continueButtonOverlay.addGestureRecognizer(exitTap)
        continueButtonOverlay.isUserInteractionEnabled = true
        introView.addSubview(continueButtonOverlay)
        
        let teamLabel = UILabel(frame: CGRect(x: 0, y: 0, width: introView.frame.width * 0.13, height: introView.frame.height * 0.065))
        teamLabel.center = CGPoint(x: introView.frame.width * 0.315, y: introView.center.y + 20)
        teamLabel.text = "Team"
        teamLabel.font = UIFont(name: "Inkfree", size: 22)
        teamLabel.adjustsFontSizeToFitWidth = true
        teamLabel.textColor = UIColor.white
        teamLabel.textAlignment = .center
        introView.addSubview(teamLabel)
        
        let continueButtonText = UILabel(frame: continueButtonOverlay.frame)
        continueButtonText.text = "Continue"
        continueButtonText.font = UIFont(name: "Inkfree", size: 24)
        continueButtonText.textColor = UIColor.white
        continueButtonText.textAlignment = .center
        continueButtonText.tag = 92
        continueButtonText.addGestureRecognizer(exitTap)
        continueButtonText.isUserInteractionEnabled = true
        introView.addSubview(continueButtonText)
        
        nameTextField = UITextField(frame: CGRect(x: 0, y: 0, width: introView.frame.width * 0.3, height: introView.frame.height * 0.065))
        nameTextField.center = CGPoint(x: introView.frame.width * 0.6, y: introView.center.y + 20)
        nameTextField.returnKeyType = UIReturnKeyType.done
        nameTextField.adjustsFontSizeToFitWidth = true
        nameTextField.textColor = UIColor.white
        nameTextField.textAlignment = .center
        nameTextField.font = UIFont(name: "Inkfree", size: 30)
        nameTextField.minimumFontSize = 10.0
        nameTextField.delegate = self
        let defaults = UserDefaults.standard
        let team = defaults.string(forKey: "teamName") ?? ""
        nameTextField.text = team
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        nameTextField.isUserInteractionEnabled = true
        introView.addSubview(nameTextField)
        
        view.addSubview(introView)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (textField.text!.count > 10) {
            textField.deleteBackward()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
    }
    
    @objc func exitIntroScreen(){
        if(nameTextField.text == ""){
            let alert = UIAlertController(title: "Whoops", message: "Please enter a team name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            segueDelegate?.exitIntro(time: 0.5, newName: nameTextField.text!, introVC: self)
        }
    }
}
