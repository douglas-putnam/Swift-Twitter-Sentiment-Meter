//
//  ViewController.swift
//  TWTR Sentimeter
//
//  Created by Douglas Putnam on 1/11/19.
//  Copyright © 2019 Douglas Putnam. All rights reserved.
//

import CoreML
import SwifteriOS
import UIKit

class ViewController: UIViewController {

    // PARAMETERS
    
    // MARK: SWIFTER PARAMETERS
    
    // Instantiation using Twitter's OAuth Consumer Key and secret
    let swifter = Swifter(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET)
    var searchString = "@Apple"
    
    // MARK: CORE ML PARAMETERS
    
    let classifier = sentimentClassifier()
    
    // MARK: UI PARAMETERS
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emojiView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - METHODS
    // MARK: VIEW CONTROLLER METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        swifter.searchTweet(using: searchString, lang: "en", resultType: "recent", count: 100, tweetMode: .extended, success: {(results, metadata) in
            print(results)
        }) { (error) in
            print("There was an error while processing your search: \(error)")
        }
        
//        swifter.searchTweet(using: <#T##String#>, geocode: <#T##String?#>, lang: <#T##String?#>, locale: <#T##String?#>, resultType: <#T##String?#>, count: <#T##Int?#>, until: <#T##String?#>, sinceID: <#T##String?#>, maxID: <#T##String?#>, includeEntities: <#T##Bool?#>, callback: <#T##String?#>, tweetMode: <#T##TweetMode#>, success: <#T##Swifter.SearchResultHandler?##Swifter.SearchResultHandler?##(JSON, JSON) -> Void#>, failure: <#T##Swifter.FailureHandler##Swifter.FailureHandler##(Error) -> Void#>)
    }
    

    func predict(text: String) -> String {
        do {
            let result = try classifier.prediction(text: "I love @Apple")
            return result.label
        } catch {
            print("Failed to generate prediction for \(text). Error details: \(error)")
        }
        return ""
    }

    

    @IBAction func predictTapped(_ sender: Any) {
    }
}

