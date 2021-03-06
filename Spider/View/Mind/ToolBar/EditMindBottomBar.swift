//
//  EditMindBottomBar.swift
//  Spider
//
//  Created by ooatuoo on 16/7/25.
//  Copyright © 2016年 oOatuo. All rights reserved.
//

import UIKit

class EditMindBottomBar: UIView {
    
    var deleteHandler: (() -> Void)?
    var moveHandler: (() -> Void)?
    
    var choosedCount = Int(0) {
        willSet {
            choosedCountLabel.text = "已选中\(newValue)个目标"
            deleteButton.isEnabled = newValue != 0
            moveButton.isEnabled = newValue != 0
        }
    }
    
    fileprivate lazy var choosedCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.color(withHex: 0xB8B8B8)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "已选中0个目标"
        return label
    }()
    
    fileprivate lazy var deleteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.color(withHex: 0x868686)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "删除"
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var moveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.color(withHex: 0x868686)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "移动至"
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "mind_edit_delete"), for: UIControlState())
        return button
    }()
    
    fileprivate lazy var moveButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "mind_edit_move"), for: UIControlState())
        return button
    }()

    init() {
        super.init(frame: CGRect(x: 0, y: 0, w: kScreenWidth, h: 60))
        backgroundColor = UIColor.color(withHex: 0x404040)
        
        choosedCount = 0
        makeUI()
        addActions()
    }
    
    func addToView(_ view: UIView) {
        frame.origin = CGPoint(x: 0, y: view.frame.height)
        view.addSubview(self)
        
//        UIView.animateWithDuration(0.2) { 
            self.frame.origin = CGPoint(x: 0, y: view.frame.height - 60)
//        }
    }
    
    override func removeFromSuperview() {
//        UIView.animateWithDuration(0.2, animations: { 
//            self.frame.origin = CGPoint(x: 0, y: self.superview!.frame.height)
//        }) { done in
            super.removeFromSuperview()
//        }
    }
    
    fileprivate func addActions() {
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        moveButton.addTarget(self, action: #selector(moveButtonClicked), for: .touchUpInside)
    }
    
    func moveButtonClicked() {
        moveHandler?()
    }
    
    func deleteButtonClicked() {
        
        SpiderAlert.confirmOrCancel(title: "", message: "你确定要删除所选段落么", confirmTitle: "确定", cancelTitle: "取消", inViewController: APP_NAVIGATOR.topVC, withConfirmAction: { [weak self] in
            self?.deleteHandler?()
        }, cancelAction: { })
    }
    
    fileprivate func makeUI() {
        addSubview(choosedCountLabel)
        addSubview(deleteLabel)
        addSubview(deleteButton)
        addSubview(moveLabel)
        addSubview(moveButton)
        
        moveButton.snp_makeConstraints { (make) in
            make.size.equalTo(20)
            make.top.equalTo(12)
            make.right.equalTo(-24)
        }
        
        moveLabel.snp_makeConstraints { (make) in
            make.top.equalTo(moveButton.snp_bottom).offset(4)
            make.centerX.equalTo(moveButton)
        }
        
        deleteButton.snp_makeConstraints { (make) in
            make.size.equalTo(20)
            make.top.equalTo(moveButton)
            make.right.equalTo(moveButton.snp_left).offset(-48)
        }
        
        deleteLabel.snp_makeConstraints { (make) in
            make.top.equalTo(deleteButton.snp_bottom).offset(4)
            make.centerX.equalTo(deleteButton)
        }
        
        choosedCountLabel.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(deleteButton.snp_left).offset(-24)
            make.top.bottom.equalTo(self)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = UIBezierPath()
        path.move(to: CGPoint(x: kScreenWidth - 136, y: 0))
        path.addLine(to: CGPoint(x: kScreenWidth - 136, y: 60))
        
        path.move(to: CGPoint(x: kScreenWidth - 68, y: 0))
        path.addLine(to: CGPoint(x: kScreenWidth - 68, y: 60))
        
        path.lineWidth = 1
        UIColor.color(withHex: 0x505050).setStroke()
        
        path.stroke()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
