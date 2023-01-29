import UIKit
import RealmSwift

class LookViewController: UIViewController {
    var projectData: Project?
    var plans = [Plan]()
    var plansDic = [String: [Plan]]()
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var startDayLabel: UILabel!
    @IBOutlet var finishDayLabel: UILabel!
    @IBOutlet var missionLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    var num = Int()
    var doneButtonItem: UIBarButtonItem!
//    let realm = try! Realm()
    let pink = UIColor(red: 242/255.0, green: 167/255.0, blue: 167/255.0, alpha: 1.0) // ボタン背景色設定
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationDesign()
        print("id")
        print("id番号は", num, "番です")
        realm_process()
        getPlanData()
        getPlanDicData()
        print(plans)
        // Do any additional setup after loading the view.
    }
    // Realm系の処理
    func realm_process() {
        // 文字列で条件文を書いてデータを取得
        let projectData = realm.objects(Project.self).filter("id == '\(num)'")
        print(projectData)
        for data in projectData {
            titleLabel.text = "\(data.title)"
            startDayLabel.text = "\(data.startDays)"
            finishDayLabel.text = "\(data.finishDays)"
            missionLabel.text = "\(data.mission)"
            plans = Array(data.plans)
        }
        tableView.reloadData()
    }
    // NavigationBar装飾
    func navigationDesign() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = pink
        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    @IBAction func done() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func getPlanData() {
        // 文字列で条件文を書いてデータを取得
        let projectData = realm.objects(Project.self).filter("id == '\(num)'")
        for data in projectData {
            plans = Array(data.plans)
            tableView.reloadData()
        }
    }
    func getPlanDicData() {
        // 全部の値が取得されてしまう
        // plans = Array(realm.objects(Plan.self)).reversed()
        plansDic = [:]
        for getPlan in plans {
            if plansDic.keys.contains(getPlan.daySection) {
                // ディクショナリーの鍵に日付が含まれてたら、kを追加
                plansDic[getPlan.daySection]?.append(getPlan)
            } else {
                // ディクショナリーの鍵に日付が含まれてなかったら配列を初期化
                plansDic[getPlan.daySection] = [getPlan]
            }
        }
        tableView.reloadData()
    }
}

extension LookViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = Array(plansDic.keys).sorted()
        let key = array[section]
        return plansDic[key]?.count ?? 0
       // return plans.count
      }
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return plansDic.keys.count
    }

    // セクションのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let array = Array(plansDic.keys).sorted()
        let key = array[section]
        return key
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let key = Array(plansDic.keys).sorted()[indexPath.section] // 0
        let plann = plansDic[key]?[indexPath.row]
        (cell.viewWithTag(1) as? UILabel)!.text = plann?.startTime
        (cell.viewWithTag(2) as? UILabel)!.text = plann?.finishTime
        (cell.viewWithTag(3) as? UILabel)!.text = plann?.planText
        return cell
      }
}
