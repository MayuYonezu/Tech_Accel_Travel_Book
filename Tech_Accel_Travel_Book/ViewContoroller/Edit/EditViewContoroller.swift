import UIKit
import RealmSwift

final class EditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate {
    private let pickerView = UIPickerView()
    private let data = [L10n.day1, L10n.day2, L10n.day3, L10n.day4, L10n.day5, L10n.day6, L10n.day7]
    @IBOutlet var detailTextFiled: UITextField!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    private var alertController: UIAlertController!
    private let datePicker = UIDatePicker()
    private var saveButtonItem: UIBarButtonItem!
    private var proID: Results<Project>?
    private var insertID: Int = 1
    private let projects = [Project]()
    private var plans = [Plan]()
    private var plansDic = [String: [Plan]]()
    private var selectProjectId: String = "0"

    // missionTitleLable生成
    private let missionLabel: UILabel = {
        let label = UILabel()
        label.text = "Mission"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(asset: Asset.mainPink)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // missionLabel生成
    private let selectMissionLabel: UILabel = {
        let label = UILabel()
        label.text = "aaa"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let pinkLineView1: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(asset: Asset.mainPink)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let pinkLineView2: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(asset: Asset.mainPink)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let missionUpdateButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(asset: Asset.missionKousin), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        return button
    }()
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = L10n.enterTitle
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let startDayTextField: UITextField = {
        let textFiled = UITextField()
        textFiled.borderStyle = .roundedRect
        textFiled.placeholder = L10n.departureDate
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        return textFiled
    }()
    private let finishDayTextField: UITextField = {
        let textFiled = UITextField()
        textFiled.borderStyle = .roundedRect
        textFiled.placeholder = L10n.lastDate
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        return textFiled
    }()
    // tildeLabel生成
    private let tildeLabel: UILabel = {
        let label = UILabel()
        label.text = "~"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let addScheduleButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.addSchedule, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor(asset: Asset.mainPink), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        return button
    }()
    private let detailScheduleTextField: UITextField = {
        let textFiled = UITextField()
        textFiled.borderStyle = .roundedRect
        textFiled.placeholder = L10n.appointmentDetails
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        return textFiled
    }()
    private let selectDayTextField: UITextField = {
        let textFiled = UITextField()
        textFiled.borderStyle = .roundedRect
        textFiled.placeholder = L10n.dateSelect
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        return textFiled
    }()
    private let startTimeTextField: UITextField = {
        let textFiled = UITextField()
        textFiled.borderStyle = .roundedRect
        textFiled.placeholder = L10n.timeToStart
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        return textFiled
    }()
    private let finishTimeTextField: UITextField = {
        let textFiled = UITextField()
        textFiled.borderStyle = .roundedRect
        textFiled.placeholder = L10n.timeToFinish
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        return textFiled
    }()
    // tableView
    private lazy var scheduleTableView: UITableView = {
        let table = UITableView()
        table.register(EditTableViewCell.self, forCellReuseIdentifier: EditTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
//        table.dataSource = self
//        table.delegate = self
        table.isEditing = true
        table.allowsSelectionDuringEditing = true
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(missionLabel)
        view.addSubview(selectMissionLabel)
        view.addSubview(pinkLineView1)
        view.addSubview(pinkLineView2)
        view.addSubview(missionUpdateButton)
        view.addSubview(titleTextField)
        view.addSubview(startDayTextField)
        view.addSubview(finishDayTextField)
        view.addSubview(tildeLabel)
        view.addSubview(addScheduleButton)
        view.addSubview(detailScheduleTextField)
        view.addSubview(selectDayTextField)
        view.addSubview(startTimeTextField)
        view.addSubview(finishTimeTextField)
        view.addSubview(scheduleTableView)
        tapGesture.cancelsTouchesInView = false
        getProjectId()
        setUpDesign()
//        navigationDesign()
        // SaveButton
//        saveButtonItem = UIBarButtonItem(title: L10n.save,
//                                         style: .plain,
//                                         target: self,
//                                         action: #selector(saveButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = saveButtonItem
        setUpPicker()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let screenSizeWidth = UIScreen.main.bounds.width - 40
        let screenSizeHeight = UIScreen.main.bounds.height
        // missionTitleLabel
        NSLayoutConstraint.activate([
            missionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            missionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        // selectMissionLabel
        NSLayoutConstraint.activate([
            selectMissionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            selectMissionLabel.leadingAnchor.constraint(equalTo: missionLabel.trailingAnchor, constant: 10)
        ])
        // pinkLineView1
        NSLayoutConstraint.activate([
            pinkLineView1.topAnchor.constraint(equalTo: missionLabel.bottomAnchor, constant: 2),
            pinkLineView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pinkLineView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pinkLineView1.heightAnchor.constraint(equalToConstant: 3)
        ])
        // missionUpdateButton
        NSLayoutConstraint.activate([
            missionUpdateButton.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            missionUpdateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            missionUpdateButton.heightAnchor.constraint(equalToConstant: 16),
            missionUpdateButton.widthAnchor.constraint(equalToConstant: 15)
        ])
        // titleTextField
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: pinkLineView1.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        // tildeLabel
        NSLayoutConstraint.activate([
            tildeLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            tildeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            startDayTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            startDayTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startDayTextField.trailingAnchor.constraint(equalTo: tildeLabel.leadingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            finishDayTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            finishDayTextField.leadingAnchor.constraint(equalTo: tildeLabel.trailingAnchor, constant: 20),
            finishDayTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            scheduleTableView.topAnchor.constraint(equalTo: tildeLabel.bottomAnchor, constant: 20),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scheduleTableView.heightAnchor.constraint(equalToConstant: screenSizeHeight * 0.45)
        ])
        // pinkLineView2
        NSLayoutConstraint.activate([
            pinkLineView2.topAnchor.constraint(equalTo: scheduleTableView.bottomAnchor, constant: 20),
            pinkLineView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pinkLineView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pinkLineView2.heightAnchor.constraint(equalToConstant: 3)
        ])
        NSLayoutConstraint.activate([
            selectDayTextField.topAnchor.constraint(equalTo: pinkLineView2.bottomAnchor, constant: 10),
            selectDayTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectDayTextField.widthAnchor.constraint(equalToConstant: screenSizeWidth * 0.3)
        ])
        NSLayoutConstraint.activate([
            finishTimeTextField.topAnchor.constraint(equalTo: pinkLineView2.bottomAnchor, constant: 10),
            finishTimeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishTimeTextField.widthAnchor.constraint(equalToConstant: screenSizeWidth * 0.3)
        ])
        NSLayoutConstraint.activate([
            startTimeTextField.topAnchor.constraint(equalTo: pinkLineView2.bottomAnchor, constant: 10),
            startTimeTextField.leadingAnchor.constraint(equalTo: selectDayTextField.trailingAnchor, constant: 10),
            startTimeTextField.trailingAnchor.constraint(equalTo: finishTimeTextField.leadingAnchor, constant: -10),
            startTimeTextField.widthAnchor.constraint(equalToConstant: screenSizeWidth * 0.3)
        ])
        NSLayoutConstraint.activate([
            detailScheduleTextField.topAnchor.constraint(equalTo: startTimeTextField.bottomAnchor, constant: 10),
            detailScheduleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailScheduleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            addScheduleButton.topAnchor.constraint(equalTo: detailScheduleTextField.bottomAnchor, constant: 10),
            addScheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            addScheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            addScheduleButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    private func setUpPicker() {
        pickerView.delegate = self
        selectDayTextField.inputView = pickerView
        // toolbar
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(EditViewController.donePicker))
        toolbar.setItems([doneButtonItem], animated: true)
        selectDayTextField.inputAccessoryView = toolbar
    }
    @objc func donePicker() {
        selectDayTextField.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectDayTextField.endEditing(true)
    }
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    private func getProjectId() {
        guard let projectId = MainRealm.shared.realm?.objects(Project.self) else {
            return
        }
        selectProjectId = String(projectId.count)
    }
    private let startDayPicker: UIDatePicker = {
        let dayPicker = UIDatePicker()
        dayPicker.datePickerMode = UIDatePicker.Mode.date
        dayPicker.timeZone = NSTimeZone.local
        dayPicker.locale = Locale.init(identifier: "ja_JP")
        dayPicker.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dayPicker.addTarget(EditViewController.self, action: #selector(startDays), for: .valueChanged)
        return dayPicker
    }()
    private let finishDayPicker: UIDatePicker = {
        let dayPicker = UIDatePicker()
        dayPicker.datePickerMode = UIDatePicker.Mode.date
        dayPicker.timeZone = NSTimeZone.local
        dayPicker.locale = Locale.init(identifier: "ja_JP")
        dayPicker.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dayPicker.addTarget(EditViewController.self, action: #selector(finishDays), for: .valueChanged)
        return dayPicker
    }()
    private let startTimePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = UIDatePicker.Mode.time
        timePicker.timeZone = NSTimeZone.local
        timePicker.locale = Locale.init(identifier: "ja_JP")
        timePicker.timeZone = TimeZone(identifier: "Asia/Tokyo")
        timePicker.addTarget(EditViewController.self, action: #selector(startTime), for: .valueChanged)
        timePicker.minuteInterval = 10
        return timePicker
    }()
    private let finishTimePicker: UIDatePicker = {
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
        startDayTextField.text = "\(formatter.string(from: startDayPicker.date))"
    }
    @objc func finishDays() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        finishDayTextField.text = "\(formatter.string(from: finishDayPicker.date))"
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
    private func alert(title: String, message: String) {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: L10n.ok,
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
    private func setUpDesign() {
        titleTextField.placeholder = L10n.enterTitle
        startDayTextField.placeholder = L10n.departureDate
        finishDayTextField.placeholder = L10n.lastDate
        startTimeTextField.placeholder = L10n.timeToStart
        finishTimeTextField.placeholder = L10n.timeToFinish
        selectDayTextField.placeholder = L10n.dateSelect
        detailTextFiled.placeholder = L10n.appointmentDetails
//        mission_random()
        startDayTextField.delegate = self
        startDayTextField.inputView = startDayPicker
        finishDayTextField.delegate = self
        finishDayTextField.inputView = finishDayPicker
        startTimeTextField.delegate = self
        startTimeTextField.inputView = startTimePicker
        finishTimeTextField.delegate = self
        finishTimeTextField.inputView = finishTimePicker
    }
//    @IBAction func mission_update() {
//        mission_random()
//    }
//    private func mission_random() {
//        let missionArray = [L10n.takeAGoodPicture,
//                            L10n.takeFunnyPictures,
//                            L10n.takeAStylishVlog,
//                            L10n.post10StoriesPerDay,
//                            L10n.shootAndEditYouTuberLikeVideos]
//        let randomMission = missionArray.randomElement()
//        missionLabel.text = randomMission
//    }
//    @objc func saveButtonPressed(_ sender: UIBarButtonItem) {
//        guard
//            selectProjectId != nil,
//            titleTextField.text != nil,
//            startDayTextField.text != nil,
//            finishDayTextField.text != nil,
//            missionLabel.text != nil else {return}
//        print("プロジェクト保存")
//        alert(title: L10n.success,
//              message: L10n.saveCompleted)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.navigationController?.popToRootViewController(animated: true)
//        }
//    }
//    private func saveProject() {
//        guard let titleText = titleTextField.text,
//              let startDayText = startDayTextField.text,
//              let finishDayText = finishDayTextField.text,
//              let missionText = missionLabel.text else { return }
//        let project = Project()
//        project.title = titleText
//        project.startDays = startDayText
//        project.finishDays = finishDayText
//        project.mission = missionText
//        guard let realm = MainRealm.shared.realm else {
//            return
//        }
//
//        try? realm.write({
//            realm.add(project) // レコードを追加
//        })
//        print(project)
//
//        try? realm.write({
//            for plan in plans {
//                project.plans.append(plan)
//            }
//        })
//    }
//    @IBAction func addButton() {
//        guard
//            detailTextFiled.text != nil,
//            startTimeTextField.text != nil,
//            finishTimeTextField.text != nil,
//            selectDayTextField.text != nil else {return}
//        savePlan()
//        detailTextFiled.text = ""
//        startTimeTextField.text = ""
//        finishTimeTextField.text = ""
//        selectDayTextField.text = ""
//        scheduleTableView.reloadData()
//
//    }
//    private func savePlan() {
//        guard let planText = detailTextFiled.text,
//              let startText = startTimeTextField.text,
//              let finishText = finishTimeTextField.text,
//              let dayText = selectDayTextField.text
//        else { return }
//        let plan = Plan()
//        plan.planText = planText
//        plan.startTime = startText
//        plan.finishTime = finishText
//        plan.daySection = dayText
//        plans.append(plan)
//        print("Planを保存しました")
//        getPlanDicData()
//    }
//    private func getPlanData() {
//        plans = []
//        scheduleTableView.reloadData() // テーブルビューをリロード
//    }
//    private func getPlanDicData() {
//        plansDic = [:]
//        for getPlan in plans {
//            if plansDic.keys.contains(getPlan.daySection) {
//                plansDic[getPlan.daySection]?.append(getPlan)
//            } else {
//                plansDic[getPlan.daySection] = [getPlan]
//            }
//        }
//        scheduleTableView.reloadData()
//    }
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return 7
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return data[row]
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectDayTextField.text = data[row]
//        print(data[row])
//        print(plansDic)
//    }
}

//extension EditViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        let array = Array(plansDic.keys).sorted()
////        let key = array[section]
////        return plansDic[key]?.count ?? 0
//        // return plans.count
//        1
//    }
//    func numberOfSections(in tableView: UITableView) -> Int {
////        return plansDic.keys.count
//        return 1
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
////        let array = Array(plansDic.keys).sorted()
////        let key = array[section]
////        return key
//        "test"
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
////        let key = Array(plansDic.keys).sorted()[indexPath.section] // 0
////        let plann = plansDic[key]?[indexPath.row]
////        (cell.viewWithTag(1) as? UILabel)!.text = plann?.startTime
////        (cell.viewWithTag(2) as? UILabel)!.text = plann?.finishTime
////        (cell.viewWithTag(3) as? UILabel)!.text = plann?.planText
////        return cell
//        guard let cell = scheduleTableView.dequeueReusableCell(withIdentifier: EditTableViewCell.identifier,
//                                                               for: indexPath) as? EditTableViewCell else {
//            fatalError()
//        }
////        let key = plansDictionary.keys.sorted()[indexPath.section]
////        let plan = plansDictionary[key]?[indexPath.row]
//        cell.setUp(startedTime: "00:00", finishTime: "00:00", planText: "planText")
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        scheduleTableView.deselectRow(at: indexPath, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView,
//                   commit editingStyle: UITableViewCell.EditingStyle,
//                   forRowAt indexPath: IndexPath) {
//        let key = Array(plansDic.keys).sorted()
//        print("1. ", key)
//        plansDic[key[indexPath.section]]!.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
//        print("2. ", plansDic)
//        if plansDic[key[indexPath.section]]!.count == 0 {
//            plansDic.removeValue(forKey: String(key[indexPath.section]))
//            print("3. ", plansDic)
//        }
//        plans.remove(at: indexPath.row)
//        print(plansDic)
//        tableView.reloadData()
//        print("削除します")
//    }
//    func tableView(_ tableView: UITableView,
//                   moveRowAt fromIndexPath: IndexPath,
//                   indexPath: IndexPath) {
//    }
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//}

//extension EditViewController: UINavigationControllerDelegate {
//    private func navigationDesign() {
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor(asset: Asset.mainPink)
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText]
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.standardAppearance = appearance
//        navigationItem.scrollEdgeAppearance = appearance
//        navigationItem.compactAppearance = appearance
//        saveButtonItem = UIBarButtonItem(title: L10n.save,
//                                         style: .plain,
//                                         target: self,
//                                         action: #selector(saveButtonPressed(_:)))
//        self.navigationItem.rightBarButtonItem = saveButtonItem
//        getPlanData()
//        getPlanDicData()
//    }
//}
