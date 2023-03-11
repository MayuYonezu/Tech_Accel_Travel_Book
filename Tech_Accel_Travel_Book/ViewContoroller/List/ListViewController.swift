//
//  ListViewController.swift
//  MissionTravel
//
//  Created by Mayu Yonezu on 2022/06/07.
//

import UIKit
import RealmSwift

final class ListViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.dataSource = self
        table.delegate = self
        return table
    }()

    private var presenter: ListPresenterInput!

    func inject(presenter: ListPresenterInput) {
        self.presenter = presenter
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)

        do {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(asset: Asset.mainPink)
            appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText]
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
            navigationItem.compactAppearance = appearance
        }

        self.presenter.getProjectData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.numberOfProject
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            fatalError()
        }
        let project = self.presenter.returnProject(indexPath: indexPath)
        cell.setUp(titleText: project.title)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.presenter.didSelectRowAt(indexPath: indexPath)
    }
}

extension ListViewController: ListPresenterOutput {

    func transition(project: Project) {
        let lookVC = LookViewController(presenter: LookPresenter())
        self.navigationController?.pushViewController(lookVC, animated: true)
    }

    func fetchData() {
        self.tableView.reloadData()
    }
}
