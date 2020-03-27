//
//  ImageLoader.swift
//  Fishionary
//
//  Created by Julien Eyries on 25/01/2019.
//  Copyright © 2019 jeyries. All rights reserved.
//

import UIKit


final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private let queue: OperationQueue
    private let imageCache = NSCache<NSString, UIImage>()
    
    private init() {
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
        queue.qualityOfService = .userInitiated
    }
    
    @discardableResult
    func load(path: String, completion: @escaping (UIImage?) -> Void) -> Operation {
        let operation = BlockOperation() { [weak self] in
            let image = self?.loadSynchronously(path: path)
            DispatchQueue.main.async {
                completion(image)
            }
        }
        operation.qualityOfService = .userInitiated
        queue.addOperation(operation)
        return operation
    }
    
    func loadSynchronously(path: String) -> UIImage? {
        if let image = imageCache.object(forKey: path as NSString) {
            return image
        }
        
        print("loading \(path)")
        guard let image = UIImage(contentsOfFile: path) else {
            return nil
        }
        
        imageCache.setObject(image, forKey: path as NSString)
        return image
    }
    
    func loadSize(path: String) -> CGSize {
        print("loadSize \(path)")
        guard let image = loadSynchronously(path: path) else { return .zero }
        return image.size
    }
    
    /*
    func loadSizeCGImage(path: String) -> CGSize {
        guard let image = CGImageSourceCreateWithURL(URL(fileURLWithPath: path) as CFURL, nil) else { return .zero }
        let _properties = CGImageSourceCopyPropertiesAtIndex(image, 0, nil)!
        let properties = _properties as NSDictionary
        let width = properties[kCGImagePropertyPixelWidth] as! Int
        let height = properties[kCGImagePropertyPixelHeight] as! Int
        return CGSize(width: width, height: height)
    }
    
    func loadSizeCIImage(path: String) -> CGSize {
        guard let image = CIImage(contentsOf: URL(fileURLWithPath: path)) else { return .zero }
        return image.extent.size
    }
    
    func loadSizeUIImage(path: String) -> CGSize {
        guard let image = UIImage(contentsOfFile: path) else { return .zero }
        return image.size
    }*/
    
    
}
