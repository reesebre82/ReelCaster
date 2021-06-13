//
//  Catch.swift
//  FishingStatus
//
//  Created by Brendan Reese on 2/25/20.
//  Copyright © 2020 BrendanReese. All rights reserved.
//


import UIKit
import Kingfisher
import FirebaseStorage

class Catch {
    
    let uuid:String
    let year:String
    let month:String
    let day:String
    let weight:String
    let requireImage:String
    
    init(uuid: String, year: String, month: String, day: String, weight: String, requireImage:String) {
        self.uuid = uuid
        self.year = year
        self.month = month
        self.day = day
        self.weight = weight
        self.requireImage = requireImage
    }
    
    func createPost(frame: CGRect, center: CGPoint) -> UIView{
        if requireImage == "true" { return createPostWithPhoto(frame: frame, center: center) }
        return createPostWithoutPhoto(frame: frame, center: center)
    }
    
    func createPostWithoutPhoto(frame: CGRect, center: CGPoint) -> UIView{
        let view = UIView(frame: frame)
        view.center = center
        view.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        view.layer.cornerRadius = 12.0
        view.layer.masksToBounds = true
        
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width * 0.4, height: frame.height))
        dateLabel.center = CGPoint(x: frame.width * 0.15, y: view.frame.height / 2)
        var fixedMonth = String(month.prefix(3))
        if fixedMonth == "Jun" {
            fixedMonth = "June"
        }
        if fixedMonth == "Jul" {
            fixedMonth = "July"
        }
        dateLabel.text = "\(fixedMonth) \(day)"
        dateLabel.textAlignment = .center
        dateLabel.textColor = UIColor.black
        dateLabel.font = UIFont(name: "Inkfree", size: 20)
        dateLabel.tag = 0
        view.addSubview(dateLabel)
        
        let weightLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width * 0.4, height: frame.height))
        weightLabel.center = CGPoint(x: frame.width * 0.725, y: view.frame.height / 2)
        weightLabel.text = "\(weight) lbs"
        weightLabel.textAlignment = .right
        weightLabel.textColor = UIColor.black
        weightLabel.font = UIFont(name: "Inkfree", size: 20)
        weightLabel.tag = 1
        view.addSubview(weightLabel)
        return view
    }
    
    func createPostWithPhoto(frame: CGRect, center: CGPoint) -> UIView{
        let view = UIImageView(frame: frame)
        view.center = center
        view.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        view.layer.cornerRadius = 12.0
        view.layer.masksToBounds = true
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fishImagesRef = storageRef.child("fishImages")
        let finalRef = fishImagesRef.child("/\(uuid).jpg")
        
        let defaultImage = UIImage(named: "FileNotFound")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.5, height: view.frame.width * 0.5))
        imageView.center = view.center
        
        view.addSubview(imageView)
        
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width * 0.4, height: frame.height))
        dateLabel.center = CGPoint(x: frame.width * 0.15, y: view.frame.height * 0.85)
        var fixedMonth = String(month.prefix(3))
        if fixedMonth == "Jun" {
            fixedMonth = "June"
        }
        if fixedMonth == "Jul" {
            fixedMonth = "July"
        }
        dateLabel.text = "\(fixedMonth) \(day)"
        dateLabel.textAlignment = .center
        dateLabel.textColor = UIColor.black
        dateLabel.font = UIFont(name: "Inkfree", size: 20)
        view.addSubview(dateLabel)
        
        let weightLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width * 0.4, height: frame.height))
        weightLabel.center = CGPoint(x: frame.width * 0.725, y: view.frame.height * 0.85)
        weightLabel.text = "\(weight) lbs"
        weightLabel.textAlignment = .right
        weightLabel.textColor = UIColor.black
        weightLabel.font = UIFont(name: "Inkfree", size: 20)
        view.addSubview(weightLabel)
        
        finalRef.downloadURL { url, error in
            if let error = error {
                // Handle any errors
                print("ERROR: \(error.localizedDescription)")
            } else {
                imageView.kf.setImage(with: url!, placeholder: defaultImage!){
                    result in
                    switch result {
                    case .success(let value):
                        imageView.frame.size = value.image.size
                        let ratio = view.frame.width/value.image.size.width
                        let scaledHeight = imageView.frame.height * ratio
                        imageView.frame.size = CGSize(width: view.frame.width, height: scaledHeight)
                        imageView.frame.origin = CGPoint(x: 0, y: 0)
                        
                        let averageColor = value.image.averageColor!
                        let threshold = (3 * 255) - 255
                        var colorOffsetFromBlack = 0
                        
                        colorOffsetFromBlack += averageColor.rgb()!.red
                        colorOffsetFromBlack += averageColor.rgb()!.green
                        colorOffsetFromBlack += averageColor.rgb()!.blue

                        if colorOffsetFromBlack > threshold {
                            dateLabel.textColor = UIColor.black
                            weightLabel.textColor = UIColor.black
                        } else {
                            dateLabel.textColor = UIColor.white
                            weightLabel.textColor = UIColor.white
                        }
                        
                    case .failure(let error):
                        print(error) // The error happens
                    }
                }
            }
        }
        
        return view
    }
}
