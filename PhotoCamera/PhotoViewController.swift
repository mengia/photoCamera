//
//  PhotoViewController.swift
//  PhotoCamera
//
//  Created by Mengistayehu Mamo on 3/19/16.
//  Copyright © 2016 Mengistayehu Mamo. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView:UIImageView!
    
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
       let leftconstraits = NSLayoutConstraint(item: imageView, attribute:.Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0)
        leftconstraits.active = true
        
        let rightConstraints = NSLayoutConstraint(item: imageView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0)
          rightConstraints.active = true
        
        let topConstriants = NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0)
          topConstriants.active = true
        
        let bottomConstraits = NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0)
           bottomConstraits.active = true
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: AnyObject) {
        
        guard let imageSave = image else{
            return
        }
        UIImageWriteToSavedPhotosAlbum(imageSave, nil, nil, nil)
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
