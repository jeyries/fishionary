//
//  WaterfallViewController.swift
//  Fishionary
//
//  Created by Julien on 04/01/16.
//  Copyright © 2016 jeyries. All rights reserved.
//

import UIKit
//import CHTCollectionViewWaterfallLayout


final class WaterfallViewController: UIViewController {
    
    var images = [String]()
    var didSelect: ((Int) -> ())?
    
    override func loadView() {
        self.view = collectionView
    }

    private lazy var layout: UICollectionViewLayout = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        layout.headerHeight = 0 //15;
        layout.footerHeight = 0 //10;
        layout.minimumColumnSpacing = 20;
        layout.minimumInteritemSpacing = 30;
        layout.columnCount = 2
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = .white
        collectionView.register(WaterfallCell.self, forCellWithReuseIdentifier: "WaterfallCell")
        return collectionView
    }()
    
}

// MARK: UICollectionViewDataSource
extension WaterfallViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaterfallCell", for: indexPath as IndexPath) as! WaterfallCell
        let imagePath = images[indexPath.row]
        cell.configure(imagePath: imagePath)
        return cell
    }
}

// MARK: CHTCollectionViewDelegateWaterfallLayout

extension WaterfallViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let imagePath = images[indexPath.row]
        return ImageLoader.shared.loadSize(path: imagePath)
    }
    
    // MARK - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?( indexPath.row )
    }
  
}

private class WaterfallCell: UICollectionViewCell {
    
    private var imageOperation: Operation?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.contentView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(imagePath: String) {
        imageOperation?.cancel()
        imageView.image = nil
        imageOperation = ImageLoader.shared.load(path: imagePath) { [weak self] image in
            self?.imageView.image = image
        }
    }

}
