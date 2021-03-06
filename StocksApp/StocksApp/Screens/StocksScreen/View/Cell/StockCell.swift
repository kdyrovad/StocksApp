//
//  StockCell.swift
//  StocksApp
//
//  Created by Dilyara on 29.05.2022.
//

import UIKit
import Kingfisher

final class StockCell: UITableViewCell {
    
    private var favoriteAction: (() -> Void)?
    
    //MARK: - Views
    
    private lazy var totalView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .blue
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        label.textColor = UIColor.StockCell.changeLabelTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "favorite-off"), for: .normal)
        button.setImage(UIImage(named: "favSelected"), for: .selected)
        button.addTarget(self, action: #selector(favButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
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
        contentView.isUserInteractionEnabled = true
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
        iconView.setImage(from: model.iconURL, placeHolder: UIImage(named: "YNDX"))
        favoriteButton.isSelected = model.isFav
        
        favoriteAction = {
            model.setFavorite()
        }
    }
    
    func setBackgroundColor(for row: Int) {
        totalView.backgroundColor = (row % 2 == 0) ? UIColor(hexString: "#F0F4F7") : .white
    }
    
    private func setUpViews() {
        setupContentView()
        setupTitleContainerView()
        setupPriceContainerView()
    }
    
    private func setupContentView() {
        contentView.addSubview(totalView)
        
        totalView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        totalView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        totalView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        totalView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true

        setupTotalView()
        setupTitleContainerView()
        setupPriceContainerView()
    }
    
    private func setupTotalView() {
        [iconView, titleContainerView, priceContainerView].forEach {
            totalView.addSubview($0)
        }
        
        iconView.leadingAnchor.constraint(equalTo: totalView.leadingAnchor, constant: 8).isActive = true
        iconView.topAnchor.constraint(equalTo: totalView.topAnchor, constant: 8).isActive = true
        iconView.bottomAnchor.constraint(equalTo: totalView.bottomAnchor, constant: -8).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 52).isActive = true
        
        titleContainerView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12).isActive = true
        titleContainerView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
        
        priceContainerView.trailingAnchor.constraint(equalTo: totalView.trailingAnchor, constant: -12).isActive = true
        priceContainerView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
    }
    
    private func setupTitleContainerView() {
        [symbolLabel, companyLabel, favoriteButton].forEach {
            titleContainerView.addSubview($0)
        }
        
        symbolLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor).isActive = true
        symbolLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor).isActive = true
        
        favoriteButton.leadingAnchor.constraint(equalTo: symbolLabel.trailingAnchor, constant: 6).isActive = true
        favoriteButton.centerYAnchor.constraint(equalTo: symbolLabel.centerYAnchor).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 16).isActive = true
        favoriteButton.trailingAnchor.constraint(lessThanOrEqualTo: titleContainerView.trailingAnchor).isActive = true
        
        companyLabel.leadingAnchor.constraint(equalTo: symbolLabel.leadingAnchor).isActive = true
        companyLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor).isActive = true
        companyLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor).isActive = true
        companyLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor).isActive = true
    }
    
    private func setupPriceContainerView() {
        [priceLabel, changeLabel].forEach {
            priceContainerView.addSubview($0)
        }

        priceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: priceContainerView.leadingAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: priceContainerView.trailingAnchor).isActive = true
        priceLabel.topAnchor.constraint(equalTo: priceContainerView.topAnchor).isActive = true
        
        changeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: priceContainerView.leadingAnchor).isActive = true
        changeLabel.trailingAnchor.constraint(equalTo: priceContainerView.trailingAnchor).isActive = true
        changeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor).isActive = true
        changeLabel.bottomAnchor.constraint(equalTo: priceContainerView.bottomAnchor).isActive = true
    }
    
}

extension UIColor {
    fileprivate enum StockCell {
        static var changeLabelTextColor: UIColor {
            UIColor(red: 36/255, green: 178/255, blue: 93/255, alpha: 1)
        }
    }
}

extension UIImageView {
    func setImage(from source: String?, placeHolder: UIImage?) {
        guard let urlString = source, let url = URL(string: urlString) else { return }

        kf.setImage(with: .network(url), placeholder: placeHolder)
    }
}
