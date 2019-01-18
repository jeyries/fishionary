//
//  ImageViewController.swift
//  Fishionary
//
//  Created by Julien on 04/01/16.
//  Copyright © 2016 jeyries. All rights reserved.
//

import UIKit

final class ImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var doneButton: UIButton!
    
    @IBOutlet private weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet private weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet private weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet private weak var imageConstraintBottom: NSLayoutConstraint!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2
        imageView.image = image
        updateZoom()

    }
    
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        
        updateZoom()

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
    */
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    // Update zoom scale and constraints with animation.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.updateZoom()
            }, completion: nil)
    }
    
    func updateConstraints() {
        guard let image = imageView.image else { return }
            
        print("-- updateConstraints --")
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let viewWidth = scrollView.bounds.size.width
        let viewHeight = scrollView.bounds.size.height
        
        print("image: \(Int(imageWidth)) x \(Int(imageHeight))")
        print("scrollView: \(Int(viewWidth)) x \(Int(viewHeight))")
        print("zoomScale: \(String(format:"%.3f", scrollView.zoomScale))")
        print("image x zoomScale: \(Int(scrollView.zoomScale * imageWidth)) x \(Int(scrollView.zoomScale * imageHeight))")
        
        
        // center image if it is smaller than the scroll view
        let hPadding = max(0, (viewWidth - scrollView.zoomScale * imageWidth) / 2)
        let vPadding = max(0, (viewHeight - scrollView.zoomScale * imageHeight) / 2)
        
        print("padding: \(Int(hPadding)) x \(Int(vPadding))")
        
        imageConstraintLeft.constant = hPadding
        imageConstraintRight.constant = hPadding
        
        imageConstraintTop.constant = vPadding
        imageConstraintBottom.constant = vPadding
        
        view.layoutIfNeeded()
        
    }
    
    // Zoom to show as much image as possible unless image is smaller than the scroll view
    private func updateZoom() {
        guard let image = imageView.image else { return }
            
        print("-- updateZoom --")
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let viewWidth = scrollView.bounds.size.width
        let viewHeight = scrollView.bounds.size.height
   
        print("image: \(Int(imageWidth)) x \(Int(imageHeight))")
        print("scrollView: \(Int(viewWidth)) x \(Int(viewHeight))")
        
        let minZoom = min(1, min(viewWidth / imageWidth,
            viewHeight / imageHeight))
        
        print(String(format:"minZoom: %.3f", minZoom))
        
        scrollView.minimumZoomScale = minZoom
        scrollView.zoomScale = minZoom
        
        updateConstraints()
    }
    
    @IBAction func onDoneButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // UIScrollViewDelegate
    // -----------------------
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }


}
