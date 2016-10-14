//
//  AddProjectAlertView.swift
//  Spider
//
//  Created by ooatuoo on 16/7/6.
//  Copyright © 2016年 oOatuo. All rights reserved.
//

import UIKit
import SnapKit

private let themeColor = UIColor.color(withHex: 0x18BD83)

final class EditProjectNameAlertView: UIView {
    var doneHandler: (String -> Void)!
    var cancelHandler: (() -> Void)!
    
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.font = UIFont.systemFontOfSize(14)
        field.layer.cornerRadius = 2.0
        
        field.tintColor = themeColor
        field.textColor = UIColor.color(withHex: 0x333333)
        field.backgroundColor = UIColor.color(withHex: 0xf0f0f0)
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        field.leftViewMode = .Always
        return field
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.whiteColor()
        button.setTitle("取消", forState: .Normal)
        button.setTitleColor(UIColor.color(withHex: 0x888888), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.whiteColor()
        button.setTitle("确定", forState: .Normal)
        button.setTitleColor(themeColor, forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        return button
    }()
    
    // MARK: - Init
    init(text: String) {
        super.init(frame: CGRectZero)
        layer.cornerRadius = 2.0
        layer.masksToBounds = true
        backgroundColor = UIColor.color(withHex: 0xf0f0f0)
        
        textField.text = text
        
        makeUI()
        addActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Button Actions
    func addActions() {
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), forControlEvents: .TouchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonClicked), forControlEvents: .TouchUpInside)
        
        textField.becomeFirstResponder()
    }
    
    func cancelButtonClicked() {
        textField.resignFirstResponder()
        removeFromSuperview()
        cancelHandler()
    }
    
    func doneButtonClicked() {
        doneHandler(textField.text!)
        textField.resignFirstResponder()
        removeFromSuperview()
    }
    
    // MARK: -  Make UI
    
    func makeUI() {
        
        let topContainter = UIView()
        topContainter.backgroundColor = UIColor.whiteColor()
        
        topContainter.addSubview(textField)
        addSubview(topContainter)
        addSubview(cancelButton)
        addSubview(doneButton)
        
        topContainter.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        topContainter.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 270, height: 62))
            make.top.centerX.equalTo(self)
        }
        
        textField.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 240, height: 30))
            make.center.equalTo(topContainter)
        }
        
        cancelButton.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 134.5, height: 43))
            make.bottom.left.equalTo(self)
        }
        
        doneButton.snp_makeConstraints { (make) in
            make.size.equalTo(cancelButton)
            make.bottom.right.equalTo(self)
        }
    }
}
