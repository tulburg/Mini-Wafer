//
//  Extensions.swift
//  Mini Wafer
//
//  Created by tolu oluwagbemi on 5/22/18.
//  Copyright © 2018 tolu oluwagbemi. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstraints(format: String, views: UIView...) {
        var viewDict = [String: Any]()
        for(index, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            let key = "v\(index)"
            viewDict[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDict))
    }
    
    func constrain(type: ConstraintType, _ views: UIView..., margin: Float = 0) {
        if type == .horizontalFill {
            for view in views {
                addConstraints(format: "H:|-\(margin)-[v0]-\(margin)-|", views: view)
            }
        }else if type == .verticalFill {
            for view in views {
                addConstraints(format: "V:|-\(margin)-[v0]-\(margin)-|", views: view)
            }
        }
    }
    
    func showIndicator(size: Int, color: UIColor) {
        let loadIndicator = UIActivityIndicatorView()
        loadIndicator.activityIndicatorViewStyle = .whiteLarge
        loadIndicator.color = color
        loadIndicator.startAnimating()
        var dimen = 20
        if size == 2 { dimen = 40 }
        if size == 3 { dimen = 60 }
        if size == 4 { dimen = 80 }
        if size == 5 { dimen = 100 }
        addSubview(loadIndicator)
        addConstraints(format: "V:|-(>=0)-[v0(\(dimen))]-(>=0)-|", views: loadIndicator)
        addConstraints(format: "H:|-(>=0)-[v0(\(dimen))]-(>=0)-|", views: loadIndicator)
        loadIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func hideIndicator() {
        for v: UIView in subviews {
            if v is UIActivityIndicatorView {
                v.removeFromSuperview()
            }
        }
    }
    
    func addSubviews(views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}


extension UIColor {
    
    convenience init(hex: Int) {
        self.init(red: CGFloat((hex >> 16) & 0xff) / 255.0, green: CGFloat((hex >> 8) & 0xff) / 255.0, blue: CGFloat(hex & 0xff) / 255.0, alpha: 1)
    }
    
    class func waferPurple() -> UIColor {
        return UIColor(hex: 0x9239FF)
    }
    
    class func waferBlue() -> UIColor {
        return UIColor(hex: 0x6394FF)
    }
    
    class func appBlack() -> UIColor {
        return UIColor(hex: 0x151515)
    }
    
    class func appGray() -> UIColor {
        return UIColor(hex: 0x707070)
    }
}

extension Data {
    func toDictionary() -> [Dictionary<String, Any>] {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as! [Dictionary<String, Any>]
        } catch {
            print(error.localizedDescription)
            return [[:]]
        }
    }
}

enum ConstraintType {
    case horizontalFill
    case verticalFill
}


//// ------- CountryViewCell Specific ----

extension UITableView {
    var countryCells: [CountryViewCell] {
        return visibleCells.compactMap({ $0 as? CountryViewCell })
    }
    
    func collapseAllExcept(_ c: CountryViewCell) {
        countryCells.forEach { if($0 != c) { $0.collapse(to: 0) } }
    }
    func collapseAll() {
        countryCells.forEach { $0.collapse(to: 0) }
    }
}

extension CountryViewCell {
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGestureRecognizer,
            let view = gestureRecognizer.view,
            let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer
        {
            let translation = gestureRecognizer.translation(in: view)
            return abs(translation.y) <= abs(translation.x)
        }
        
        if gestureRecognizer is UITapGestureRecognizer {
            tableView?.collapseAll()
        }
        
        return true
    }
}

