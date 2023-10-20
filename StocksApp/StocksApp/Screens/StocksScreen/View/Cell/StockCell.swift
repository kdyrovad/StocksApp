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
        
        totalView.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-8)
        }

        setupTotalView()
        setupTitleContainerView()
        setupPriceContainerView()
    }
    
    private func setupTotalView() {
        [iconView, titleContainerView, priceContainerView].forEach {
            totalView.addSubview($0)
        }
        
        iconView.snp.makeConstraints { make in
            make.leading.equalTo(totalView).offset(8)
            make.top.equalTo(totalView).offset(8)
            make.bottom.equalTo(totalView).offset(-8)
            make.height.equalTo(52)
            make.width.equalTo(52)
        }

        titleContainerView.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(12)
            make.centerY.equalTo(iconView)
        }

        priceContainerView.snp.makeConstraints { make in
            make.trailing.equalTo(totalView).offset(-12)
            make.centerY.equalTo(iconView)
        }
    }
    
    private func setupTitleContainerView() {
        [symbolLabel, companyLabel, favoriteButton].forEach {
            titleContainerView.addSubview($0)
        }
        
        symbolLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleContainerView)
            make.top.equalTo(titleContainerView)
        }

        favoriteButton.snp.makeConstraints { make in
            make.leading.equalTo(symbolLabel.snp.trailing).offset(6)
            make.centerY.equalTo(symbolLabel)
            make.height.equalTo(16)
            make.width.equalTo(16)
            make.trailing.lessThanOrEqualTo(titleContainerView)
        }

        companyLabel.snp.makeConstraints { make in
            make.leading.equalTo(symbolLabel)
            make.top.equalTo(symbolLabel.snp.bottom)
            make.bottom.equalTo(titleContainerView)
            make.trailing.equalTo(titleContainerView)
        }
    }
    
    private func setupPriceContainerView() {
        [priceLabel, changeLabel].forEach {
            priceContainerView.addSubview($0)
        }

        priceLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(priceContainerView)
            make.trailing.equalTo(priceContainerView)
            make.top.equalTo(priceContainerView)
        }

        changeLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(priceContainerView)
            make.trailing.equalTo(priceContainerView)
            make.top.equalTo(priceLabel.snp.bottom)
            make.bottom.equalTo(priceContainerView)
        }
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
