//
//  User.swift
//  Twerti
//
//  Created by Somi Singh on 3/15/2018.
//  Copyright © 2018 Somi Singh. All rights reserved.
//

import Foundation

class User {
  
  static var current: User?
  var name: String
  var screenName: String
  var id: String
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
  
  
  init(dictionary: [String: Any]) {
    name = dictionary["name"] as! String
    screenName = dictionary["screen_name"] as! String
    id = dictionary["id"] as! String
    location = dictionary["location"] as? String ?? ""  //nullable
    description = dictionary["description"] as? String ?? ""  //nullable
    url = dictionary["url"] as? String ?? "" //nullable
    protected = dictionary["protected"] as! Bool
    verified = dictionary["verified"] as! Bool
    followers_count = dictionary["followers_count"] as! Int
    friends_count = dictionary["friends_count"] as! Int
    listed_count = dictionary["listed_count"] as! Int
    favourites_count = dictionary["favourites_count"] as! Int
    statuses_count = dictionary["statues_count"] as! Int
    created_at = dictionary["created_at"] as! String
    time_zone = dictionary["time_zone"] as! String
    profile_background_color = dictionary["profile_background_color"] as! String
    profile_background_image_url_https = dictionary["profile_background_image_url_https"] as! String
    profile_background_tile = dictionary["profile_background_tile"] as! Bool
    profile_banner_url = dictionary["profile_banner_url"] as! String
    profile_image_url_https = dictionary["profile_image_url_https"] as! String
    profile_link_color = dictionary["profile_link_color"] as! String
    profile_sidebar_border_color = dictionary["profile_sidebar_border_color"] as! String
    profile_sidebar_fill_color = dictionary["profile_sidebar_fill_color"] as! String
    profile_text_color = dictionary["profile_text_color"] as! String
    profile_use_background_image = dictionary["profile_use_background_image"] as! Bool
    default_profile = dictionary["default_profile"] as! Bool
    default_profile_image = dictionary["default_profile_image"] as! Bool
  }
}
