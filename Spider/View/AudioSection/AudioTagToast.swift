//
//  AudioTagToast.swift
//  Spider
//
//  Created by ooatuoo on 16/7/12.
//  Copyright © 2016年 oOatuo. All rights reserved.
//

import UIKit

class AudioTagToast: UIImageView {
    
    var editHandler: (() -> Void)?
    var deleteHandler: (() -> Void)?
    
    private var type = ""
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("编辑", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(13)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("删除", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(13)
        return button
    }()
    
    init(type: String) {
        if type == "TextToast" {
            super.init(frame: CGRect(x: 0, y: 0, width: 80, height: 34))
            image = UIImage(named: "audio_text_tag_toast")
        } else {
            super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 34))
            image = UIImage(named: "audio_pic_tag_toast")
        }
        
        userInteractionEnabled = true
        self.type = type
        
        makeUI()
        addActions()
    }
    
    func addActions() {
        editButton.addTarget(self, action: #selector(editButtonClicked), forControlEvents: .TouchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), forControlEvents: .TouchUpInside)
    }
    
    func editButtonClicked() {
        editHandler?()
        removeFromSuperview()
    }
    
    func deleteButtonClicked() {
        deleteHandler?()
        removeFromSuperview()
    }
    
    func makeUI() {
        if type == "TextToast" {
            editButton.frame = CGRect(x: 1, y: 1, width: 38, height: 27)
            deleteButton.frame = CGRect(x: 41, y: 1, width: 38, height: 27)
            
            addSubview(editButton)
            addSubview(deleteButton)
        } else {
            deleteButton.frame = CGRect(x: 1, y: 1, width: 38, height: 27)
            addSubview(deleteButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
