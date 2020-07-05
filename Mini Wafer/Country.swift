//
//  Country.swift
//  Mini Wafer
//
//  Created by tolu oluwagbemi on 5/22/18.
//  Copyright © 2018 tolu oluwagbemi. All rights reserved.
//

import UIKit


class Country {
    
    var name: String?
    var currency: String?
    var language: String?
    
    init? (_ dict: NSDictionary) {
        if let name: String = dict["name"] as? String { self.name = name }
        if let currencies: [NSDictionary] = dict["currencies"] as? [NSDictionary] {
            if let currency =  currencies[0]["name"] as? String {
                self.currency = currency
            }
        }
        if let languages: [NSDictionary] = dict["languages"] as? [NSDictionary] {
            if let language =  languages[0]["name"] as? String {
                self.language = language
            }
        }
    }
}
