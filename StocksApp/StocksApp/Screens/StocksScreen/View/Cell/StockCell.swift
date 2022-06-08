//
//  StockCell.swift
//  StocksApp
//
//  Created by Dilyara on 29.05.2022.
//

import UIKit

final class StockCell: UITableViewCell {
    
    private var favoriteAction: (() -> Void)?
    
    //MARK: - Views
    
    private lazy var iconView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var changeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        label.textColor = UIColor(red: 36/255, green: 178/255, blue: 93/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "favorite-off"), for: .normal)
        button.setImage(UIImage(named: "favSelected"), for: .selected)
        button.addTarget(self, action: #selector(favButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let priceContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        favoriteAction = nil
    }
    
    //MARK: - Methods
    
    
    @objc private func favButtonTap() {
        favoriteButton.isSelected.toggle()
        favoriteAction?()
    }
    
    func configure(with model: StockModelProtocol) {
        symbolLabel.text = model.symbol.uppercased()
        companyLabel.text = model.name
        priceLabel.text = model.price
        changeLabel.text = model.change
        changeLabel.textColor = model.changeColor
        iconView.downloaded(from: model.iconURL)
        favoriteButton.isSelected = model.isFav
        
        favoriteAction = {
            model.setFavorite()
        }
        
    }
    
    private func setupContentView() {
        contentView.addSubview(iconView)
        contentView.addSubview(titleContainerView)
        contentView.addSubview(priceContainerView)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            iconView.heightAnchor.constraint(equalToConstant: 52),
            iconView.widthAnchor.constraint(equalToConstant: 52),
            
            titleContainerView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleContainerView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            titleContainerView.trailingAnchor.constraint(lessThanOrEqualTo: priceContainerView.leadingAnchor, constant: -20),
            
            priceContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            priceContainerView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
        ])
        
        setupTitleContainerView()
        setupPriceContainerView()
    }
    
    private func setupTitleContainerView() {
        titleContainerView.addSubview(symbolLabel)
        titleContainerView.addSubview(companyLabel)
        titleContainerView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            symbolLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor),
            symbolLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
            
            favoriteButton.leadingAnchor.constraint(equalTo: symbolLabel.trailingAnchor, constant: 6),
            favoriteButton.centerYAnchor.constraint(equalTo: symbolLabel.centerYAnchor),
            favoriteButton.heightAnchor.constraint(equalToConstant: 16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 16),
            favoriteButton.trailingAnchor.constraint(lessThanOrEqualTo: titleContainerView.trailingAnchor),
            
            companyLabel.leadingAnchor.constraint(equalTo: symbolLabel.leadingAnchor),
            companyLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor),
            companyLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            companyLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor)
        ])
    }
    
    private func setupPriceContainerView() {
        priceContainerView.addSubview(priceLabel)
        priceContainerView.addSubview(changeLabel)
        
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: priceContainerView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: priceContainerView.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: priceContainerView.topAnchor),
            
            changeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: priceContainerView.leadingAnchor),
            changeLabel.trailingAnchor.constraint(equalTo: priceContainerView.trailingAnchor),
            changeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            changeLabel.bottomAnchor.constraint(equalTo: priceContainerView.bottomAnchor)
        ])
    }
    
}
