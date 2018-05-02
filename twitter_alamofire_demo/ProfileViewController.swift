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

class ProfileViewController: UIViewController {
  
  var currentUser: User!
  
  @IBOutlet var profileImage: UIImageView!
  @IBOutlet var profileBanner: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var followingCountLabel: UILabel!
  @IBOutlet var tweetCountLabel: UILabel!
  @IBOutlet var followersCountLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //currentUser = APIManager.shared.get
    // Do any additional setup after loading the view.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    nameLabel.text = String("@" + (User.current?.screenName)!)
    usernameLabel.text = User.current?.name
    followingCountLabel.text = String(User.current!.friends_count)
    followersCountLabel.text = String(User.current!.followers_count)
    tweetCountLabel.text = String(User.current!.statuses_count)
    print(User.current!.name)
    print(User.current!.profile_banner_url)
    print(User.current!.profile_background_image_url)
    print(User.current!.profile_image_url_https)

    let placeholderImage = #imageLiteral(resourceName: "profile-Icon")
    let bannerFilter = AspectScaledToFillSizeFilter(size: profileBanner.frame.size)
    
   // if (User.current?.profile_background_image_url_https) != nil {
  // profileBanner.af_setImage(withURL: URL(string: (User.current!.profile_background_image_url_https))!, placeholderImage: placeholderImage, filter: bannerFilter, imageTransition: .crossDissolve(0.1))
   // }
    
    let profileFilter = AspectScaledToFillSizeFilter(size: profileImage.frame.size)
    profileImage.af_setImage(withURL: URL(string: (User.current!.profile_image_url_https))!, placeholderImage: placeholderImage, filter: profileFilter, imageTransition: .crossDissolve(0.1))
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}
