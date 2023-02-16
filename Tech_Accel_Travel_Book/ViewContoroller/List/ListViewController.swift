//
//  ListViewController.swift
//  MissionTravel
//
//  Created by Mayu Yonezu on 2022/06/07.
//

import UIKit
import RealmSwift

final class ListViewController: UIViewController {
    let projects = [Project]()
    //　受け渡したい値
    var num = Int()
    var dataid = Int()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.dataSource = self
        table.delegate = self
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        self.tableView.reloadData()
        navigationDesign()
        setUpViews()
        getProjectData()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProjectData()
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
    private func setUpViews() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    // Realmからデータを取得してテーブルビューを再リロードするメソッド
    private func getProjectData() {
        tableView.reloadData() // テーブルビューをリロード
    }
    // NavigationBar装飾
    private func navigationDesign() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(asset: Asset.mainPink)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    // TableViewが何個のCellを表示するのか設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        projects.count
        10
    }
// Cellの中身を設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            fatalError()
        }
        cell.setUp(titleText: "titleText")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath)
//        guard let projectLabel = cell.viewWithTag(1) as? UILabel
//        else { return cell }
//        let project = projects[indexPath.row]
//        dataid = projects.count - indexPath.row - 1
//        projectLabel.text = project.title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
// タップされたセルの行番号を出力
        print("\(indexPath.row)番目の行が選択されました。")
        dataid = projects.count - indexPath.row - 1
        print("dataidは\(dataid)")
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "toLookViewController", sender: nil)
        print("完了B")
    }
    // prepare for segueをoverrideする
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as? LookViewController
//        nextVC!.num = dataid
        print("完了A")
    }
}
