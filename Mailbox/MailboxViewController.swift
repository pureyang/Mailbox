//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Yang Tang on 10/21/15.
//  Copyright © 2015 Yang Tang. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var helpImageView: UIImageView!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var feedImageView: UIImageView!
    
    @IBOutlet weak var laterIconImageView: UIImageView!
    @IBOutlet weak var archiveIconImageView: UIImageView!
    @IBOutlet weak var messageBackgroundImageView: UIImageView!

    @IBOutlet weak var messageImageView: UIImageView!
    
    @IBOutlet weak var rescheduleMenuImageView: UIImageView!
    
    @IBOutlet weak var mainContentView: UIView!
    
    var messageImageOriginalCenter: CGPoint!
    var laterIconOriginalCenter : CGPoint!
    var archiveIconOriginalCenter : CGPoint!
    var deletedStateScrollY : CGFloat!

    var mainContentViewOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messageImageOriginalCenter = messageImageView.center
        laterIconOriginalCenter = laterIconImageView.center
        archiveIconOriginalCenter = archiveIconImageView.center
        mainContentViewOriginalCenter = mainContentView.center
        
        deletedStateScrollY = helpImageView.image!.size.height + searchImageView.image!.size
        .height+feedImageView.image!.size.height
        
        scrollView.contentSize = CGSize(width: feedImageView.image!.size.width, height: helpImageView.image!.size.height+searchImageView.image!.size.height+feedImageView.image!.size.height)
        
        resetBackgroundImages()
        
        
        // add edge gesture
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        mainContentView.addGestureRecognizer(edgeGesture)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onPanMessage(sender: UIPanGestureRecognizer) {

        let translation = sender.translationInView(scrollView)
        let velocity = sender.velocityInView(scrollView)

        let listimage = UIImage(named: "list_icon.png")
        let delimage = UIImage(named: "delete_icon.png")
        let laterIconImage = UIImage(named: "later_icon.png")
        let archiveIconImage = UIImage(named: "archive_icon.png")
        
        if sender.state == UIGestureRecognizerState.Began {
            //print ("start icon center.x = \(laterIconImageView.center.x)")
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            // move the message Image with pan
            messageImageView.center = CGPoint(x: messageImageOriginalCenter.x+sender.translationInView(scrollView).x, y: messageImageOriginalCenter.y)

            let archiveIconX = archiveIconOriginalCenter.x+(translation.x-60)
            let laterIconX = laterIconOriginalCenter.x+(translation.x+60)
            if (translation.x < -260) {

                laterIconImageView.image = listimage
                messageBackgroundImageView.backgroundColor = UIColor.brownColor()
                
                // keep moving icon
                laterIconImageView.center = CGPoint(x: laterIconX, y: laterIconImageView.center.y)
                
                // hide the other side's icon
                archiveIconImageView.alpha = 0.0
            } else if (translation.x > 260) {
                archiveIconImageView.image = delimage
                messageBackgroundImageView.backgroundColor = UIColor.redColor()
                
                // keep icon moving
                archiveIconImageView.center = CGPoint(x: archiveIconX, y: laterIconImageView.center.y)
                
                // hide the other side's icon
                laterIconImageView.alpha = 0.0
            } else if (translation.x < -60) {
                //  pan left turn yellow
                messageBackgroundImageView.backgroundColor = UIColor.orangeColor()
                laterIconImageView.image = laterIconImage
                
                // keep icon moving
                laterIconImageView.center = CGPoint(x: laterIconX, y: laterIconImageView.center.y)
            } else if (translation.x > 60) {
                //  pan right turn green
                messageBackgroundImageView.backgroundColor = UIColor.greenColor()
                archiveIconImageView.image = archiveIconImage

                // keep icon moving
                archiveIconImageView.center = CGPoint(x: archiveIconX, y: laterIconImageView.center.y)
            }
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            if (velocity.x < 0) {
                // panning left for later
               // print("panning left ended velocity = \(velocity.x) translation = \(translation.x)")
                if ( translation.x >= -260) {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.messageImageView.center = self.messageImageOriginalCenter
                        }, completion: { (finished) -> Void in
                            self.resetBackgroundImages()
                    })
                } else {
                    // animate message away left
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.messageImageView.center = CGPoint(x: -500, y: self.messageImageOriginalCenter.y)
                        }, completion: { (finished) -> Void in
                            // show archive view
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                                            self.rescheduleMenuImageView.alpha = 1.0
                                })
                    })
                    
                    // also fade out icon
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.laterIconImageView.alpha = 0.0
                    })

                }
            } else {
                // panning right for archive
                //print("panning right ended velocity = \(velocity.x) translation = \(translation.x)")
                if ( translation.x <= 260) {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.messageImageView.center = self.messageImageOriginalCenter
                        }, completion: { (finished) -> Void in
                            self.resetBackgroundImages()
                    })
                } else {
                    // animate message away right
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.messageImageView.center = CGPoint(x: 500, y: self.messageImageOriginalCenter.y)
                        }, completion: { (finished) -> Void in
                            // scroll up past message
                            UIView.animateWithDuration(0.2, animations: { () -> Void in
                                self.scrollView.contentOffset.y = 160}
                                , completion: { (finished) -> Void in
                                    self.resetBackgroundImages()
                            })
                    })
                    
                    // also fade out icon
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.archiveIconImageView.alpha = 0.0
                    })

                }
            }
        }
    }
    
    func resetBackgroundImages() {
        // reset position and background images of the scrolling back ground images
        messageBackgroundImageView.backgroundColor = UIColor.lightGrayColor()
        
        laterIconImageView.center = laterIconOriginalCenter
        archiveIconImageView.center = archiveIconOriginalCenter
        messageImageView.center = messageImageOriginalCenter
        
        let laterIconImage = UIImage(named: "later_icon.png")
        laterIconImageView.image = laterIconImage
        laterIconImageView.alpha = 1.0
        
        let archiveIconImage = UIImage(named: "archive_icon.png")
        archiveIconImageView.image = archiveIconImage
        archiveIconImageView.alpha = 1.0
        
        rescheduleMenuImageView.alpha = 0.0
    }
    
    @IBAction func onTapReschedule(sender: UITapGestureRecognizer) {
        resetBackgroundImages()
    }

    func onEdgePan (sender: UIGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Changed {
            mainContentView.center = CGPoint(x: mainContentViewOriginalCenter.x+sender.locationInView(view).x, y: mainContentViewOriginalCenter.y)
        } else if sender.state == UIGestureRecognizerState.Ended {
            // TODO detect which edge it is close to, finish close or open of menu
        
        }
    }

    

}
