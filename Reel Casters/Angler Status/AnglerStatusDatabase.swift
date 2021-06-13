//
//  AnglerStatusDatabase.swift
//  FishingStatus
//
//  Created by Brendan Reese on 2/27/20.
//  Copyright © 2020 BrendanReese. All rights reserved.
//

import Foundation

class ASD{
    
    static let pounds: [Double] = [
        0.00,
        2.00,
        3.00,
        6.00,
        10.00,
        12.00,
        20.00,
        25.00,
        30.00,
        35.00,
        50.00,
        60.00
    ]
    static let fish: [String] = [
        "Minnow",
        "Bluegill",
        "Crappie",
        "Smallmouth Bass",
        "Carp",
        "Largemouth Bass",
        "Catfish",
        "Rainbow Trout",
        "Pike",
        "Koi",
        "Mahi Mahi",
        "Salmon"
    ]
    
    static func getFish(weight: Double) -> (String, String, String?, String?){
        var count = 0;
        while(count < fish.count - 1){
            let currentFish = fish[count]
            let fishPounds = pounds[count]
            let nextFish = fish[count + 1]
            let nextFishPounds = pounds[count + 1]
            
            //if weight < fishPounds && count == - { return (fish[0], "\(pounds[0])", fish[1], "\(pounds[1])")}
            if (weight > fishPounds && weight < nextFishPounds) || weight == fishPounds { return (currentFish, "\(fishPounds)", nextFish, "\(nextFishPounds)")}
            count += 1
        }
            
        return (fish[fish.count - 1], "\(pounds[pounds.count - 1])", nil, nil)
    }
}
