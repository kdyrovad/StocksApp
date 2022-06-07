//
//  StocksViewController.swift
//  StocksApp
//
//  Created by Dilyara on 29.05.2022.
//

import UIKit

final class StocksViewController: UIViewController {
    
    private let presenter: StocksPresenterProtocol
    
    init(presenter: StocksPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StockCell.self, forCellReuseIdentifier: StockCell.typeName)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Stocks"
        updateView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        setUpView()
        setUpSubviews()
        
        presenter.loadView()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        navigationItem.title = "Stocks"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpSubviews() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension StocksViewController: StocksViewProtocol {
    func updateView() {
        tableView.reloadData()
    }
    
    func updateView(withLoader isLoading: Bool) {
        print("Loader is - stocks ", isLoading, " at ", Date())
    }
    
    func updateView(withError message: String) {
        print("Error - ", message)
    }
}

extension StocksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.typeName, for: indexPath) as! StockCell
        cell.backgroundColor = (indexPath.section % 2 == 0) ? UIColor(hexString: "#F0F4F7") : .white
        cell.layer.cornerRadius = 12
        cell.selectionStyle = .none
        
        cell.configure(with: presenter.model(for: indexPath))
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.itemsCount
    }

}

extension StocksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = view.backgroundColor
        return headerView
    }
     
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = presenter.model(for: indexPath)
        let vc = Main.shared.detailVC(for: model)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
