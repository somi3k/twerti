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
import Alamofire
import OAuthSwift
import OAuthSwiftAlamofire
import KeychainAccess

class APIManager: SessionManager {
  
  // MARK: TODO: Add App Keys
  static let consumerKey = "jZXZQv2e4CJwpaefCAn2zBQ7x"
  static let consumerSecret = "L5t5wl8Htb7x8VpWy5a7Vtz6iZZBRryfV0xBz86wF9SErsmRpa"
  
  static let requestTokenURL = "https://api.twitter.com/oauth/request_token"
  static let authorizeURL = "https://api.twitter.com/oauth/authorize"
  static let accessTokenURL = "https://api.twitter.com/oauth/access_token"
  
  static let callbackURLString = "alamoTwitter://"
  
  // MARK: Twitter API methods
  func login(success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
    
    // Add callback url to open app when returning from Twitter login on web
    let callbackURL = URL(string: APIManager.callbackURLString)!
    oauthManager.authorize(withCallbackURL: callbackURL, success: { (credential, _response, parameters) in
      
      // Save Oauth tokens
      self.save(credential: credential)
      
      self.getCurrentAccount(completion: { (user, error) in
        if let error = error {
          failure(error)
        } else if let user = user {
          print("Welcome \(user.name)")
          User.current = user
          success()
        }
      })
    }) { (error) in
      failure(error)
    }
  }
  
  func logout() {
    clearCredentials()
    User.current = nil
    NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
  }
  
  func getCurrentAccount(completion: @escaping (User?, Error?) -> ()) {
    request(URL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")!)
      .validate()
      .responseJSON { response in
        switch response.result {
        case .failure(let error):
          completion(nil, error)
          break;
        case .success:
          guard let userDictionary = response.result.value as? [String: Any] else {
            completion(nil, JSONError.parsing("Unable to create user dictionary"))
            return
          }
          completion(User(dictionary: userDictionary), nil)
        }
    }
  }
  
  func getHomeTimeLine(completion: @escaping ([Tweet]?, Error?) -> ()) {
    
    // This uses tweets from disk to avoid hitting rate limit. Comment out if you want fresh
    // tweets,
    /* if let data = UserDefaults.standard.object(forKey: "hometimeline_tweets") as? Data {
     let tweetDictionaries = NSKeyedUnarchiver.unarchiveObject(with: data) as! [[String: Any]]
     let tweets = tweetDictionaries.flatMap({ (dictionary) -> Tweet in
     Tweet(dictionary: dictionary)
     })
     
     completion(tweets, nil)
     return
     } */
    
    request(URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!, method: .get)
      .validate()
      .responseJSON { (response) in
        switch response.result {
        case .failure(let error):
          completion(nil, error)
          return
        case .success:
          guard let tweetDictionaries = response.result.value as? [[String: Any]] else {
            print("Failed to parse tweets")
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Failed to parse tweets"])
            completion(nil, error)
            return
          }
          
          let data = NSKeyedArchiver.archivedData(withRootObject: tweetDictionaries)
          UserDefaults.standard.set(data, forKey: "hometimeline_tweets")
          UserDefaults.standard.synchronize()
          
          let tweets = tweetDictionaries.flatMap({ (dictionary) -> Tweet in
            Tweet(dictionary: dictionary)
          })
          completion(tweets, nil)
        }
    }
  }
  
  func favorite(_ tweet: Tweet, completion: @escaping (Tweet?, Error?) -> ()) {
    let urlString = "https://api.twitter.com/1.1/favorites/create.json"
    let parameters = ["id": tweet.id]
    request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.queryString).validate().responseJSON { (response) in
      if response.result.isSuccess,
        let tweetDictionary = response.result.value as? [String: Any] {
        let tweet = Tweet(dictionary: tweetDictionary)
        completion(tweet, nil)
      } else {
        completion(nil, response.result.error)
      }
    }
  }
  
  func unfavorite(_ tweet: Tweet, completion: @escaping (Tweet?, Error?) -> ()) {
    let urlString = "https://api.twitter.com/1.1/favorites/destroy.json"
    let parameters = ["id": tweet.id]
    request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.queryString).validate().responseJSON { (response) in
      if response.result.isSuccess,
        let tweetDictionary = response.result.value as? [String: Any] {
        let tweet = Tweet(dictionary: tweetDictionary)
        completion(tweet, nil)
      } else {
        completion(nil, response.result.error)
      }
    }
  }
  
  func retweet(_ tweet: Tweet, completion: @escaping (Tweet?, Error?) -> ()) {
    let urlString = "https://api.twitter.com/1.1/statuses/retweet/" + tweet.id_str! + ".json"
    request(urlString, method: .post, encoding: URLEncoding.queryString).validate().responseJSON { (response) in
      if response.result.isSuccess,
        let tweetDictionary = response.result.value as? [String: Any] {
        let tweet = Tweet(dictionary: tweetDictionary)
        completion(tweet, nil)
      } else {
        completion(nil, response.result.error)
      }
    }
  }
  
  func unretweet(_ tweet: Tweet, completion: @escaping (Tweet?, Error?) -> ()) {
    let urlString = "https://api.twitter.com/1.1/statuses/unretweet/" + tweet.id_str! + ".json"
    request(urlString, method: .post, encoding: URLEncoding.queryString).validate().responseJSON { (response) in
      if response.result.isSuccess,
        let tweetDictionary = response.result.value as? [String: Any] {
        let tweet = Tweet(dictionary: tweetDictionary)
        completion(tweet, nil)
      } else {
        completion(nil, response.result.error)
      }
    }
  }
  
  func composeTweet(with text: String, completion: @escaping (Tweet?, Error?) -> ()) {
    let urlString = "https://api.twitter.com/1.1/statuses/update.json"
    let parameters = ["status": text]
    oauthManager.client.post(urlString, parameters: parameters, headers: nil, body: nil, success: { (response: OAuthSwiftResponse) in
      let tweetDictionary = try! response.jsonObject() as! [String: Any]
      let tweet = Tweet(dictionary: tweetDictionary)
      completion(tweet, nil)
    }) { (error: OAuthSwiftError) in
      completion(nil, error.underlyingError)
    }
  }
  
  
  // MARK: TODO: Get User Timeline
  
  
  //--------------------------------------------------------------------------------//
  
  
  //MARK: OAuth
  static var shared: APIManager = APIManager()
  
  var oauthManager: OAuth1Swift!
  
  // Private init for singleton only
  private init() {
    super.init()
    
    // Create an instance of OAuth1Swift with credentials and oauth endpoints
    oauthManager = OAuth1Swift(
      consumerKey: APIManager.consumerKey,
      consumerSecret: APIManager.consumerSecret,
      requestTokenUrl: APIManager.requestTokenURL,
      authorizeUrl: APIManager.authorizeURL,
      accessTokenUrl: APIManager.accessTokenURL
    )
    
    // Retrieve access token from keychain if it exists
    if let credential = retrieveCredentials() {
      oauthManager.client.credential.oauthToken = credential.oauthToken
      oauthManager.client.credential.oauthTokenSecret = credential.oauthTokenSecret
    }
    
    // Assign oauth request adapter to Alamofire SessionManager adapter to sign requests
    adapter = oauthManager.requestAdapter
  }
  
  // MARK: Handle url
  // OAuth Step 3
  // Finish oauth process by fetching access token
  func handle(url: URL) {
    OAuth1Swift.handle(url: url)
  }
  
  // MARK: Save Tokens in Keychain
  private func save(credential: OAuthSwiftCredential) {
    
    // Store access token in keychain
    let keychain = Keychain()
    let data = NSKeyedArchiver.archivedData(withRootObject: credential)
    keychain[data: "twitter_credentials"] = data
  }
  
  // MARK: Retrieve Credentials
  private func retrieveCredentials() -> OAuthSwiftCredential? {
    let keychain = Keychain()
    
    if let data = keychain[data: "twitter_credentials"] {
      let credential = NSKeyedUnarchiver.unarchiveObject(with: data) as! OAuthSwiftCredential
      return credential
    } else {
      return nil
    }
  }
  
  // MARK: Clear tokens in Keychain
  private func clearCredentials() {
    // Store access token in keychain
    let keychain = Keychain()
    do {
      try keychain.remove("twitter_credentials")
      
    } catch let error {
      print("error: \(error)")
    }
    print("keychain token removed..")
  }
}

enum JSONError: Error {
  case parsing(String)
}
