//
//  ViewController.swift
//  TWTR Sentimeter
//
//  Created by Douglas Putnam on 1/11/19.
//  Copyright © 2019 Douglas Putnam. All rights reserved.
//

import CoreML
import SwifteriOS
import SwiftyJSON
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // PARAMETERS
    
    // MARK: SWIFTER PARAMETERS
    
    // Instantiation using Twitter's OAuth Consumer Key and secret
    let swifter = Swifter(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET)
    
    // MARK: CORE ML PARAMETERS
    
    let classifier = sentimentClassifier()
    
    // MARK: UI PARAMETERS
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - METHODS
    // MARK: VIEW CONTROLLER METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emojiLabel.text = "🤓"
        textField.delegate = self
    }
    
    // MARK: SCORE TEXT
    func score(sentimentSearch: String) {
        // query twitter api
        swifter.searchTweet(using: sentimentSearch, lang: "en", resultType: "recent", count: 100, tweetMode: .extended, success: {(results, metadata) in
            var tweets = [sentimentClassifierInput]()
            
            // extract tweet strings out of JSON results
            for i in 0...99 {
                if let tweet = results[i]["full_text"].string {
                    let tweetForClassificaiton = sentimentClassifierInput(text: tweet)
                    tweets.append(tweetForClassificaiton)
                }
            }
            
            do {
                // predict sentiments for tweet strings
                let sentiments = try self.classifier.predictions(inputs: tweets)
                
                // score sentiments
                var sentimentScore = 0
                for sentiment in sentiments {
                    let text = sentiment.label
                    if text == "Pos" {
                        sentimentScore += 1
                        print("pos")
                    } else if text == "Neg" {
                        sentimentScore += -1
                        print("neg")
                    } else {
                        print("neutral")
                    }
                }
                
                // update UI
                self.updateUI(with: sentimentScore)
                
            } catch {
                print("Failed to generate predictions. Error details: \(error)")
            }
            
        }) { (error) in
            print("There was an error while processing your search: \(error)")
        }
    }
    
    // Methods to update UI with new score
    func updateUI(with score: Int) {
        scoreLabel.text = "\(score)"
        
        switch score {
            case -100 ... -40: emojiLabel.text = "🤢"
            case -39 ... -20: emojiLabel.text = "😫"
            case -19 ... -10: emojiLabel.text = "😡"
            case -9 ... -5: emojiLabel.text = "🤨"
            case -4 ... 4: emojiLabel.text = "😐"
            case 5 ... 14: emojiLabel.text = "🙂"
            case 15 ... 39: emojiLabel.text = "😀"
            case 40 ... 100: emojiLabel.text = "🤩"
            default: emojiLabel.text = "😶"
        }
    }

    // Call method when user taps 'predict sentiment' button
    @IBAction func predictTapped(_ sender: Any) {
        if let searchText = textField.text {
            score(sentimentSearch: searchText)
        } else {
            descriptionLabel.text = "Enter text into the field below. Then press button."
        }
        
    }
}

