//
//  Tweet.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation

class Tweet {
  
  var created_at: String
  var id: Int64
  var id_str: String
  var text: String
  var source: String
  var truncated: Bool
  var in_reply_to_status_id: Int64 //nullable
  var in_reply_to_status_id_str: String //nullable
  var in_reply_to_user_id: Int64 //nullable
  var in_reply_to_user_id_str: String //nullable
  var in_reply_to_screen_name: String //nullable
  var user: User
  var quoted_status_id: Int64
  var quoted_status_id_str: String
  var is_quote_status: Bool
  var quoted_status: Tweet
  var retweeted_status: Tweet
  var quote_count: Int //nullable
  var reply_count: Int
  var retweet_count: Int
  var favorite_count: Int //nullable
  var favorited: Bool //nullable
  var retweeted: Bool

    init(dictionary: [String: Any]) {
      var dictionary = dictionary
      
      // Is this a re-tweet?
      if let originalTweet = dictionary["retweeted_status"] as? [String: Any] {
        let userDictionary = dictionary["user"] as! [String: Any]
        self.retweetedByUser = User(dictionary: userDictionary)
        
        // Change tweet to original tweet
        dictionary = originalTweet
      }
      
        id = dictionary["id"] as! Int64
        text = dictionary["text"] as! String
        favoriteCount = dictionary["favorite_count"] as? Int
        favorited = dictionary["favorited"] as? Bool
        retweetCount = dictionary["retweet_count"] as! Int
        retweeted = dictionary["retweeted"] as! Bool
        
        let user = dictionary["user"] as! [String: Any]
        self.user = User(dictionary: user)
        
        let createdAtOriginalString = dictionary["created_at"] as! String
        let formatter = DateFormatter()
        // Configure the input format to parse the date string
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        // Convert String to Date
        let date = formatter.date(from: createdAtOriginalString)!
        // Configure output format
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        // Convert Date to String
        createdAtString = formatter.string(from: date)
        
        
    }
}

