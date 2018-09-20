//
//  ImageProvider.swift
//  NetworkingPresidents
//
//  Created by Joshua Aaron Flores Stavedahl on 11/19/17.
//  Copyright © 2017 Northern Illinois University. All rights reserved.
//


import Foundation
import UIKit

class ImageProvider {

    /// Singleton property that can be used to access the ImageProvider object.
    static let sharedInstance = ImageProvider()
    
    /// Image cache.
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    /// Gets an image.
    ///
    /// - Parameter urlString: The url String.
    /// - Parameter completion: A closure to execute if the image is successfully obtained.
    func imageWithURLString(_ urlString: String, completion: @escaping (_ image: UIImage?) -> Void) {
    
        // If the image is stored in the cache, retrieve it.
        if urlString == "None" {
            completion(UIImage(named:"seal.png"))
        }
        else if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            completion(cachedImage)
        }
        else {
            weak var weakSelf = self
            
            let session = URLSession.shared
            
            if let url = URL(string: urlString) {
                let task = session.dataTask(with: url, completionHandler: {
                    (data, response, error) in
                    let httpResponse = response as? HTTPURLResponse
                    if httpResponse!.statusCode != 200 {
                        DispatchQueue.main.async {
                            print("HTTP Error: status code \(httpResponse!.statusCode).")
                            completion(UIImage(named: "seal.png"))
                        }
                    }
                    else if ( data == nil && error != nil ) {
                        DispatchQueue.main.async {
                            print("No image data downloaded for image \(urlString).")
                            completion(UIImage(named: "seal.png"))
                        }
                    }
                    else {
                        if let image = UIImage(data: data!) {
                            DispatchQueue.main.async {
                                weakSelf!.imageCache.setObject(image, forKey: urlString as AnyObject)
                                completion(image)
                            }
                        }
                    }
                })
                task.resume()
            }
            else {
                print("Invalid URL \(urlString).")
                completion(UIImage(named: "seal.png"))
            }
        }
    }
    
    func clearCache() {
     imageCache.removeAllObjects()
    }
}
