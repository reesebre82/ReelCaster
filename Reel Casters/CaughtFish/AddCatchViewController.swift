//
//  AddCatchViewController.swift
//  Reel Casters
//
//  Created by Brendan Reese on 3/5/20.
//  Copyright © 2020 BrendanReese. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase


class AddCatchViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var addCatchDelegate: AddCatchDelegate?
    var isDropDownMenuMonthActive = false
    var isDropDownMenuDayActive = false
    var dropDownMonthView = UIView()
    var dropDownDayView = UIView()
    var monthTitle = UILabel()
    var isMonthDropDownOpen = false
    var isDayDropDownOpen = false
    
    var monthButton = UIButton()
    var dayButton = UIButton()
    var weightField = UITextField()
    
    var addPhotoButton = UIButton()
    
    var catchAdded = false
    
    let imagePicker = UIImagePickerController()
    var photoAdded = false
    
    var clearxButton = UIButton()
    var clearxBackground = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAll))
        view.addGestureRecognizer(tap)
        view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addHeader()
        addContent()
        
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.view.layer.zPosition = 3
    }
    
    func addHeader(){
        let backgroundHeaderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.1))
        backgroundHeaderImageView.image = UIImage(named: "AddCatchTitleBar")
        view.addSubview(backgroundHeaderImageView)
        
        let headerText = UILabel(frame: backgroundHeaderImageView.frame)
        headerText.text = "Add Catch"
        headerText.font = UIFont(name: "Inkfree", size: 25)//UPDATE SIZE
        headerText.textAlignment = .center
        headerText.textColor = .black
        backgroundHeaderImageView.addSubview(headerText)
        
        let xButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.09, height: view.frame.width * 0.09))
        xButton.center = CGPoint(x: view.frame.width * 0.9, y:  backgroundHeaderImageView.frame.height / 2)
        xButton.setImage(UIImage(named: "xIcon"), for: .normal)
        xButton.backgroundColor = UIColor.white
        xButton.layer.cornerRadius = xButton.bounds.width / 2
        xButton.layer.masksToBounds = true
        xButton.addTarget(self, action: #selector(segueExit(_:)), for: .touchUpInside)
        view.addSubview(xButton)
    }
    
    func addContent(){
        
        var sizeHeight = view.frame.height * 0.1
        if hasNotch(){
            sizeHeight = view.frame.height * 0.075
        }
        
        let dropDownIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.0275, height: view.frame.width * 0.0225))
        dropDownIcon.image = UIImage(named: "dropDownTriangle")
        
        let date = Date()
        monthButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.4, height: sizeHeight))
        monthButton.center = CGPoint(x: view.frame.width * 0.275, y: view.frame.height * 0.2)
        monthButton.backgroundColor = UIColor(red:0.88, green:0.97, blue:1.00, alpha:1.0)
        
        monthTitle = UILabel(frame: CGRect(x: monthButton.frame.width * 0.15, y: 0, width: monthButton.frame.width - monthButton.frame.width * 0.15, height: monthButton.frame.height))
        monthTitle.text = date.month
        monthTitle.textColor = .black
        monthTitle.font = UIFont(name: "Inkfree", size: 20)
        monthTitle.textAlignment = .center
        monthTitle.layer.zPosition = 2
        monthButton.addSubview(monthTitle)
        
        monthButton.layer.cornerRadius = 15.0
        monthButton.layer.zPosition = 2
        monthButton.layer.masksToBounds = true
        monthButton.addTarget(self, action: #selector(dropDownMonth), for: .touchUpInside)
        
        dropDownIcon.center = CGPoint(x: monthButton.frame.width * 0.15, y: monthButton.frame.height * 0.5)
        dropDownIcon.layer.zPosition = 2
        monthButton.addSubview(dropDownIcon)
        view.addSubview(monthButton)
        
        let dropDown2 = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.0275, height: view.frame.width * 0.0225))
        dropDown2.image = UIImage(named: "dropDownTriangle")
        dropDown2.layer.zPosition = 2
        
        dayButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.4, height: sizeHeight))
        dayButton.center = CGPoint(x: view.frame.width * 0.725, y: view.frame.height * 0.2)
        dayButton.backgroundColor = UIColor(red:0.88, green:0.97, blue:1.00, alpha:1.0)
        var day = date.day
        if day[0] == "0"{
            day = "\(day[1])"
        }
        dayButton.setTitle(day, for: .normal)
        dayButton.setTitleColor(.black, for: .normal)
        dayButton.titleLabel?.font = UIFont(name: "Inkfree", size: 20)
        dayButton.layer.cornerRadius = 15.0
        dayButton.layer.masksToBounds = true
        dayButton.addTarget(self, action: #selector(dropDownDay), for: .touchUpInside)
        dayButton.layer.zPosition = 2
        
        dropDown2.center = CGPoint(x: dayButton.frame.width * 0.15, y: dayButton.frame.height * 0.5)
        dayButton.addSubview(dropDown2)
        view.addSubview(dayButton)
        
        
        weightField = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.4, height: sizeHeight))
        weightField.center = CGPoint(x: view.frame.width * 0.275, y: monthButton.frame.maxY + 65)
        weightField.backgroundColor = UIColor(red:0.88, green:0.97, blue:1.00, alpha:1.0)
        weightField.font = UIFont(name: "Inkfree", size: 20)
        weightField.text = "0.0"
        weightField.textAlignment = .center
        weightField.keyboardType = .decimalPad
        weightField.textColor = UIColor.black
        weightField.addDoneToolbar()
        weightField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        weightField.layer.cornerRadius = 15.0
        weightField.layer.masksToBounds = true
        weightField.delegate = self
        
        view.addSubview(weightField)
        
        let weightLBS = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.25, height: sizeHeight))
        weightLBS.text = "Lbs"
        weightLBS.font = UIFont(name: "Inkfree", size: 20)
        weightLBS.frame.origin = CGPoint(x: weightField.frame.maxX + 25, y: weightField.frame.minY)
        
        
        view.addSubview(weightLBS)
        
        
        addPhotoButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.85, height: view.frame.height * 0.325))
        if hasNotch(){
            addPhotoButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.85, height: view.frame.height * 0.275))
        }
        addPhotoButton.setImage(UIImage(named: "addfishphoto"), for: .normal)
        addPhotoButton.center = CGPoint(x: view.frame.width / 2, y: weightField.frame.midY + 70 + (addPhotoButton.frame.height / 2))
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        addPhotoButton.layer.cornerRadius = 15.0
        
        view.addSubview(addPhotoButton)
        
        let reelInButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.85, height: sizeHeight))
        reelInButton.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.9)
        reelInButton.setTitle("Reel In", for: .normal)
        reelInButton.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        reelInButton.layer.cornerRadius = 12.0
        reelInButton.setTitleColor(.black, for: .normal)
        reelInButton.titleLabel?.font = UIFont(name: "Inkfree", size: 22)
        reelInButton.layer.masksToBounds = true
        reelInButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        view.addSubview(reelInButton)
    }
    
    @objc func addPhoto(){
        closeAll()
        
        view.addSubview(imagePicker.view)

                       
        imagePicker.view.frame = CGRect(x: view.frame.minX, y: view.frame.height * 2, width: view.frame.width, height: view.frame.height)
        imagePicker.view.alpha = 1
        
        UIView.animate(withDuration: 0.5,
                       animations: { () -> Void in
                        self.imagePicker.view.frame = CGRect(x: self.view.frame.minX, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        },completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage

        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }

        // do something interesting here!
        print(newImage.size)

        self.clearPhoto()
        self.photoAdded = true
        let imageView = UIImageView(image: newImage)
        imageView.tag = 55
        let ratio = self.addPhotoButton.frame.width/newImage.size.width
        let scaledHeight = imageView.frame.height * ratio
        imageView.frame.size = CGSize(width: self.addPhotoButton.frame.width, height: scaledHeight)
        self.addPhotoButton.addSubview(imageView)
        
        let offset = self.addPhotoButton.frame.width * 0.075
        
        self.clearxButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.06, height: self.view.frame.width * 0.06))
        self.clearxButton.center = CGPoint(x: self.addPhotoButton.frame.maxX - offset , y:  self.addPhotoButton.frame.minY + offset)
        self.clearxButton.setImage(UIImage(named: "xIcon"), for: .normal)
        self.clearxButton.backgroundColor = UIColor.white
        self.clearxButton.layer.cornerRadius = self.clearxButton.bounds.width / 2
        self.clearxButton.layer.masksToBounds = true
        self.clearxButton.addTarget(self, action: #selector(self.clearPhoto), for: .touchUpInside)
        self.view.addSubview(self.clearxButton)
        
        self.clearxBackground = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.1, height: self.view.frame.width * 0.1))
        self.clearxBackground.center = CGPoint(x: self.addPhotoButton.frame.maxX - offset , y:  self.addPhotoButton.frame.minY + offset)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.clearPhoto))
        self.clearxBackground.addGestureRecognizer(tap)
        self.view.addSubview(self.clearxBackground)
        
        let imagePicker = picker
        view.addSubview(imagePicker.view)

    
        imagePicker.view.alpha = 1
        
        UIView.animate(withDuration: 0.5,
                       animations: { () -> Void in
                        imagePicker.view.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.height * 2, width: self.view.frame.width, height: self.view.frame.height)
        },completion:{
            void in
            self.imagePicker.view.removeFromSuperview()
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.view.alpha = 1
        
        UIView.animate(withDuration: 0.5,
                       animations: { () -> Void in
                        self.imagePicker.view.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.height * 2, width: self.view.frame.width, height: self.view.frame.height)
        },completion:nil)
    }
    
    @objc func clearPhoto(){
        photoAdded = false
        for view in addPhotoButton.subviews{
            if view.tag == 55{ view.removeFromSuperview() }
        }
        addPhotoButton.setImage(UIImage(named: "addfishphoto"), for: .normal)
        clearxButton.removeFromSuperview()
        clearxBackground.removeFromSuperview()
    }
    
    
    @objc func dropDownMonth(){
        closeDropDownDay()
        dropDownMonthView = UIView(frame: CGRect(x: monthButton.frame.minX, y: monthButton.frame.midY, width: monthButton.frame.width, height: view.frame.height * 0.6))
        dropDownMonthView.backgroundColor = UIColor(red:0.07, green:0.36, blue:0.46, alpha:1.0)
        dropDownMonthView.layer.zPosition = 1
        dropDownMonthView.layer.cornerRadius = 12.0
        dropDownMonthView.layer.masksToBounds = true
        view.addSubview(dropDownMonthView)
        
        let height = dropDownMonthView.frame.height / 14
        let months = [
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"
        ]
        
        for i in 0..<12{
            let x = 0
            let y = height * (CGFloat(i) + CGFloat(1.5))
            let button = UIButton(frame: CGRect(x: CGFloat(x), y: y, width: dropDownMonthView.frame.width, height: height))
            button.setTitle(months[i], for: .normal)
            button.titleLabel?.font = UIFont(name: "Inkfree", size: 20)
            button.addTarget(self, action: #selector(newMonth(sender:)), for: .touchUpInside)
            dropDownMonthView.addSubview(button)
        }
    }
    
    @objc func newMonth(sender: UIButton){
        monthTitle.text = sender.title(for: .normal) ?? "Error"
        closeDropDownMonth()
    }
    
    @objc func dropDownDay(){
        closeDropDownMonth()
        dropDownDayView = UIView(frame: CGRect(x: dayButton.frame.minX, y: dayButton.frame.midY, width: dayButton.frame.width, height: view.frame.height * 0.6))
        dropDownDayView.backgroundColor = UIColor(red:0.07, green:0.36, blue:0.46, alpha:1.0)
        dropDownDayView.layer.zPosition = 1
        dropDownDayView.layer.cornerRadius = 12.0
        dropDownDayView.layer.masksToBounds = true
        view.addSubview(dropDownDayView)
        
        
        let height = dropDownDayView.frame.height / 14
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: dropDownDayView.frame.width, height: dropDownDayView.frame.height))
        scrollView.contentSize = CGSize(width: dropDownDayView.frame.width, height: height * 33)
        
        for i in 1...31{
            let x = 0
            let y = height * (CGFloat(i) + CGFloat(0.5))
            let button = UIButton(frame: CGRect(x: CGFloat(x), y: y, width: dropDownDayView.frame.width, height: height))
            button.setTitle("\(i)", for: .normal)
            button.titleLabel?.font = UIFont(name: "Inkfree", size: 20)
            button.addTarget(self, action: #selector(newDay(sender:)), for: .touchUpInside)
            scrollView.addSubview(button)
        }
        
        dropDownDayView.addSubview(scrollView)
    }
    
    @objc func newDay(sender: UIButton){
        dayButton.setTitle(sender.title(for: .normal) ?? "Error", for: .normal)
        closeDropDownDay()
    }
    
    @objc func closeDropDownMonth(){
        dropDownMonthView.removeFromSuperview()
    }
    
    @objc func closeDropDownDay(){
        dropDownDayView.removeFromSuperview()
    }
    
    @objc func closeAll(){
        closeDropDownDay()
        closeDropDownMonth()
        view.endEditing(true)
    }
    
    @objc func segueExit(_ sender: UIButton){
        addCatchDelegate?.exitAddCatch(didChange: catchAdded)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text != ""{
            let lastChar = textField.text!.last!
            let temp = textField.text!.dropLast()
            if lastChar == "." {
                if temp.contains(".") {
                    textField.text = "\(temp)"
                }
                else{
                    textField.text = "\(temp)\(lastChar)"
                }
            }
            if(temp == "0.0"){
                textField.text = "\(lastChar)"
            }
            if(textField.text!.first == "."){
                textField.text = "0\(textField.text!)"
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != ""{
            if !textField.text!.contains(".") {
                textField.text = "\(textField.text!).00"
            }
            let value = textField.text!.doubleValue
            textField.text = "\(value.rounded(toPlaces: 2))"
            
        }
    }
    
    @objc func submit(){
        closeAll()
        let uuid = UUID().uuidString
        let name = UserDefaults.standard.string(forKey: "teamName")
        let year = Date().year
        let month = monthTitle.text!
        let day = dayButton.title(for: .normal)
        let weight = weightField.text!
        if weight == "0.0" || weight == ""{
            print("You is dumb dumb")
            return
        }
        
        print("-------")
        print(uuid)
        print(name!)
        print("\(month)/\(day!)/\(year)")
        print(weight)
        print("-------")
        
        if photoAdded {
            var imageToUpload = UIImage()
            for case let view as UIImageView in addPhotoButton.subviews{
                if view.tag == 55{ imageToUpload = view.image ?? UIImage() }
            }
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let fishImagesRef = storageRef.child("fishImages")
            let finalRef = fishImagesRef.child("/\(uuid).jpg")
            let data: Data = imageToUpload.jpegData(compressionQuality: 1)!
            print("putting data")
            _ = finalRef.putData(data, metadata: nil) { (metadata, error) in
                if error != nil{
                    print(error?.localizedDescription)
                    return
                }
            
                let db = Firestore.firestore()
                
                db.collection("User").document(name!).collection("catches").document(uuid).setData([
                    "day" : day!,
                    "month" : month,
                    "year" : year,
                    "weight" : weight,
                    "photoURL" : "true"
                ]){ err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        self.catchAdded = true
                        self.segueExit(UIButton())
                    }
                }
            }
        } else {
            let db = Firestore.firestore()
            
            db.collection("User").document(name!).collection("catches").document(uuid).setData([
                "day" : day!,
                "month" : month,
                "year" : year,
                "weight" : weight,
                "photoURL" : "false"
            ]){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    self.catchAdded = true
                    self.segueExit(UIButton())
                }
            }
        }
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
