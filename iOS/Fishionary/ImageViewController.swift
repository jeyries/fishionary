//
//  ImageViewController.swift
//  Fishionary
//
//  Created by Julien on 04/01/16.
//  Copyright © 2016 jeyries. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var doneButton: UIButton!
    
    @IBOutlet private weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet private weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet private weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet private weak var imageConstraintBottom: NSLayoutConstraint!
    
    private var lastZoomScale: CGFloat = -1
    
    var image: UIImage? {
        didSet {
            // Update the view.
            //updateZoom()
            print("image: \(image)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.delegate = self
        imageView.image = image
        updateZoom()
        updateConstraints()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    */
    
    /*
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    */
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.LandscapeLeft
    }
    
    // Update zoom scale and constraints with animation.
    @available(iOS 8.0, *)
    override func viewWillTransitionToSize(size: CGSize,
        withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
            
            super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
            
            coordinator.animateAlongsideTransition({ [weak self] _ in
                self?.updateZoom()
                }, completion: nil)
    }
    
    //
    // Update zoom scale and constraints with animation on iOS 7.
    //
    // DEPRECATION NOTICE:
    //
    // This method is deprecated in iOS 8.0 and it is here just for iOS 7.
    // You can safely remove this method if you are not supporting iOS 7.
    // Or if you do support iOS 7 you can leave it here as it will be ignored by the newer iOS versions.
    //
    /*
    override func willAnimateRotationToInterfaceOrientation(
        toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
            
            super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
            updateZoom()
    }
    */
    
    func updateConstraints() {
        if let image = imageView.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            let viewWidth = scrollView.bounds.size.width
            let viewHeight = scrollView.bounds.size.height
            
            // center image if it is smaller than the scroll view
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }
            
            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }
            
            imageConstraintLeft.constant = hPadding
            imageConstraintRight.constant = hPadding
            
            imageConstraintTop.constant = vPadding
            imageConstraintBottom.constant = vPadding
            
            view.layoutIfNeeded()
        }
    }
    
    // Zoom to show as much image as possible unless image is smaller than the scroll view
    private func updateZoom() {
        if let image = imageView.image {
            var minZoom = min(scrollView.bounds.size.width / image.size.width,
                scrollView.bounds.size.height / image.size.height)
            
            if minZoom > 1 { minZoom = 1 }
            
            scrollView.minimumZoomScale = minZoom
            
            // Force scrollViewDidZoom fire if zoom did not change
            if minZoom == lastZoomScale { minZoom += 0.000001 }
            
            scrollView.zoomScale = minZoom
            lastZoomScale = minZoom
        }
    }
    
    @IBAction func onDoneButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // UIScrollViewDelegate
    // -----------------------
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraints()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }


}
