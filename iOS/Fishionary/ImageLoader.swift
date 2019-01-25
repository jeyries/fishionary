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
        
        guard let image = UIImage(contentsOfFile: path) else {
            return nil
        }
        
        imageCache.setObject(image, forKey: path as NSString)
        return image
    }
}
