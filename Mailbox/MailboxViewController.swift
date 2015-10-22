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
    
    @IBOutlet weak var yellowSliderImageView: UIImageView! // reschedule
    @IBOutlet weak var brownSliderImageView: UIImageView!
    @IBOutlet weak var messageImageView: UIImageView!
    
    var messageImageOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messageImageOriginalCenter = messageImageView.center
        
        scrollView.contentSize = CGSize(width: feedImageView.image!.size.width, height: helpImageView.image!.size.height+searchImageView.image!.size.height+feedImageView.image!.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onPanMessage(sender: UIPanGestureRecognizer) {

        let point = sender.locationInView(scrollView)
        let translation = sender.locationInView(scrollView)

        print("panning: sender \(point)")
        if sender.state == UIGestureRecognizerState.Began {
//            print("Gesture began at: \(point)")
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            if (
            // move the message Image with pan
            messageImageView.center = CGPoint(x: messageImageOriginalCenter.x+sender.translationInView(scrollView).x, y: messageImageOriginalCenter.y)
            
//            print("Gesture changed at: \(point)")
        } else if sender.state == UIGestureRecognizerState.Ended {
            

            print("Gesture ended at: \(translation)")
        }
    }
}
