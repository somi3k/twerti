/// Copyright (c) 2018 Somi Singh
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import DateToolsSwift

class Tweet {
  
  var created_at: String?
  var createdAtString: String?
  var id: Int64?
  var id_str: String?
  var text: String?
  var source: String?
  var truncated: Bool?
  var in_reply_to_status_id: Int64? //nullable
  var in_reply_to_status_id_str: String? //nullable
  var in_reply_to_user_id: Int64? //nullable
  var in_reply_to_user_id_str: String? //nullable
  var in_reply_to_screen_name: String? //nullable
  var user: User?
  var quoted_status_id: Int64?
  var quoted_status_id_str: String?
  var is_quote_status: Bool?
  var quoted_status: Tweet?
  var retweeted_status: Tweet?
  var quote_count: Int? //nullable
  var reply_count: Int
  var retweet_count: Int
  var favorite_count: Int //nullable
  var favorited: Bool? //nullable
  var retweeted: Bool?
  
  var retweetedByUser: User?
  
  init(dictionary: [String: Any]) {
    var dictionary = dictionary
    //print(dictionary)
    // Is this a re-tweet?
    if let originalTweet = dictionary["retweeted_status"] as? [String: Any] {
      let userDictionary = dictionary["user"] as! [String: Any]
      self.retweetedByUser = User(dictionary: userDictionary)
      // Change tweet to original tweet
      dictionary = originalTweet
    }
    
    id = dictionary["id"] as? Int64
    id_str = dictionary["id_str"] as? String
    
    text = dictionary["text"] as? String
    source = dictionary["source"] as? String
    truncated = dictionary["truncated"] as? Bool
    in_reply_to_status_id = dictionary["in_reply_to_status_id"] as? Int64 ?? -1 //nullable
    in_reply_to_status_id_str = dictionary["in_reply_to_status_id_str"] as? String ?? "-1" //nullable
    in_reply_to_user_id = dictionary["in_reply_to_user_id"] as? Int64 ?? -1 //nullable
    in_reply_to_user_id_str = dictionary["in_reply_to_user_id_str"] as? String ?? "-1" //nullable
    in_reply_to_screen_name = dictionary["in_reply_to_screen_name"] as? String ?? "-1" //nullable
    quoted_status_id = dictionary["quoted_status_id"] as? Int64
    quoted_status_id_str = dictionary["quoted_status_id_str"] as? String
    is_quote_status = dictionary["is_quote_status"] as? Bool
    quoted_status = dictionary["quoted_status"] as? Tweet
    retweeted_status = dictionary["retweeeted_status"] as? Tweet
    quote_count = dictionary["quote_count"] as? Int ?? 0 //nullable
    reply_count = dictionary["reply_count"] as? Int ?? 0
    retweet_count = dictionary["retweet_count"] as! Int
    favorite_count = dictionary["favorite_count"] as? Int ?? 0 //nullable
    favorited = dictionary["favorited"] as? Bool ?? false //nullable
    retweeted = dictionary["retweeted"] as? Bool
    
    let user = dictionary["user"] as! [String: Any]
    self.user = User(dictionary: user)
    
    let createdAtOriginalString = dictionary["created_at"] as! String
    let formatter = DateFormatter()
    // Configure the input format to parse the date string
    formatter.dateFormat = "E MMM d HH:mm:ss Z y"
    // Convert String to Date
    let date = formatter.date(from: createdAtOriginalString)!
    createdAtString = Date.timeAgo(since: date)
  }
  
  
  static func tweets(with array: [[String: Any]]) -> [Tweet] {
    var tweets: [Tweet] = []
    for tweetDictionary in array {
      let tweet = Tweet(dictionary: tweetDictionary)
      tweets.append(tweet)
    }
    return tweets
  }
}

