//
//  DetailVC.swift
//  StocksApp
//
//  Created by Dilyara on 30.05.2022.
//

import UIKit

final class DetailVC: UIViewController {
    
    var bigTitle: String = ""
    var littleTitle: String = ""
    var price: String = ""
    var change: String = ""
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.text = bigTitle
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.text = littleTitle
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "\(price)"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var changeLabel: UILabel = {
        let label = UILabel()
        label.text = "\(change)"
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 36/255, green: 178/255, blue: 93/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.spacing = 4
        stackView.alignment = UIStackView.Alignment.center
        stackView.addArrangedSubview(symbolLabel)
        stackView.addArrangedSubview(companyLabel)
        
        return stackView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "fav"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewWillLayoutSubviews() {
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.backItem?.title = ""
        let favButton = UIBarButtonItem()
        favButton.customView = favoriteButton
        self.navigationItem.rightBarButtonItem = favButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = stackView
        view.backgroundColor = .white
        setUpViews()
    }
    
    private func setUpViews() {
        view.addSubview(priceLabel)
        view.addSubview(changeLabel)
        
        priceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 162).isActive = true
        priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: changeLabel.topAnchor, constant: -8).isActive = true
        
        changeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
