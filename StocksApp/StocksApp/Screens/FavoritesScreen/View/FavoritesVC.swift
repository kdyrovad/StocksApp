//
//  FavoritesVC.swift
//  StocksApp
//
//  Created by Dilyara on 01.06.2022.
//

import UIKit

final class FavoritesVC: UIViewController {
    
    private let presenter: FavoritesPresenterProtocol
    
    init(presenter: FavoritesPresenterProtocol) {
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
        self.navigationItem.title = "Favourite"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        presenter.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    
        setUpView()
        setUpSubviews()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
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

extension FavoritesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.typeName, for: indexPath) as? StockCell else {
            return UITableViewCell()
        }
        cell.layer.cornerRadius = 12
        cell.selectionStyle = .none
        cell.setBackgroundColor(for: indexPath.row)
        
        cell.configure(with: presenter.model(for: indexPath))
        
        return cell
    }
}

extension FavoritesVC: StocksViewProtocol {
    func updateView() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func updateCell(for indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func updateView(withLoader isLoading: Bool) {
        print("Loader is - ", isLoading, " at ", Date())
    }
    
    func updateView(withError message: String) {
        print("Error - ", message)
    }
}

extension FavoritesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Main.shared.detailVC(for: presenter.model(for: indexPath))
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

