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
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Stocks"
        print("WILL APPEAR")
        updateView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        setUpView()
        setUpSubviews()
        
        presenter.loadView()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        navigationItem.title = "Stocks"
        //title = "Stocks"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpSubviews() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
        return presenter.itemsCount
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
        let presneter = DetailPresenter(service: StocksService(client: Network()))
        let vc = DetailVC(presenter: presneter)
        presneter.view = vc
        
        vc.price = presenter.model(for: indexPath).price
        vc.change = presenter.model(for: indexPath).change
        vc.bigTitle = presenter.model(for: indexPath).name
        vc.littleTitle = presenter.model(for: indexPath).symbol
        vc.isFav = presenter.model(for: indexPath).isFav
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
