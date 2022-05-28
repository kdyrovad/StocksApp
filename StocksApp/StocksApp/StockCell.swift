//
//  StockCell.swift
//  StocksApp
//
//  Created by Dilyara on 29.05.2022.
//

import UIKit

final class StockCell: UITableViewCell {
    private lazy var iconView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .blue
        image.image = UIImage(named: "Logo")
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.text = "YNDX"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        contentView.addSubview(iconView)
        contentView.addSubview(symbolLabel)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 52).isActive = true
        
        symbolLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12).isActive = true
        symbolLabel.topAnchor.constraint(equalTo: iconView.topAnchor, constant: 14).isActive = true
        
    }
    
}
