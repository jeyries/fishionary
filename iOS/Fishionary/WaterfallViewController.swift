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

final class WaterfallViewController: UIViewController, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    let objects = DataManager.shared.filterAnyLanguage(search: nil)

    var collectionView : UICollectionView!
    var didSelect : ((Fish) -> ())!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .red
        

        let button = UIBarButtonItem(barButtonSystemItem: .done,target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = button
        
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        layout.headerHeight = 0 //15;
        layout.footerHeight = 0 //10;
        layout.minimumColumnSpacing = 20;
        layout.minimumInteritemSpacing = 30;
        layout.columnCount = 2
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = .white
        
        collectionView.register(WaterfallCell.self, forCellWithReuseIdentifier: CELL_IDENTIFIER)
        collectionView.register(WaterfallHeader.self, forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader, withReuseIdentifier:HEADER_IDENTIFIER)
        collectionView.register(WaterfallFooter.self, forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter, withReuseIdentifier:FOOTER_IDENTIFIER)
        

         self.view.addSubview(self.collectionView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateLayoutForOrientation(orientation: UIApplication.shared.statusBarOrientation)
        //updateLayoutForSize(...)
    }

    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        super.willAnimateRotation(to: toInterfaceOrientation, duration: duration)
        updateLayoutForOrientation(orientation: toInterfaceOrientation)
    }
    
    func updateLayoutForOrientation(orientation: UIInterfaceOrientation) {
        let layout = collectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        layout.columnCount = orientation.isPortrait ? 2 : 3;
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
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        print("willTransitionToTraitCollection: \(newCollection)")
        if newCollection.containsTraits(in: UITraitCollection(verticalSizeClass: .regular)) {
            
        }
    }
    
    
    @objc func done(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER, for: indexPath as IndexPath) as! WaterfallCell
        
        // Configure the cell
        let result = objects[indexPath.row]
        cell.configure(fish: result.fish)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        
        if (kind == CHTCollectionElementKindSectionHeader) {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_IDENTIFIER, for: indexPath)
        } else if (kind == CHTCollectionElementKindSectionFooter) {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FOOTER_IDENTIFIER, for: indexPath)
        }
        
        return reusableView!;
    }
    
    // MARK - CHTCollectionViewDelegateWaterfallLayout
    
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath?) -> CGSize {
        
        let result = objects[indexPath!.row]
        return result.fish.imageSize()
    }
    
    // MARK - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let didSelect = didSelect {
            let result = objects[indexPath.row]
            didSelect( result.fish )
        }
    }
  
}
