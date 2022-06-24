//
//  ChartsView.swift
//  StocksApp
//
//  Created by Dilyara on 08.06.2022.
//

import UIKit
import Charts

final class ChartsContainerView: UIView {
    struct Model {
        let perices: [Double]
    }
    
    private var model: ChartsModel? = nil
    
    private var buttonsArray: [UIButton] = []
    
    private var chartsView: LineChartView = {
        let view = LineChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.xAxis.drawLabelsEnabled = false
        view.leftAxis.enabled = false
        view.leftAxis.drawGridLinesEnabled = false
        view.rightAxis.enabled = false
        view.rightAxis.drawGridLinesEnabled = false
        view.backgroundColor = .white
        return view
    }()
    
    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with isLoading: Bool) {
        loader.isHidden = !isLoading
        buttonsStackView.isHidden = isLoading
        isLoading ? loader.startAnimating() : loader.stopAnimating()
    }
    
    var tagOfTappedButton: Int = 0
    func configure(with model: ChartsModel) {
        self.model = model
        setCharts1(with: model, i: 0)
        addButtons(for: model)
    }
    
    private func setupSubviews() {
        [chartsView, buttonsStackView, loader].forEach {
            addSubview($0)
        }
        
        chartsView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        chartsView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        chartsView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        chartsView.heightAnchor.constraint(equalToConstant: 260).isActive = true
        
        buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        buttonsStackView.topAnchor.constraint(equalTo: chartsView.bottomAnchor, constant: 40).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        loader.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loader.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func addButtons(for model: ChartsModel) {
        model.periods.enumerated().forEach { (index, period) in
            let button = UIButton()
            
            if period.name == "W" {
                button.backgroundColor = UIColor.black
                button.setTitle(period.name, for: .normal)
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = UIColor(red: 240/255, green: 244/255, blue: 247/255, alpha: 1)
                button.setTitle(period.name, for: .normal)
                button.setTitleColor(.black, for: .normal)
            }
            
            button.setTitle(period.name, for: .normal)
            button.titleLabel?.font = .boldSystemFont(ofSize: 12)
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            button.layer.cornerRadius = 12
            button.layer.cornerCurve = .continuous
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(button)
            buttonsArray.append(button)
        }
    }
    
    private func setCharts(with period: ChartsModel.Period?) {
        guard let period = period else {
            return
        }

        var yValues = [ChartDataEntry]()
        for (index, value) in period.prices.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(index + 1), y: value)
            yValues.append(dataEntry)
        }
        
        let lineDataSet = LineChartDataSet(entries: yValues, label: period.name)
        lineDataSet.valueFont = .boldSystemFont(ofSize: 10)
        lineDataSet.valueTextColor = .black
        lineDataSet.drawFilledEnabled = true
        lineDataSet.circleRadius = 3.0
        lineDataSet.circleHoleRadius = 2.0
        
        chartsView.data = LineChartData(dataSets: [lineDataSet])
        chartsView.animate(xAxisDuration: 0.3, yAxisDuration: 0.2)
    }
    
    private func setCharts1(with model: ChartsModel, i: Int) {
        guard model.periods[i].prices.count > i else {
            return
        }

        var yValues = [ChartDataEntry]()
        for (index, value) in model.periods[i].prices.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(index + 1), y: value)
            yValues.append(dataEntry)
        }
        
        let lineDataSet = LineChartDataSet(entries: yValues, label: model.periods[i].name)
        lineDataSet.valueFont = .boldSystemFont(ofSize: 10)
        lineDataSet.valueTextColor = .black
        lineDataSet.drawFilledEnabled = true
        lineDataSet.circleRadius = 3.0
        lineDataSet.circleHoleRadius = 2.0
        
        chartsView.data = LineChartData(dataSets: [lineDataSet])
        chartsView.animate(xAxisDuration: 0.3, yAxisDuration: 0.2)
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        buttonsArray.forEach {
            $0.backgroundColor = sender.tag == $0.tag ? .black : UIColor(red: 240/255, green: 244/255, blue: 247/255, alpha: 1)
            $0.setTitleColor(sender.tag == $0.tag ? .white : .black, for: .normal)
        }
        guard let model = self.model else {
            return
        }
        switch sender.tag {
        case 0:
            setCharts1(with: model, i: 0)
        case 1:
            setCharts1(with: model, i: 1)
        case 2:
            setCharts1(with: model, i: 2)
        case 3:
            setCharts1(with: model, i: 3)
        default:
            chartsView.backgroundColor = .clear
        }
    }
}
