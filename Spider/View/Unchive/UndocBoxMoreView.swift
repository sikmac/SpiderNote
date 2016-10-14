//
//  UndocBoxMoreView.swift
//  Spider
//
//  Created by ooatuoo on 16/8/21.
//  Copyright © 2016年 auais. All rights reserved.
//

import UIKit

private enum UndocBoxMoreType: String, CustomStringConvertible {
    case Text  = "undoc_more_text"
    case Pic   = "undoc_more_pic"
    case Audio = "undoc_more_audio"
    case Batch = "undoc_more_batch"
    
    var description: String {
        switch self {
        case .Text:
            return "新建文字"
        case .Pic:
            return "新建图片"
        case .Audio:
            return "新建录音"
        case .Batch:
            return "批量操作"
        }
    }
}

class UndocBoxMoreView: UIImageView, UITableViewDataSource, UITableViewDelegate {
    
    private var dataSource: [UndocBoxMoreType] = [.Text, .Pic, .Audio, . Batch]
    
    private var tableView: UITableView = {
        let tableV             = UITableView()
        tableV.rowHeight       = 45
        tableV.bounces         = false
        tableV.backgroundColor = UIColor.clearColor()
        tableV.separatorColor  = UIColor.color(withHex: 0x666666)
        tableV.separatorInset  = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return tableV
    }()
    
    init() {
        super.init(frame: CGRect(x: kScreenWidth - 120 - 3, y: 20 + 22 + 6, width: 120, height: 190))
        userInteractionEnabled = true
        image = UIImage(named: "undoc_more_bg")
        
        tableView.dataSource = self
        tableView.delegate = self
        addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.snp_makeConstraints { (make) in
            make.right.left.bottom.equalTo(self)
            make.top.equalTo(7)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return UndocBoxMoreCell(type: dataSource[indexPath.item])
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let undocVC = APP_NAVIGATOR.topVC as? UndocBoxViewController else { return }
        
        switch dataSource[indexPath.item] {
            
        case .Text:
            
            AddUndocTextView().moveTo(APP_NAVIGATOR.mainNav!.view)
            
        case .Pic:
            
            let picker = TZImagePickerController(maxCount: 4, animated: false, completion: { photos in
                
                let vc = PicDetailViewController(photos: photos)
                undocVC.presentViewController(vc, animated: true, completion: nil)
            })
            
            undocVC.presentViewController(picker, animated: true, completion: nil)
            
        case .Audio:
            
            undocVC.presentViewController(AudioSectionViewController(), animated: true, completion: nil)
            
        case .Batch:
            
            undocVC.changeModel()
        }
        
        removeFromSuperview()
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
        if !bounds.contains(point) {
            removeFromSuperview()
        }
        
        return super.hitTest(point, withEvent: event)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class UndocBoxMoreCell: UITableViewCell {
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = SpiderConfig.Color.LightText
        label.textAlignment = .Center
        return label
    }()
    
    private var logo: UIImageView = {
        return UIImageView()
    }()
    
    init(type: UndocBoxMoreType) {
        super.init(style: .Default, reuseIdentifier: "")
        
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        label.text = type.description
        logo.contentMode = .ScaleAspectFit
        logo.image = UIImage(named: type.rawValue)
        
        contentView.addSubview(label)
        contentView.addSubview(logo)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        logo.snp_makeConstraints { (make) in
            make.size.left.equalTo(15)
            make.centerY.equalTo(contentView)
        }
        
        label.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(logo.snp_right).offset(10)
            make.right.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
