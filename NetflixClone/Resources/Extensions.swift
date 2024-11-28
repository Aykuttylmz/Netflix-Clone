//
//  Extensions.swift
//  NetflixClone
//
//  Created by Aykut Türkyılmaz on 28.11.2024.
//

import UIKit


extension UIImage {
    
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}


