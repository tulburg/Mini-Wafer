//
//  CountryViewCell.swift
//  Mini Wafer
//
//  Created by tolu oluwagbemi on 5/22/18.
//  Copyright © 2018 tolu oluwagbemi. All rights reserved.
//

import UIKit

class CountryViewCell: UITableViewCell {
    
    var name: UILabel!
    var currency: UILabel!
    var language: UILabel!
    var imagePlaceholder: UIView!
    private var foreview: UIView!
    private var backview: UIView!
    private var actionButton: UIButton!
    
    weak var tableView: UITableView?
    
    var delegate: CountryViewCellDelegate?
    private var draggable: CountryViewCell?
    
    private let buttonWidth: CGFloat = 100.0
    private let closeThreshold: CGFloat = 0.5
    private let completeThreshold: CGFloat = 0.7
    
    private var x: CGFloat = 0
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        build()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        build()
    }
    
    deinit {
        tableView?.panGestureRecognizer.removeTarget(self, action: nil)
    }
    
    func build() {
        name = UILabel()
        currency = UILabel()
        language = UILabel()
        imagePlaceholder = UIView()
        foreview = UIView()
        backview = UIView()
        actionButton = UIButton()
        
        foreview.backgroundColor = UIColor.white
        name.font = UIFont.boldSystemFont(ofSize: 22)
        name.textColor = UIColor.appBlack()
        language.font = UIFont.systemFont(ofSize: 14)
        language.textColor = UIColor.appGray()
        currency.font = UIFont.systemFont(ofSize: 14)
        currency.textColor = UIColor.appGray()
        imagePlaceholder.layer.borderColor = UIColor.lightGray.cgColor
        imagePlaceholder.layer.borderWidth = 2
        imagePlaceholder.layer.cornerRadius = 15
        actionButton.setImage(UIImage(named: "delete_bomb"), for: .normal)
        
        foreview.addSubviews(views: name, currency, language, imagePlaceholder)
        foreview.addConstraints(format: "H:|-24-[v0(30)]-18-[v1(<=\(contentView.frame.width - 120))]-(>=0)-[v2]-24-|", views: imagePlaceholder, name, language)
        foreview.addConstraints(format: "H:|-72-[v0]-(>=0)-|", views: currency)
        foreview.addConstraints(format: "V:|-24-[v0(30)]-(>=0)-|", views: imagePlaceholder)
        foreview.addConstraints(format: "V:|-18-[v0]-8-[v1]-(>=0)-|", views: name, currency)
        foreview.addConstraints(format: "V:|-18-[v0]-(>=0)-|", views: language)
        
        backview.backgroundColor = UIColor.waferPurple()
        backview.addSubview(actionButton)
        backview.addConstraints(format: "H:|-(>=0)-[v0(\(buttonWidth))]-0-|", views: actionButton)
        backview.constrain(type: .verticalFill, actionButton)
        actionButton.addTarget(self, action: #selector(doAction), for: .touchUpInside)
        
        contentView.addSubviews(views: backview, foreview)
        contentView.constrain(type: .horizontalFill, foreview, backview)
        contentView.constrain(type: .verticalFill, foreview, backview)
        
        addGestureRecognizer(panGestureRecognizer)
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapGuesture() {
        collapse(to: 0)
    }
    
    @objc func tableTapGesture(_ target: UITableView) {
        target.collapseAll()
    }
    
    @objc func swipeGuesture(pan: UIPanGestureRecognizer, dir: UISwipeGestureRecognizerDirection) {
        guard isEditing == false else { return } // prevent swipe when table is editing
        let translation = pan.translation(in: pan.view!)
        let propX = translation.x + x

        if (pan.state == .began) {
            tableView?.collapseAllExcept(self)
        }
        
        if(pan.state == .changed) {
            if(propX < 0 ) {
                let cell = (pan.view as? CountryViewCell)
                self.draggable = cell
                cell?.foreview.transform = CGAffineTransform(translationX: propX, y: 0)
                
                if(checkState(x: propX) == .complete) {
                    UIView.animate(withDuration: 0.3, animations: {
                        cell?.actionButton.transform = CGAffineTransform(translationX: propX + self.buttonWidth, y: 0)
                    })
                }
                if(checkState(x: propX) == .open) {
                    UIView.animate(withDuration: 0.3, animations: {
                        cell?.actionButton.transform = CGAffineTransform(translationX: 0, y: 0)
                    })
                }
            }
        }
        
        if(pan.state == .ended) {
            let cell = (pan.view as? CountryViewCell)
            if cell != nil {
                switch(checkState(x: propX)) {
                case .close :
                    collapse(to: 0)
                case .open :
                    collapse(to: -buttonWidth)
                case .complete:
                    collapse(to: 0)
                    if delegate != nil && tableView != nil {
                        delegate?.performAction(tableView!, actionForCountryCellAt: (tableView?.indexPath(for: self))!, true)
                    }
                }
            }
        }
    }
    
    @objc func doAction(_ sender: NSObject) {
        if delegate != nil {
            delegate?.performAction(tableView!, actionForCountryCellAt: (tableView?.indexPath(for: self))!, false)
        }
        collapse(to: 0)
    }
    
    func collapse(to: CGFloat) {
        UIView.animate(withDuration: 0.4, animations: {
            self.draggable?.foreview.transform = CGAffineTransform(translationX: to, y: 0)
        })
        x = to
    }
    
    func checkState(x: CGFloat) -> CollapseState {
        if(-x > (frame.width * completeThreshold)) { return CollapseState.complete }
        if(-x > (buttonWidth * closeThreshold)) { return CollapseState.open }
        if(-x < (buttonWidth * closeThreshold)) { return CollapseState.close }
        return CollapseState.close
    }
    
    enum CollapseState {
        case close
        case open
        case complete
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        collapse(to: 0)
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        // find table view
        var view: UIView = self
        while let superview = view.superview {
            view = superview
            if let tableView = view as? UITableView {
                tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tableTapGesture(_:))))
                self.tableView = tableView
                return
            }
        }
    }
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(swipeGuesture(pan:dir:)))
        gesture.delegate = self
        return gesture
    }()
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGuesture))
        gesture.delegate = self
        return gesture
    }()
}

// Primary Delegate for action
protocol CountryViewCellDelegate {
    func performAction(_ tableView: UITableView, actionForCountryCellAt indexPath: IndexPath, _ fullswipe: Bool)
}
