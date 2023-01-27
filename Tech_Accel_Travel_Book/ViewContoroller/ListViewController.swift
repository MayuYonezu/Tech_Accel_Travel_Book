//
//  ListViewController.swift
//  MissionTravel
//
//  Created by Mayu Yonezu on 2022/06/07.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController {
    
    let realm = try! Realm()
    var projects = [Project]()
    
    //　受け渡したい値
    var num = Int()
    var dataid = Int()
    
    
    
    
    
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        NavigationDesign()
        setUpViews()
        getProjectData()
        
        let projectData = realm.objects(Project.self)
        print("🟥全てのデータ\(projectData)")
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProjectData()
    }
    
    func setUpViews() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Realmからデータを取得してテーブルビューを再リロードするメソッド
    func getProjectData() {
        projects = Array(realm.objects(Project.self)).reversed()  // Realm DBから保存されてるツイートを全取得
        tableView.reloadData() // テーブルビューをリロード
    }
    
    // NavigationBar装飾
    func NavigationDesign(){
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
        projects.count
    }
    
    // Cellの中身を設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath)
        guard let projectLabel = cell.viewWithTag(1) as? UILabel
        else { return cell }
        
        let project = projects[indexPath.row]
        dataid = projects.count - indexPath.row - 1
        projectLabel.text = project.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // タップされたセルの行番号を出力
        print("\(indexPath.row)番目の行が選択されました。")
        dataid = projects.count - indexPath.row - 1
        print("dataidは\(dataid)")
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "toLookViewController",sender: nil)
        print("完了B")

    }
    
    // prepare for segueをoverrideする
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! LookViewController
        nextVC.num = dataid
        print("完了A")
    }
}
