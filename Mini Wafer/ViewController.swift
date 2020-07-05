//
//  ViewController.swift
//  Mini Wafer
//
//  Created by tolu oluwagbemi on 5/21/18.
//  Copyright © 2018 tolu oluwagbemi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CountryViewCellDelegate {
    
    var tableView: UITableView!
    var countries: [Country] = []
    let apiAddr = "https://restcountries.eu/rest/v2/all"
    var subtitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        // components
        let button = waferBtn(UIImage(named: "reload")!, size: CGSize(width: 50, height: 50))
        let title = boldLabel("Countries", size: 35, color: UIColor.appBlack())
        let headerView = UIView()
        subtitle = Label("Loading...", size: 12, color: UIColor(hex: 0x707070))
        tableView = UITableView()
        setupTableView()
        
        // structure UI
        view.addSubviews(views: tableView)
        headerView.addSubviews(views: title, subtitle, button)
        headerView.addConstraints(format: "H:|-24-[v0]-(>=0)-[v1(50)]-24-|", views: title, button)
        headerView.addConstraints(format: "V:|-0-[v0(50)]-(>=0)-|", views: button)
        headerView.addConstraints(format: "V:|-0-[v0]-0-[v1]-(>=0)-|", views: title, subtitle)
        headerView.addConstraints(format: "H:|-24-[v0]-(>=0)-|", views: subtitle)
        tableView.addSubview(headerView)
        view.addConstraints(format: "H:|-0-[v0]-0-|", views: tableView)
        tableView.addConstraints(format: "H:|-0-[v0(\(view.frame.width))]-0-|", views: headerView)
        view.addConstraints(format: "V:|-\(statusBarHeight)-[v0]-0-|", views: tableView)
        tableView.addConstraints(format: "V:|-24-[v0(100)]-(>=0)-|", views: headerView)
        tableView.tableHeaderView = headerView
        
        // make request
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        tableView.showIndicator(size: 4, color: UIColor.appBlack())
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reload)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }
    
    @objc func reload() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        tableView.showIndicator(size: 4, color: UIColor.appBlack())
        load()
    }
    
    func load() {
        openAPI(url: apiAddr, params: [:], completion: { data, response, error in
            if error == nil {
                if let result: [Dictionary<String, Any>] = (data?.toDictionary()) {
                    self.countries = []
                    for countries: Dictionary<String, Any> in result {
                        if let country = Country(countries as NSDictionary) {
                            self.countries.append(country)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.hideIndicator()
                        self.tableView.reloadData()
                        self.subtitle.text = "Total of \(self.countries.count)"
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            }else {
                print(error!)
            }
        })
    }

    
    func openAPI(url: String, params: [String: String], completion: @escaping( _ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        var query = ""
        for (key, value) in params {
            query += "\(key)=\(value)&"
        }
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.httpBody = query.data(using: .utf8, allowLossyConversion: true)
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        session.resume()
    }
    
    
    func setupTableView() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.rowHeight = 86
        tableView.estimatedRowHeight = 86
        tableView.backgroundColor = UIColor.white
        tableView.separatorColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CountryViewCell()
        cell.delegate = self

        let country = countries[indexPath.row]
        cell.name.text = country.name
        cell.currency.text = country.currency
        cell.language.text = country.language
        return cell
    }
    
//     --- Customized components ---
    func waferBtn(_ image: UIImage, size: CGSize) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let gradient = UIView()
        button.insertSubview(gradient, at: 0)
        gradient.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        gradient.layer.cornerRadius = size.height / 2
        let innerView = UIView(frame: CGRect(x: 4, y: 4, width: size.width - 8, height: size.height - 8))
        innerView.backgroundColor = UIColor.white
        innerView.layer.cornerRadius = innerView.frame.height / 2
        button.insertSubview(innerView, at: 1)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        button.insertSubview(imageView, at: 2)
        imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradient.frame
        gradientLayer.colors = [UIColor.waferPurple().cgColor, UIColor.waferBlue().cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.cornerRadius = size.height / 2
        gradient.layer.addSublayer(gradientLayer)
        button.layer.cornerRadius = size.height / 2
        return button
    }

    func Label(_ text: String, size: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: size)
        label.textColor = color
        return label
    }
    
    func boldLabel(_ text: String, size: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: size)
        label.textColor = color
        return label
    }
    
    func performAction(_ tableView: UITableView, actionForCountryCellAt indexPath: IndexPath, _ fullswipe: Bool) {
        countries.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}






