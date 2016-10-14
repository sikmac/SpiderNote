//
//  ArticleUndocBoxView.swift
//  Spider
//
//  Created by ooatuoo on 16/8/25.
//  Copyright © 2016年 auais. All rights reserved.
//

import UIKit

private let boxWidth    = kScreenWidth * 0.8
private let headID      = "ArticleUndocHeaderCell"
private let textCellID  = "ArticelUndocBoxTextCell"
private let picCellID   = "ArticelUndocBoxPicCell"
private let audioCellID = "ArticelUndocBoxAudioCell"

protocol ArticleUndocBoxDelegate: class {
    func didBeginToDragSeciton(section: SectionObject, layout: UndocBoxLayout, ges: UILongPressGestureRecognizer)
    func didChange(ges: UILongPressGestureRecognizer)
    func didEndDrag(location: CGPoint)
    func didQuitUndocBox()
}

class ArticleUndocBoxView: UIView {
    
    weak var articleDelegate: ArticleUndocBoxDelegate?
    
    private var layoutPool = UndocBoxLayoutPool()
    private var unDocItems = [[SectionObject]]()
    private var catchedView: UIImageView!

    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: boxWidth / 2, height: boxWidth / 2)
        layout.headerReferenceSize = CGSize(width: kBoxHeaderHeight, height: kBoxHeaderHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        if #available(iOS 9.0, *) {
            layout.sectionHeadersPinToVisibleBounds = true
        }
        
        let rect = CGRect(x: kScreenWidth - boxWidth, y: 40, width: boxWidth, height: kScreenHeight - kStatusBarHeight - 40)
        let view = UICollectionView(frame: rect, collectionViewLayout: layout)
        view.backgroundColor = UIColor.whiteColor()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private var toolBar: UIView = {
        let view = UIView(frame: CGRect(x: kScreenWidth - boxWidth, y: 0, width: boxWidth, height: 40))
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: boxWidth / 4, y: 0, width: boxWidth / 2, height: 40))
        label.text = "拖动碎片放入"
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.blackColor()
        label.textAlignment = .Center
        label.backgroundColor = UIColor.whiteColor()
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: 0, width: 40, height: 40))
        button.imageEdgeInsets = UIEdgeInsetsMake(11, 8, 11, 10)
        button.setImage(UIImage(named: "article_unbox_back"), forState: .Normal)
        button.addTarget(self, action: #selector(removeFromSuperview), forControlEvents: .TouchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: CGRect(x: kScreenWidth, y: kStatusBarHeight, width: kScreenWidth, height: kScreenHeight - kStatusBarHeight))
        
        backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        unDocItems = SpiderRealm.groupUndocItems()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UndocTextCell.self, forCellWithReuseIdentifier: textCellID)
        collectionView.registerClass(UndocPicCell.self, forCellWithReuseIdentifier: picCellID)
        collectionView.registerClass(UndocAudioCell.self, forCellWithReuseIdentifier: audioCellID)
        collectionView.registerClass(UndocHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headID)
        
        toolBar.addSubview(titleLabel)
        toolBar.addSubview(backButton)
        addSubview(toolBar)
        addSubview(collectionView)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongPress)))
    }
    
    func didLongPress(ges: UILongPressGestureRecognizer) {
        let location = ges.locationInView(self.superview!)
        
        switch ges.state {
            
        case .Began:
            
            guard let indexPath = collectionView.indexPathForItemAtPoint(ges.locationInView(collectionView)) else { return }
            
            let section = unDocItems[indexPath.section][indexPath.item]
            let layout = layoutPool.cellLayoutOfSection(section)
            
            articleDelegate?.didBeginToDragSeciton(section, layout: layout, ges: ges)
            
            backgroundColor = UIColor(white: 1, alpha: 0)

            UIView.animateWithDuration(0.3, animations: {
                self.frame.origin.x = kScreenWidth
            })
            
        case .Changed:
            
            articleDelegate?.didChange(ges)
            
        default:
            
            articleDelegate?.didEndDrag(location)
        }
    }
    
    func didTap(ges: UITapGestureRecognizer) {
        
        let location = ges.locationInView(self)
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth - boxWidth, height: kScreenHeight)
        
        if rect.contains(location) {
            removeFromSuperview()
        }
    }
    
    func moveTo(view: UIView) {
        view.addSubview(self)
        hidden = false
        
        unDocItems = SpiderRealm.groupUndocItems()
        collectionView.reloadData()
        
        UIView.animateWithDuration(0.3) {
            self.backgroundColor = UIColor(white: 0, alpha: 0.6)
            self.frame.origin.x = 0
        }
    }
    
    override func removeFromSuperview() {
        backgroundColor = UIColor(white: 1, alpha: 0)
        articleDelegate?.didQuitUndocBox()
        
        UIView.animateWithDuration(0.3, animations: {
            self.frame.origin.x = kScreenWidth
        }) { done in
            super.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ArticleUndocBoxView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return unDocItems.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unDocItems[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let type = SectionType(rawValue: unDocItems[indexPath.section][indexPath.item].type) else { return UICollectionViewCell() }
        
        switch type {
            
        case .Text:
            return collectionView.dequeueReusableCellWithReuseIdentifier(textCellID, forIndexPath: indexPath) as! UndocTextCell
            
        case .Pic:
            return collectionView.dequeueReusableCellWithReuseIdentifier(picCellID, forIndexPath: indexPath) as! UndocPicCell
            
        case .Audio:
            return collectionView.dequeueReusableCellWithReuseIdentifier(audioCellID, forIndexPath: indexPath) as! UndocAudioCell
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let undocItem = unDocItems[indexPath.section][indexPath.item]
        let layout  = layoutPool.cellLayoutOfSection(undocItem)
        
        guard let type = SectionType(rawValue: undocItem.type) else { return }
        
        switch type {
            
        case .Text:
            guard let cell = cell as? UndocTextCell else { return }
            cell.configureWithInfo(layout)
            
        case .Pic:
            guard let cell = cell as? UndocPicCell else { return }
            cell.configureWithInfo(layout)
            
        case .Audio:
            guard let cell = cell as? UndocAudioCell else { return }
            cell.configureWithInfo(layout)
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: headID, forIndexPath: indexPath) as! UndocHeaderView
        
        if let time = unDocItems[indexPath.section].first?.updateAt {
            header.configureWith(time)
        }
        
        return header
    }
}
