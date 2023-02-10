import UIKit
import RealmSwift

final class LookViewController: UIViewController {
    private var projectData: Project?
    private var plans = List<Plan>()
    private var plansDictionary = [String: [Plan]]()
    @IBOutlet var tableView: UITableView!
    private var num = Int()
    private var doneButtonItem: UIBarButtonItem!
    // titleLabel生成
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // startDayLabel生成
    private var startDayLabel: UILabel = {
        let label = UILabel()
        label.text = "0000/00/00"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // finishLabel生成
    private var finishDayLabel: UILabel = {
        let label = UILabel()
        label.text = "0000/00/00"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // tildeLabel生成
    private var tildeLabel: UILabel = {
        let label = UILabel()
        label.text = "~"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // missionTitleLable生成
    private var missionTitleLabel: UILabel = {
        let missionTitleLabel = UILabel()
        missionTitleLabel.text = "Mission"
        missionTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        missionTitleLabel.textColor = UIColor(asset: Asset.mainPink)
        missionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return missionTitleLabel
    }()
    // missionLabel生成
    private var missionLabel: UILabel = {
        let missionLabel = UILabel()
        missionLabel.text = "aaa"
        missionLabel.font = UIFont.systemFont(ofSize: 17)
        missionLabel.translatesAutoresizingMaskIntoConstraints = false
        return missionLabel
    }()
    private var mainPinkImageView: UIImageView = {
        let mainPinkImageView = UIImageView()
        mainPinkImageView.backgroundColor = UIColor(asset: Asset.mainPink)
        mainPinkImageView.translatesAutoresizingMaskIntoConstraints = false
        return mainPinkImageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // backgroundColor指定
        view.backgroundColor = .white
        // Viewに表示
        view.addSubview(titleLabel)
        view.addSubview(startDayLabel)
        view.addSubview(finishDayLabel)
        view.addSubview(tildeLabel)
        view.addSubview(missionLabel)
        view.addSubview(missionTitleLabel)
        view.addSubview(mainPinkImageView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        // tildeLabel
        NSLayoutConstraint.activate([
            tildeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tildeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        // startDayLabel
        NSLayoutConstraint.activate([
            startDayLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            startDayLabel.trailingAnchor.constraint(equalTo: tildeLabel.leadingAnchor, constant: -20)
        ])
        // finishDayLabel
        NSLayoutConstraint.activate([
            finishDayLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            finishDayLabel.leadingAnchor.constraint(equalTo: tildeLabel.trailingAnchor, constant: 20)
        ])
        // missionTitleLabel
        NSLayoutConstraint.activate([
            missionTitleLabel.topAnchor.constraint(equalTo: startDayLabel.bottomAnchor, constant: 30),
            missionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        // missionLabel
        NSLayoutConstraint.activate([
            missionLabel.topAnchor.constraint(equalTo: startDayLabel.bottomAnchor, constant: 30),
            missionLabel.leadingAnchor.constraint(equalTo: missionTitleLabel.trailingAnchor, constant: 10)
        ])
        // mainPinkImageView
        NSLayoutConstraint.activate([
            mainPinkImageView.topAnchor.constraint(equalTo: missionTitleLabel.bottomAnchor, constant: 3),
            mainPinkImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainPinkImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainPinkImageView.heightAnchor.constraint(equalToConstant: 3)
        ])
    }
    // Realm系の処理
    private func realm_process() {
        // 文字列で条件文を書いてデータを取得
        guard let projectData = MainRealm.shared.realm?.objects(Project.self).filter("id == '\(num)'") else {
            return
        }
        print(projectData)
        for data in projectData {
            titleLabel.text = "\(data.title)"
            startDayLabel.text = "\(data.startDays)"
            finishDayLabel.text = "\(data.finishDays)"
            missionLabel.text = "\(data.mission)"
            plans = data.plans
        }
        tableView.reloadData()
    }
    // NavigationBar装飾
    private func navigationDesign() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(asset: Asset.mainPink)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    @IBAction func done() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    private func getPlanData() {
        // 文字列で条件文を書いてデータを取得
        guard let projectData = MainRealm.shared.realm?.objects(Project.self).filter("id == '\(num)'") else {
            return
        }
        for data in projectData {
            plans = data.plans
            tableView.reloadData()
        }
    }
    private func getPlanDicData() {
        // 全部の値が取得されてしまう
        guard let plans = MainRealm.shared.realm?.objects(Plan.self).reversed() else {
            return
        }
        plansDictionary = [:]
        for getPlan in plans {
            if plansDictionary.keys.contains(getPlan.daySection) {
                // ディクショナリーの鍵に日付が含まれてたら、kを追加
                plansDictionary[getPlan.daySection]?.append(getPlan)
            } else {
                // ディクショナリーの鍵に日付が含まれてなかったら配列を初期化
                plansDictionary[getPlan.daySection] = [getPlan]
            }
        }
        tableView.reloadData()
    }
}
extension LookViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = Array(plansDictionary.keys).sorted()
        let key = array[section]
        return plansDictionary[key]?.count ?? 0
    }
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return plansDictionary.keys.count
    }
    // セクションのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let array = Array(plansDictionary.keys).sorted()
        let key = array[section]
        return key
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let key = Array(plansDictionary.keys).sorted()[indexPath.section] // 0
        let plann = plansDictionary[key]?[indexPath.row]
        (cell.viewWithTag(1) as? UILabel)!.text = plann?.startTime
        (cell.viewWithTag(2) as? UILabel)!.text = plann?.finishTime
        (cell.viewWithTag(3) as? UILabel)!.text = plann?.planText
        return cell
    }
}
