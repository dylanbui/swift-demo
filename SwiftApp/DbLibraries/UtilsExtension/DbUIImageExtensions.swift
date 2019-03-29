//
//  DbUIImageExtensions.swift
//  PropzySam
//
//  Created by Dylan Bui on 8/28/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//  Base on : https://github.com/SwifterSwift/SwifterSwift/blob/master/Sources/Extensions/UIKit/UIImageViewExtensions.swift
//            https://raw.githubusercontent.com/SwifterSwift/SwifterSwift/master/Sources/Extensions/UIKit/UIImageExtensions.swift

import UIKit

// MARK: - Methods
public extension UIImageView {
    
    public func db_transition(toImage image: UIImage?) {
        UIView.transition(with: self, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.image = image
        }, completion: nil)
    }
    
    /// Set image from a URL.
    ///    If image size to large => dont cache
    /// - Parameters:
    ///   - url: URL of image.
    ///   - contentMode: imageView content mode (default is .scaleAspectFit).
    ///   - placeHolder: optional placeholder image
    ///   - cache: cache object
    ///   - completionHandler: optional completion handler to run when download finishs (default is nil).
    public func db_download(
        from url: URL,
        contentMode: UIViewContentMode? = nil, //  = .scaleAspectFill
        placeholder: UIImage? = nil,
        cache: URLCache = URLCache.shared,
        completionHandler: ((UIImage?) -> Void)? = nil) {
        
        if let placeholder = placeholder {
            self.image = placeholder
        }

        if let contentMode = contentMode {
            self.contentMode = contentMode
        }
        
        // -- Get from cache --
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.db_transition(toImage: image)
                completionHandler?(image)
            }
            return
        }
        // -- Get from URL --
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
                else {
                    completionHandler?(nil)
                    return
            }
            
            // -- Save to cache --
            let cachedData = CachedURLResponse(response: httpURLResponse, data: data)
            cache.storeCachedResponse(cachedData, for: request)

            DispatchQueue.main.async {
                self.db_transition(toImage: image)
                completionHandler?(image)
            }
            }.resume()
    }
    
    /// SwifterSwift: Make image view blurry
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    public func db_blur(withStyle style: UIBlurEffectStyle = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        addSubview(blurEffectView)
        clipsToBounds = true
    }
    
    /// SwifterSwift: Blurred version of an image view
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    /// - Returns: blurred version of self.
    public func db_blurred(withStyle style: UIBlurEffectStyle = .light) -> UIImageView {
        let imgView = self
        imgView.db_blur(withStyle: style)
        return imgView
    }
    
    public func db_changeImage(_ toImage: UIImage?, duration: CFTimeInterval = 0.3) -> Void {
        UIView.transition(with: self,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: { self.image = toImage },
                          completion: nil)
    }

    
}

// MARK: - Properties
public extension UIImage {
    
    /// SwifterSwift: Size in bytes of UIImage
    public var bytesSize: Int {
        return UIImageJPEGRepresentation(self, 1)?.count ?? 0
    }
    
    /// SwifterSwift: Size in kilo bytes of UIImage
    public var kilobytesSize: Int {
        return bytesSize / 1024
    }
    
    /// SwifterSwift: UIImage with .alwaysOriginal rendering mode.
    public var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    /// SwifterSwift: UIImage with .alwaysTemplate rendering mode.
    public var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
}

// MARK: - Methods
public extension UIImage {
    
    /// SwifterSwift: Compressed UIImage from original UIImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
    /// - Returns: optional UIImage (if applicable).
    public func db_compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = db_compressedData(quality: quality) else { return nil }
        return UIImage(data: data)
    }
    
    /// SwifterSwift: Compressed UIImage data from original UIImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
    /// - Returns: optional Data (if applicable).
    public func db_compressedData(quality: CGFloat = 0.5) -> Data? {
        return UIImageJPEGRepresentation(self, quality)
    }
    
    /// SwifterSwift: UIImage Cropped to CGRect.
    ///
    /// - Parameter rect: CGRect to crop UIImage to.
    /// - Returns: cropped UIImage
    public func db_cropped(to rect: CGRect) -> UIImage {
        guard rect.size.height < size.height && rect.size.height < size.height else { return self }
        guard let image: CGImage = cgImage?.cropping(to: rect) else { return self }
        return UIImage(cgImage: image)
    }
    
    /// SwifterSwift: UIImage scaled to height with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toHeight: new height.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    public func db_scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, 0)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// SwifterSwift: UIImage scaled to width with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toWidth: new width.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    public func db_scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, 0)
        draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// SwifterSwift: UIImage filled with color
    ///
    /// - Parameter color: color to fill image with.
    /// - Returns: UIImage filled with given color.
    public func db_filled(withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = self.cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// SwifterSwift: UIImage tinted with color
    ///
    /// - Parameters:
    ///   - color: color to tint image with.
    ///   - blendMode: how to blend the tint
    /// - Returns: UIImage tinted with given color.
    public func db_tint(_ color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        context!.clip(to: drawRect, mask: cgImage!)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
    
    /// SwifterSwift: UIImage with rounded corners
    ///
    /// - Parameters:
    ///   - radius: corner radius (optional), resulting image will be round if unspecified
    /// - Returns: UIImage with all corners rounded
    public func db_withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public func db_cropCenterToSize(_ targetSize :CGSize) -> UIImage
    {
        // https://stackoverflow.com/questions/32041420/cropping-image-with-swift-and-put-it-on-center-position
        
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSize(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}

// MARK: - Initializers
public extension UIImage {
    
    /// SwifterSwift: Create UIImage from color and size.
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    public convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        
        self.init(cgImage: aCgImage)
    }
    
}


