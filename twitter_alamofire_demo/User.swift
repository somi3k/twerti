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

class User {
  
  var name: String
  var screenName: String
  var id: Int64
  var id_str: String
  var location: String  //nullable
  var description: String  //nullable
  var url: String  //nullable
  var protected: Bool
  var verified: Bool
  var followers_count: Int
  var friends_count: Int
  var listed_count: Int
  var favourites_count: Int
  var statuses_count: Int
  var created_at: String
  var time_zone: String
  var profile_background_color: String
  var profile_background_image_url: String
  var profile_background_image_url_https: String
  var profile_background_tile: Bool
  var profile_banner_url: String
  var profile_image_url_https: String
  var profile_link_color: String
  var profile_sidebar_border_color: String
  var profile_sidebar_fill_color: String
  var profile_text_color: String
  var profile_use_background_image: Bool
  var default_profile: Bool
  var default_profile_image: Bool
  
  // For user persistance
  var dictionary: [String: Any]?
  private static var _current: User?
  static var current: User? {
    get {
      if _current == nil {
        let defaults = UserDefaults.standard
        if let userData = defaults.data(forKey: "currentUserData") {
          let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
          _current = User(dictionary: dictionary)
        }
      }
      return _current
    }
    set (user) {
      _current = user
      let defaults = UserDefaults.standard
      if let user = user {
        let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
        defaults.set(data, forKey: "currentUserData")
      } else {
        defaults.removeObject(forKey: "currentUserData")
      }
    }
  }
  
  init(dictionary: [String: Any]) {
    self.dictionary = dictionary
    name = dictionary["name"] as! String
    screenName = dictionary["screen_name"] as! String
    id = dictionary["id"] as! Int64
    id_str = dictionary["id_str"] as! String
    location = dictionary["location"] as? String ?? ""  //nullable
    description = dictionary["description"] as? String ?? ""  //nullable
    url = dictionary["url"] as? String ?? "" //nullable
    protected = dictionary["protected"] as! Bool
    verified = dictionary["verified"] as! Bool
    followers_count = dictionary["followers_count"] as! Int
    friends_count = dictionary["friends_count"] as! Int
    listed_count = dictionary["listed_count"] as! Int
    favourites_count = dictionary["favourites_count"] as! Int
    statuses_count = dictionary["statuses_count"] as! Int
    created_at = dictionary["created_at"] as! String
    time_zone = dictionary["time_zone"] as? String ?? ""
    profile_background_color = dictionary["profile_background_color"] as! String
    profile_background_image_url = dictionary["profile_background_image_url"] as? String ?? ""
    profile_background_image_url_https = dictionary["profile_background_image_url_https"] as? String ?? ""
    profile_background_tile = dictionary["profile_background_tile"] as! Bool
    profile_banner_url = dictionary["profile_banner_url"] as? String ?? ""
    profile_image_url_https = dictionary["profile_image_url_https"] as? String ?? ""
    profile_link_color = dictionary["profile_link_color"] as! String
    profile_sidebar_border_color = dictionary["profile_sidebar_border_color"] as! String
    profile_sidebar_fill_color = dictionary["profile_sidebar_fill_color"] as! String
    profile_text_color = dictionary["profile_text_color"] as! String
    profile_use_background_image = dictionary["profile_use_background_image"] as! Bool
    default_profile = dictionary["default_profile"] as! Bool
    default_profile_image = dictionary["default_profile_image"] as! Bool
  }
}
