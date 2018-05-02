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


protocol ComposeViewControllerDelegate {
  func did(post: Tweet)
}


class ComposeViewController: UIViewController, UITextViewDelegate {
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet var tweetTextView: UITextView!
  @IBOutlet var countLabel: UILabel!
  
  var delegate: ComposeViewControllerDelegate?
  
  override func viewDidLoad() {
    tweetTextView.delegate = self
    
    tweetTextView.becomeFirstResponder()
    usernameLabel.text = String("@" + (User.current?.screenName)!)
    nameLabel.text = User.current?.name
    let placeholderImage = #imageLiteral(resourceName: "profile-Icon")
    let filter = AspectScaledToFillSizeFilter(size: profileImageView.frame.size)
    profileImageView.af_setImage(withURL: URL(string: (User.current!.profile_image_url_https))!, placeholderImage: placeholderImage, filter: filter, imageTransition: .crossDissolve(0.1))
    super.viewDidLoad()
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let characterLimit = 280
    let newText = NSString(string: tweetTextView.text!).replacingCharacters(in: range, with: text)
    countLabel.text = String(280 - newText.count)
    return newText.count < characterLimit
    
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func didTweet(_ sender: Any) {
    APIManager.shared.composeTweet(with: tweetTextView.text) { (tweet, error) in
      if let error = error {
        print("Error composing Tweet: \(error.localizedDescription)")
      } else if let tweet = tweet {
        self.delegate?.did(post: tweet)
        print("Compose Tweet Success!")
      }
    }
    didCancel(self)
  }
  
  
  
  @IBAction func didCancel(_ sender: Any) {
    dismiss(animated: true, completion: nil)
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
