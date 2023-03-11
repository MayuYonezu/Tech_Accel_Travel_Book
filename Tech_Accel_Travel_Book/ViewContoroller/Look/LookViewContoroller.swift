import UIKit
import RealmSwift

final class LookViewController: UIViewController {

    // リストプレゼンターから値を取得するため
    private let presenter: LookPresenterInput

    private var projectData: Project?
    private var plans = List<Plan>()
    private var plansDictionary = [String: [Plan]]()
    private var num = Int()

    private let doneBarButtonItem = UIBarButtonItem()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(LookTableViewCell.self, forCellReuseIdentifier: LookTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.dataSource = self
        table.delegate = self
        return table
    }()
    // titleLabel生成
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    // startDayLabel生成
    private let startDayLabel: UILabel = {
        let label = UILabel()
        label.text = "0000/00/00"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    // finishLabel生成
    private let finishDayLabel: UILabel = {
        let label = UILabel()
        label.text = "0000/00/00"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    // tildeLabel生成
    private let tildeLabel: UILabel = {
        let label = UILabel()
        label.text = "~"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    // missionTitleLable生成
    private let missionTitleLabel: UILabel = {
        let missionTitleLabel = UILabel()
        missionTitleLabel.text = "Mission"
        missionTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        missionTitleLabel.textColor = UIColor(asset: Asset.mainPink)
        missionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return missionTitleLabel
    }()
    // missionLabel生成
    private let missionLabel: UILabel = {
        let missionLabel = UILabel()
        missionLabel.text = "aaa"
        missionLabel.font = UIFont.systemFont(ofSize: 17)
        missionLabel.translatesAutoresizingMaskIntoConstraints = false
        missionLabel.textColor = .black
        return missionLabel
    }()
    private let mainPinkImageView: UIImageView = {
        let mainPinkImageView = UIImageView()
        mainPinkImageView.backgroundColor = UIColor(asset: Asset.mainPink)
        mainPinkImageView.translatesAutoresizingMaskIntoConstraints = false
        return mainPinkImageView
    }()

    init(presenter: LookPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // データ取得
        self.presenter.getProjectData()
        self.presenter.getPlanData()

        // backgroundColor指定
        view.backgroundColor = .white
        // Viewに表示
        doneBarButtonItem.style = .done
        doneBarButtonItem.action = #selector(done)
        doneBarButtonItem.target = self
        doneBarButtonItem.title = L10n.done
        self.navigationItem.rightBarButtonItem = doneBarButtonItem

        view.addSubview(titleLabel)
        view.addSubview(startDayLabel)
        view.addSubview(finishDayLabel)
        view.addSubview(tildeLabel)
        view.addSubview(missionLabel)
        view.addSubview(missionTitleLabel)
        view.addSubview(mainPinkImageView)
        view.addSubview(tableView)

        // 文字を入れる
        let projects = self.presenter.returnProject()
        titleLabel.text = projects.title
        startDayLabel.text = projects.startDays
        finishDayLabel.text = projects.finishDays
        missionLabel.text = projects.mission

        // Funtions
        realm_process()
        getPlanData()
        getPlanDicData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // NavigationBar装飾
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(asset: Asset.mainPink)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance

        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 60)
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
        // Layout tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mainPinkImageView.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
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

    @objc func done() {
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
        self.presenter.numberOfProject
    }

    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        //        return plansDictionary.keys.count
        1
    }

    // セクションのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //        let plans = plansDictionary.keys.sorted()
        //        let sectionTitle = plans[section]
        //        return sectionTitle
        return "test"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LookTableViewCell.identifier, for: indexPath) as? LookTableViewCell else {
            fatalError()
        }
        //        let key = plansDictionary.keys.sorted()[indexPath.section]
        //        let plan = plansDictionary[key]?[indexPath.row]
        // MEMO: - ここだけちゃんと表示させる！
        let plan = self.presenter.returnPlan(indexPath: indexPath)
        cell.setUp(startedTime: plan.startTime, finishTime: plan.finishTime, planText: plan.planText)
        //        cell.setUp(startedTime: "start", finishTime: "finishTime", planText: "planText")
        return cell
    }
}
