//
//  WaterfallViewController.swift
//  Fishionary
//
//  Created by Julien on 04/01/16.
//  Copyright © 2016 jeyries. All rights reserved.
//

import UIKit
//import CHTCollectionViewWaterfallLayout
//import struct Kingfisher.LocalFileImageDataProvider
import Kingfisher

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
    
    private func provider(at indexPath: IndexPath ) -> ImageDataProvider {
        let path = images[indexPath.row]
        let url = URL(fileURLWithPath: path)
        return LocalFileImageDataProvider(fileURL: url)
    }
}

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

extension WaterfallViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let imagePath = images[indexPath.row]
        //return UIImage(contentsOfFile: imagePath)?.size ?? .zero
        
        let provider = self.provider(at: indexPath)
 
        var image: UIImage?

        //let group = DispatchGroup()
        //group.enter()
        
        let cache = ImageCache.default
        cache.retrieveImage(forKey:  provider.cacheKey, callbackQueue: .mainCurrentOrAsync) { result in
            switch result {
                case .success(let value):
                    image = value.image

                case .failure(let error):
                    print(error)
            }
            //group.leave()
        }
        
        //group.wait()
        
        if image == nil {
            image = UIImage(contentsOfFile: imagePath)
            if let image = image {
                cache.store(image, forKey: provider.cacheKey)
            }
        }
        
        return image?.size ?? .zero
    }
}

extension WaterfallViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?( indexPath.row )
    }
}

extension WaterfallViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let sources = indexPaths.map { Source.provider(self.provider(at: $0)) }
        ImagePrefetcher(sources: sources).start()
    }
}

private class WaterfallCell: UICollectionViewCell {
    
    
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
        let url = URL(fileURLWithPath: imagePath)
        let provider = LocalFileImageDataProvider(fileURL: url)
        imageView.kf.setImage(with: provider)
    }

}
