//
//  ListViewController.swift
//  MissionTravel
//
//  Created by Mayu Yonezu on 2022/06/07.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

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

    private let disposeBag = DisposeBag()
    private let viewModel: ListViewModel

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        viewModel.output.reloadDataRelay
            .subscribe(with: self) { owner, _ in
                owner.tableView.reloadData()
            }
            .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError()
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

        // ViewModelのinputのfetchStartにVoidを流す
        viewModel.input.fetchStart.accept(())
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
        guard let projectData = viewModel.output.projectDataCountRelay.value else { return 0 }
        return Int(projectData)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            fatalError()
        }
        let project = viewModel.output.projectDataRelay.value
        cell.setUp(titleText: project?.title ?? "")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                owner.viewModel.input.projectId.accept(indexPath)
                print(indexPath.row)
            }
            .disposed(by: disposeBag)
    }
}

extension ListViewController: ListPresenterOutput {

    func transition(project: Project) {
        let lookVC = LookViewController(viewModel: LookViewModel(projectID: project.id))
        self.navigationController?.pushViewController(lookVC, animated: true)
    }

    func fetchData() {
        self.tableView.reloadData()
    }
}
