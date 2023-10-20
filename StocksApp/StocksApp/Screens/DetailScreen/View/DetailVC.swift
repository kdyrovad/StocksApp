//
//  DetailVC.swift
//  StocksApp
//
//  Created by Dilyara on 30.05.2022.
//

import UIKit
import SnapKit

final class DetailVC: UIViewController {
    
    private let presenter: DetailPresenterProtocol
    
    init(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        get { true }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    private lazy var chartsContainerView: ChartsContainerView = {
        let view = ChartsContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.text = presenter.bigTitle
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.text = presenter.littleTitle
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = presenter.price
        label.font = UIFont(name: "Montserrat-Bold", size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var changeLabel: UILabel = {
        let label = UILabel()
        label.text = presenter.change
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        label.textColor = presenter.changeColor
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
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Buy \(presenter.price ?? "")", for: .normal)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
        
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
        
        presenter.loadView()
    }
    
    private func setUpViews() {
        [priceLabel, changeLabel, chartsContainerView, buyButton].forEach {
            view.addSubview($0)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(162)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(changeLabel.snp.top).offset(-8)
        }

        changeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(chartsContainerView.snp.top).offset(-30)
        }

        chartsContainerView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(changeLabel.snp.bottom).offset(100)
        }

        buyButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-20)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(56)
        }
    }
    
    @objc private func favButtonTap(sender: UIButton) {
        sender.isSelected.toggle()
        presenter.favoriteButtonTapped()
    }
}

extension DetailVC: DetailViewProtocol {
    func updateView(with model: ChartsModel) {
        chartsContainerView.configure(with: model)
    }
    
    func updateView(withLoader isLoading: Bool) {
        chartsContainerView.configure(with: isLoading)
        print("Loader is - detail ", isLoading, " at ", Date())
    }
    
    func updateView(withError message: String) {
        print("Error - ", message)
    }
    
    
}

