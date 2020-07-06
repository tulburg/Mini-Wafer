//
//  NavigationController.swift
//  Mini Wafer
//
//  Created by Tolu Oluwagbemi on 05/07/2020.
//  Copyright © 2020 tolu oluwagbemi. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)
		let frame = self.navigationBar.frame
		self.navigationBar.shadowImage = UIImage(named: "bar")?.resize(CGSize(width: frame.width, height: 4))
	}
}
