//
//  Helper.swift
//  Sarrafi
//
//  Created by armin on 1/23/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import UIKit

// MARK: - Share Text Function
func shareText(text: String, viewController: UIViewController) {
    // set up activity view controller
    let textToShare = [text]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = viewController.view // so that iPads won't crash
    
    // exclude some activity types from the list (optional)
    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
    
    // present the view controller
    viewController.present(activityViewController, animated: true, completion: nil)
}

extension UIViewController {
    open override func awakeFromNib() {
        super.awakeFromNib()
        navigationController?.view.semanticContentAttribute = .forceRightToLeft
        navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
    }
}

extension String {
  
  public func replaceFirst(of pattern:String, with replacement:String) -> String {
    
    if let range = self.range(of: pattern) {
        return self.replacingCharacters(in: range, with: replacement)
    } else {
        return self
    }
  }
  
  public func replaceAll(of pattern:String, with replacement:String, options: NSRegularExpression.Options = []) -> String {
    do {
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(0..<self.utf16.count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replacement)
    } catch {
        NSLog("replaceAll error: \(error)")
        return self
    }
  }
  
}
