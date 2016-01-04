//
//  WaterfallViewController.swift
//  Fishionary
//
//  Created by Julien on 04/01/16.
//  Copyright © 2016 jeyries. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

private let CELL_IDENTIFIER = "WaterfallCell"
private let HEADER_IDENTIFIER = "WaterfallHeader"
private let FOOTER_IDENTIFIER = "WaterfallFooter"

class WaterfallViewController: UIViewController, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    let objects = DataManager.sharedInstance.filter("english", search: nil)

    var collectionView : UICollectionView!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.redColor()
        

        let button = UIBarButtonItem(barButtonSystemItem: .Done,target: self, action: "done:")
        self.navigationItem.rightBarButtonItem = button
        
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.headerHeight = 0 //15;
        layout.footerHeight = 0 //10;
        layout.minimumColumnSpacing = 20;
        layout.minimumInteritemSpacing = 30;
        layout.columnCount = 2
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = UIColor.whiteColor()
        
        collectionView.registerClass(WaterfallCell.self, forCellWithReuseIdentifier: CELL_IDENTIFIER)
        collectionView.registerClass(WaterfallHeader.self, forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader, withReuseIdentifier:HEADER_IDENTIFIER)
        collectionView.registerClass(WaterfallFooter.self, forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter, withReuseIdentifier:FOOTER_IDENTIFIER)
        

         self.view.addSubview(self.collectionView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateLayoutForOrientation(UIApplication.sharedApplication().statusBarOrientation)
        //updateLayoutForSize(...)
    }

    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        updateLayoutForOrientation(toInterfaceOrientation)
    }
    
    func updateLayoutForOrientation(orientation: UIInterfaceOrientation) {
        let layout = collectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
    }

    
    /*
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        print("size: \(size)")
        
        coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            let layout = self.collectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout
            let orientation = UIApplication.sharedApplication().statusBarOrientation
            
            switch orientation {
            case .Portrait:
                print("Portrait")
                layout.columnCount = 2
            default:
                print("Anything But Portrait")
                layout.columnCount = 3
            }
            
            }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
                print("rotation completed")
        })
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        //updateLayoutForSize(size)
    }
    */
    
    /*
    func updateLayoutForSize(size: CGSize) {
        let layout = collectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        layout.columnCount = size.width < 1024 ? 2 : 3;
    }
    */
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        print("willTransitionToTraitCollection: \(newCollection)")
        if newCollection.containsTraitsInCollection(UITraitCollection(verticalSizeClass: .Regular)) {
            
        }
    }
    
    
    func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return objects.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {                
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_IDENTIFIER, forIndexPath: indexPath) as! WaterfallCell
        
        // Configure the cell
        let fish = objects[indexPath.row]
        cell.imageView.image = fish.imageContent()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        
        if (kind == CHTCollectionElementKindSectionHeader) {
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: HEADER_IDENTIFIER, forIndexPath: indexPath)
        } else if (kind == CHTCollectionElementKindSectionFooter) {
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: FOOTER_IDENTIFIER, forIndexPath: indexPath)
        }
        
        return reusableView!;
    }
    
    // MARK - CHTCollectionViewDelegateWaterfallLayout
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        
        let fish = objects[indexPath.row]
        return fish.imageSize()
    }
  
}
