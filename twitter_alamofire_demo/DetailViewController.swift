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

import UIKit
import AlamofireImage
import DateToolsSwift

class DetailViewController: UIViewController, UITextViewDelegate {
  
  
  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var createdAtLabel: UILabel!
  @IBOutlet var tweetTextView: UITextView!
  @IBOutlet var retweetCount: UILabel!
  @IBOutlet var favoriteCount: UILabel!
  @IBOutlet var retweetButton: UIButton!

  @IBOutlet var favButton: UIButton!
  
  var tweet: Tweet!
  
  override func viewDidLoad() {
    refreshData()
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func didTapRetweet(_ sender: Any) {
    if tweet.retweeted! {
      tweet.retweeted = false
      tweet.retweet_count -= 1
      refreshData()
      APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
        if let  error = error {
          print("Error unretweeting tweet: \(error.localizedDescription)")
        } else if let tweet = tweet {
          print("Successfully unretweeted the following Tweet: \n\(String(describing: tweet.text))")
        }
      }
    }
    else {
      tweet.retweeted = true
      tweet.retweet_count += 1
      refreshData()
      APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
        if let  error = error {
          print("Error retweeting tweet: \(error.localizedDescription)")
        } else if let tweet = tweet {
          print("Successfully retweeted the following Tweet: \n\(String(describing: tweet.text))")
        }
      }
    }  }
  
  
  @IBAction func didTapFavorite(_ sender: Any) {
    if tweet.favorited! {
      tweet.favorited = false
      tweet.favorite_count -= 1
      refreshData()
      APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
        if let  error = error {
          print("Error unfavoriting tweet: \(error.localizedDescription)")
        } else if let tweet = tweet {
          print("Successfully unfavorited the following Tweet: \n\(String(describing: tweet.text))")
        }
      }
    }
    else {
      tweet.favorited = true
      tweet.favorite_count += 1
      refreshData()
      APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
        if let  error = error {
          print("Error favoriting tweet: \(error.localizedDescription)")
        } else if let tweet = tweet {
          print("Successfully favorited the following Tweet: \n\(String(describing: tweet.text))")
        }
      }
    }
    
  }
  
  //Update UI with tweet parameters
  func refreshData() {
    if tweet.favorited! {
      favButton.setImage(#imageLiteral(resourceName: "favor-icon-red.png"), for: .normal)
    }
    else {
      favButton.setImage(#imageLiteral(resourceName: "favor-icon.png"), for: .normal)
    }
    if tweet.retweeted! {
      retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green.png"), for: .normal)
    }
    else {
      retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon.png"), for: .normal)
    }
    
    //Format textview for clickable links
    tweetTextView.isEditable = false
    tweetTextView.dataDetectorTypes = UIDataDetectorTypes.all
    tweetTextView.text = tweet.text
    tweetTextView.isScrollEnabled = false
    tweetTextView.sizeToFit()
    
    createdAtLabel.text = tweet.createdAtString
    nameLabel.text = tweet.user?.name
    usernameLabel.text = String("@" + (tweet.user?.screenName)!)
    retweetCount.text = formatNumber(number: tweet.retweet_count)
    favoriteCount.text = formatNumber(number: tweet.favorite_count)
    
    let placeholderImage = #imageLiteral(resourceName: "profile-Icon")
    let filter = AspectScaledToFillSizeFilter(size: profileImageView.frame.size)
    profileImageView.af_setImage(withURL: URL(string: (self.tweet.user?.profile_image_url_https)!)!, placeholderImage: placeholderImage, filter: filter, imageTransition: .crossDissolve(0.1))
  }
  
  func formatNumber(number: Int) -> String {
    let formatter = NumberFormatter()
    formatter.groupingSeparator = ","
    formatter.numberStyle = .decimal
    return formatter.string(from: NSNumber(value:number))!
  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
