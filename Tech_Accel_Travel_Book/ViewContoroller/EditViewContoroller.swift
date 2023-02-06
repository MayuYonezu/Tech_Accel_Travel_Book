import UIKit
import RealmSwift

class EditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    var pickerView = UIPickerView()
    var data = [L10n.day1, L10n.day2, L10n.day3, L10n.day4,L10n.day5, L10n.day6, L10n.day7]
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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tapGesture.cancelsTouchesInView = false
        getProjectId()
        setUpDesign()
        navigationDesign()
        // SaveButton
        saveButtonItem = UIBarButtonItem(title: L10n.save,
                                         style: .plain,
                                         target: self,
                                         action: #selector(saveButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = saveButtonItem
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
    func getProjectId() {
        guard let projectId = MainRealm.shared.realm?.objects(Project.self) else {
            return
        }
        idLabel.text = String(projectId.count)
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
        alertController.addAction(UIAlertAction(title: L10n.ok,
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
    func setUpDesign() {
        titleLabel.placeholder = L10n.enterTitle
        startDay.placeholder = L10n.departureDate
        finishDay.placeholder = L10n.lastDate
        startTimeTextField.placeholder = L10n.timeToStart
        finishTimeTextField.placeholder = L10n.timeToFinish
        daySectionTextField.placeholder = L10n.dateSelect
        detailTextFiled.placeholder = L10n.appointmentDetails
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
        let missionArray = [L10n.takeAGoodPicture, L10n.takeFunnyPictures, L10n.takeAStylishVlog, L10n.post10StoriesPerDay, L10n.shootAndEditYouTuberLikeVideos]
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
        alert(title: L10n.success,
              message: L10n.saveCompleted)
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
        guard let realm = MainRealm.shared.realm else {
            return
        }
        
        try? realm.write({
            realm.add(project) // レコードを追加
        })
        print(project)
        
        try? realm.write({
            for plan in plans {
                project.plans.append(plan)
            }
        })
    }
    @IBAction func addButton() {
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
        appearance.backgroundColor = UIColor(asset: Asset.mainPink)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        saveButtonItem = UIBarButtonItem(title: L10n.save,
                                         style: .plain,
                                         target: self,
                                         action: #selector(saveButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = saveButtonItem
        getPlanData()
        getPlanDicData()
    }
}
