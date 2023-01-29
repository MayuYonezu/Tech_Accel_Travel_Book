import UIKit
import RealmSwift

class EditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    var pickerView = UIPickerView()
    var data = ["Day1", "Day2", "Day3", "Day4", "Day5", "Day6", "Day7"]
    @IBOutlet var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var startDay: UITextField!
    @IBOutlet weak var finishDay: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var detailTextFiled: UITextField!
    @IBOutlet var startTimeTextField: UITextField!
    @IBOutlet var finishTimeTextField: UITextField!
    @IBOutlet var daySectionTextField: UITextField!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    var alertController: UIAlertController!
    let datePicker = UIDatePicker()
    @IBOutlet var missionLabel: UILabel!
    var saveButtonItem: UIBarButtonItem!
    var proID: Results<Project>?
    var insertID: Int = 1
    var project = [Project]()
    var plans = [Plan]()
    var plansDic = [String: [Plan]]()
    let pink = UIColor(red: 242/255.0, green: 167/255.0, blue: 167/255.0, alpha: 1.0) // ボタン背景色設定
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tapGesture.cancelsTouchesInView = false
        getID()
        setUpDesign()
        navigationDesign()
        // SaveButton
        saveButtonItem = UIBarButtonItem(title: "Save",
                                         style: .plain,
                                         target: self,
                                         action: #selector(saveButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = saveButtonItem
        let projectData = realm.objects(Project.self)
        print("🟥全てのデータ\(projectData)")
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
        setUpPicker()
    }
    func setUpPicker() {
        pickerView.delegate = self
        daySectionTextField.inputView = pickerView
        // toolbar
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(EditViewController.donePicker))
        toolbar.setItems([doneButtonItem], animated: true)
        daySectionTextField.inputAccessoryView = toolbar
    }
    @objc func donePicker() {
        daySectionTextField.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        daySectionTextField.endEditing(true)
    }
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    func getID() {
        proID = realm.objects(Project.self)
        idLabel.text = String(proID!.count)
    }
    let startDayPicker: UIDatePicker = {
        let dayPicker = UIDatePicker()
        dayPicker.datePickerMode = UIDatePicker.Mode.date
        dayPicker.timeZone = NSTimeZone.local
        dayPicker.locale = Locale.init(identifier: "ja_JP")
        dayPicker.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dayPicker.addTarget(EditViewController.self, action: #selector(startDays), for: .valueChanged)
        return dayPicker
    }()
    let finishDayPicker: UIDatePicker = {
        let dayPicker = UIDatePicker()
        dayPicker.datePickerMode = UIDatePicker.Mode.date
        dayPicker.timeZone = NSTimeZone.local
        dayPicker.locale = Locale.init(identifier: "ja_JP")
        dayPicker.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dayPicker.addTarget(EditViewController.self, action: #selector(finishDays), for: .valueChanged)
        return dayPicker
    }()
    let startTimePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = UIDatePicker.Mode.time
        timePicker.timeZone = NSTimeZone.local
        timePicker.locale = Locale.init(identifier: "ja_JP")
        timePicker.timeZone = TimeZone(identifier: "Asia/Tokyo")
        timePicker.addTarget(EditViewController.self, action: #selector(startTime), for: .valueChanged)
        timePicker.minuteInterval = 10
        return timePicker
    }()
    let finishTimePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = UIDatePicker.Mode.time
        timePicker.timeZone = NSTimeZone.local
        timePicker.locale = Locale.init(identifier: "ja_JP")
        timePicker.timeZone = TimeZone(identifier: "Asia/Tokyo")
        timePicker.addTarget(EditViewController.self, action: #selector(finishTime), for: .valueChanged)
        timePicker.minuteInterval = 10
        return timePicker
    }()
    @objc func startDays() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        startDay.text = "\(formatter.string(from: startDayPicker.date))"
    }
    @objc func finishDays() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        finishDay.text = "\(formatter.string(from: finishDayPicker.date))"
    }
    @objc func startTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        startTimeTextField.text = "\(formatter.string(from: startTimePicker.date))"
    }
    @objc func finishTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        finishTimeTextField.text = "\(formatter.string(from: finishTimePicker.date))"
    }
    func alert(title: String, message: String) {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
    func setUpDesign() {
        titleLabel.placeholder = "タイトルを入力"
        startDay.placeholder = "出発日"
        finishDay.placeholder = "最終日"
        startTimeTextField.placeholder = "始まる時間"
        finishTimeTextField.placeholder = "終わる時間"
        daySectionTextField.placeholder = "日程選択"
        detailTextFiled.placeholder = "予定の詳細"
        mission_random()
        startDay.delegate = self
        startDay.inputView = startDayPicker
        finishDay.delegate = self
        finishDay.inputView = finishDayPicker
        startTimeTextField.delegate = self
        startTimeTextField.inputView = startTimePicker
        finishTimeTextField.delegate = self
        finishTimeTextField.inputView = finishTimePicker
    }
    @IBAction func mission_update() {
        mission_random()
    }
    func mission_random() {
        let missionArray = ["映えな写真を撮る", "おしゃれなVlogを撮る", "ストーリーを1日10個載せる", "YouTuber風な動画を撮って編集", "面白写真を撮る"]
        let randomMission = missionArray.randomElement()
        missionLabel.text = randomMission
    }
    @objc func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard
            idLabel.text != nil,
            titleLabel.text != nil,
            startDay.text != nil,
            finishDay.text != nil,
            missionLabel.text != nil else {return}
        print("プロジェクト保存")
        alert(title: "Success",
              message: "保存が完了しました")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    func saveProject() {
        guard let idText = idLabel.text,
              let titleText = titleLabel.text,
              let startDayText = startDay.text,
              let finishDayText = finishDay.text,
              let missionText = missionLabel.text else { return }
        let project = Project()
        project.id = idText
        project.title = titleText
        project.startDays = startDayText
        project.finishDays = finishDayText
        project.mission = missionText
        do {
            try realm.write({
                realm.add(project) // レコードを追加
            })
        } catch {}
        print(project)
        do {
            try realm.write({
                for plan in plans {
                    project.plans.append(plan)
                }
            })
        } catch {}
    }
    @IBAction func addBtn() {
        guard
            detailTextFiled.text != nil,
            startTimeTextField.text != nil,
            finishTimeTextField.text != nil,
            daySectionTextField.text != nil else {return}
        savePlan()
        detailTextFiled.text = ""
        startTimeTextField.text = ""
        finishTimeTextField.text = ""
        daySectionTextField.text = ""
        tableView.reloadData()
        print("保存")
    }
    func savePlan() {
        guard let planText = detailTextFiled.text,
              let startText = startTimeTextField.text,
              let finishText = finishTimeTextField.text,
              let dayText = daySectionTextField.text
        else { return }
        let plan = Plan()
        plan.planText = planText
        plan.startTime = startText
        plan.finishTime = finishText
        plan.daySection = dayText
        plans.append(plan)
        print("Planを保存しました")
        getPlanDicData()
    }
    func getPlanData() {

        plans = []
        tableView.reloadData() // テーブルビューをリロード
    }
    func getPlanDicData() {
        plansDic = [:]
        for getPlan in plans {
            if plansDic.keys.contains(getPlan.daySection) {
                plansDic[getPlan.daySection]?.append(getPlan)
            } else {
                plansDic[getPlan.daySection] = [getPlan]
            }
        }
        tableView.reloadData()
    }
}

extension EditViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = Array(plansDic.keys).sorted()
        let key = array[section]
        return plansDic[key]?.count ?? 0
        // return plans.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return plansDic.keys.count
    }
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
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        let key = Array(plansDic.keys).sorted()
        print("1. ", key)
        plansDic[key[indexPath.section]]!.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        print("2. ", plansDic)
        if plansDic[key[indexPath.section]]!.count == 0 {
            plansDic.removeValue(forKey: String(key[indexPath.section]))
            print("3. ", plansDic)
        }
        plans.remove(at: indexPath.row)
        print(plansDic)
        tableView.reloadData()
        print("削除します")
    }
    func tableView(_ tableView: UITableView,
                   moveRowAt fromIndexPath: IndexPath,
                   indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension EditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        daySectionTextField.text = data[row]
        print(data[row])
        print(plansDic)
    }
}

extension EditViewController: UINavigationControllerDelegate {
    func navigationDesign() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = pink
        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        saveButtonItem = UIBarButtonItem(title: "Save",
                                         style: .plain,
                                         target: self,
                                         action: #selector(saveButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = saveButtonItem
        getPlanData()
        getPlanDicData()
    }
}
