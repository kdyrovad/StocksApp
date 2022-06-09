//
//  SearchVC.swift
//  StocksApp
//
//  Created by Dilyara on 09.06.2022.
//

import UIKit

final class SearchVC: UIViewController, UISearchBarDelegate {
    
    private let presenter: SearchPresenterProtocol
    
    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var itemsCount: Int = 0
    var typedText: String = ""
    
    private lazy var searchBar: UISearchBar = {
        let searchBar: UISearchBar = UISearchBar()
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.layer.borderColor = UIColor.black.cgColor
        searchBar.layer.borderWidth = 2
        searchBar.layer.cornerRadius = 30.0
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.white
  
        return searchBar
    }()
    
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
    
    private lazy var stocksLabel: UILabel = {
        let label = UILabel()
        label.text = "Stocks"
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Search"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        presenter.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(stocksLabel)
        
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        
        stocksLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stocksLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 25).isActive = true
        stocksLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableView.topAnchor.constraint(equalTo: stocksLabel.bottomAnchor, constant: 15).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
//        stocksLabel.isHidden = presenter.searchItemsCount == 0 ? true : false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        typedText = searchText
        presenter.searchItemsCountChanged(text: searchText)
        
        tableView.reloadData()
        stocksLabel.isHidden = presenter.searchItemsCount == 0 ? true : false
    }
}

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.searchItemsCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        68
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.typeName, for: indexPath) as? StockCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = (indexPath.section % 2 == 0) ? UIColor(hexString: "#F0F4F7") : .white
        cell.layer.cornerRadius = 16
        cell.selectionStyle = .none
        cell.configure(with: presenter.modelSearch(for: indexPath, text: typedText))
        
        return cell
    }
}

extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = view.backgroundColor
        return headerView
    }
     
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Main.shared.detailVC(for: presenter.modelSearch(for: indexPath, text: typedText))
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchVC: StocksViewProtocol {
    func updateView() {
        tableView.reloadData()
    }
    
    func updateCell(for indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func updateView(withLoader isLoading: Bool) {
        print("Loader is - stocks ", isLoading, " at ", Date())
    }
    
    func updateView(withError message: String) {
        print("Error - ", message)
    }
}
