//
//  UIImageView+Spider.swift
//  Spider
//
//  Created by ooatuoo on 16/8/8.
//  Copyright © 2016年 oOatuo. All rights reserved.
//

import Foundation

private var activityIndicatorKey: Void?
private var showActivityIndicatorWhenLoadingKey: Void?

extension UIImageView {
    private var spider_activityIndicator: UIActivityIndicatorView? {
        return objc_getAssociatedObject(self, &activityIndicatorKey) as? UIActivityIndicatorView
    }
    
    private func spider_setActivityIndicator(activityIndicator: UIActivityIndicatorView?) {
        objc_setAssociatedObject(self, &activityIndicatorKey, activityIndicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public var spider_showActivityIndicatorWhenLoading: Bool {
        get {
            guard let result = objc_getAssociatedObject(self, &showActivityIndicatorWhenLoadingKey) as? NSNumber else {
                return false
            }
            
            return result.boolValue
        }
        
        set {
            if spider_showActivityIndicatorWhenLoading == newValue {
                return
                
            } else {
                
                if newValue {
                    
                    let indicatorStyle = UIActivityIndicatorViewStyle.Gray
                    let indicator = UIActivityIndicatorView(activityIndicatorStyle: indicatorStyle)
                    indicator.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
                    
                    indicator.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleBottomMargin, .FlexibleTopMargin]
                    indicator.hidden = true
                    indicator.hidesWhenStopped = true
                    
                    self.addSubview(indicator)
                    
                    spider_setActivityIndicator(indicator)
                    
                } else {
                    
                    spider_activityIndicator?.removeFromSuperview()
                    spider_setActivityIndicator(nil)
                }
                
                objc_setAssociatedObject(self, &showActivityIndicatorWhenLoadingKey, NSNumber(bool: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

// MARK: - AttachmentURL

private var imageURLKey: Void?

extension UIImageView {
    
    private var spider_imageKey: String? {
        return objc_getAssociatedObject(self, &imageURLKey) as? String
    }
    
    private func spider_setImageKey(key: String) {
        objc_setAssociatedObject(self, &imageURLKey, key, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func spider_setImageWith(info: PicInfo, completion: ((image: UIImage?) -> Void)? = nil) {
        
        let key = info.id
        
        let showActivityIndicatorWhenLoading = spider_showActivityIndicatorWhenLoading
        var activityIndicator: UIActivityIndicatorView? = nil
        
        if showActivityIndicatorWhenLoading {
            activityIndicator = spider_activityIndicator
            activityIndicator?.hidden = false
            activityIndicator?.startAnimating()
        }
        
        spider_setImageKey(key)
        
        SpiderImageCache.sharedInstance.imageWith(info) { [weak self] (key, image) in
            
            guard let sSelf = self, imageKey = sSelf.spider_imageKey where imageKey == key else {
                return
            }
            
            UIView.transitionWithView(sSelf, duration: 0.2, options: .TransitionCrossDissolve, animations: {
                
                sSelf.image = image
                
            }, completion: nil )

            info.image = image
            
            dispatch_async(dispatch_get_main_queue(), {
                
                completion?(image: image)
            })
            
            activityIndicator?.stopAnimating()
        }
    }
}

extension UIImageView {
    
    func resizeToFit(imageSize: CGSize) {
        
        let h = imageSize.height, w = imageSize.width
        let ratioH = h / kPicDetailH, ratioW = w / kScreenWidth, ratio = h / w
        
        if ratioH > ratioW {
            frame.size = CGSize(width: kPicDetailH / ratio, height: kPicDetailH)
        } else {
            frame.size = CGSize(width: kScreenWidth, height: kScreenWidth * ratio)
        }
    }
}