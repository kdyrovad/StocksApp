//
//  DetailVC.swift
//  StocksApp
//
//  Created by Dilyara on 30.05.2022.
//

import UIKit

final class DetailVC: UIViewController {
    
    private let presenter: DetailPresenterProtocol
    
    init(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.text = presenter.bigTitle
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.text = presenter.littleTitle
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = presenter.price
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var changeLabel: UILabel = {
        let label = UILabel()
        label.text = presenter.change
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
        button.setImage(UIImage(named: "favDetail"), for: .normal)
        button.setImage(UIImage(named: "favSelected"), for: .selected)
        button.addTarget(self, action: #selector(favButtonTap), for: .touchUpInside)
        button.isSelected = presenter.favoriteButtonIsClicked
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var chartView: UIView = {
        let chart = UIView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
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
        
        presenter.loadView()
    }
    
    private func setUpViews() {
        [priceLabel, changeLabel, chartView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 162),
            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: changeLabel.topAnchor, constant: -8),
            
            changeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeLabel.bottomAnchor.constraint(equalTo: chartView.topAnchor, constant: -30),
            
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chartView.heightAnchor.constraint(equalToConstant: 260)
        ])
    }
    
    @objc private func favButtonTap(sender: UIButton) {
        sender.isSelected.toggle()
        presenter.favoriteButtonTapped()
    }
}

extension DetailVC: DetailViewProtocol {
    func updateView() {
        chartView.backgroundColor = UIColor(hexString: "#F0F4F7")
    }
    
    func updateView(withLoader isLoading: Bool) {
        print("Loader is - detail ", isLoading, " at ", Date())
    }
    
    func updateView(withError message: String) {
        print("Error - ", message)
    }
}
