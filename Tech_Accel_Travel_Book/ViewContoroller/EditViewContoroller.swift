//
//  EditViewController.swift
//  MissionTravel
//
//  Created by Mayu Yonezu on 2022/06/06.
//

import UIKit
import RealmSwift



class EditViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return 7
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return data[row]
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            DaySectionTextField.text = data[row]
            print(data[row])
            print(plansDic)
        }
    
    var pickerView = UIPickerView()
    var data = ["Day1","Day2","Day3","Day4","Day5","Day6","Day7"]
    
    
    // テキストフィールドに表示させる用
    @IBOutlet var idLabel:UILabel!
    // 旅行のタイトル記入
    @IBOutlet weak var TitleLabel: UITextField!
    // 初日
    @IBOutlet weak var StartDay: UITextField!
    // 最終日
    @IBOutlet weak var FinishDay: UITextField!
    
    //スケジュールを表示させるためのTebleView
    @IBOutlet var tableView: UITableView!
    // 予定の詳細を書くためTextField
    @IBOutlet var detailTextFiled: UITextField!
    // 予定の始まる時間
    //@IBOutlet weak var StartTimePicker: UIDatePicker!
    @IBOutlet var StartTimeTextField: UITextField!
    // 予定の終わりの時間
    //@IBOutlet weak var FinishTimePicker: UIDatePicker!
    @IBOutlet var FinishTimeTextField: UITextField!
    // Section選択するためのTextField
    @IBOutlet var DaySectionTextField: UITextField!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    //Section選択するためのPicker
    // @IBOutlet var SectionPicker: UIPickerView!
    
    // var data = ["Day1","Day2","Day3","Day4","Day5","Day6","Day7"]
    
    // アラート表示
    var alertController: UIAlertController!
    
    
    let datePicker = UIDatePicker()
    @IBOutlet var MissionLabel: UILabel!
    var saveButtonItem: UIBarButtonItem!
    
    var proID:Results<Project>?
    var insertID:Int = 1
    
    // 保存
    let realm = try! Realm()
    var project = [Project]()
    var plans = [Plan]()
    var plansDic = [String : [Plan]]()
    
    //ピンク
    let pink = UIColor(red: 242/255.0, green: 167/255.0, blue: 167/255.0, alpha: 1.0) // ボタン背景色設定
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableView初期設定
        tableView.delegate = self
        tableView.dataSource = self
        
        // 閉じる作業
        tapGesture.cancelsTouchesInView = false
        
        getID()
        
        let realm = try! Realm() //デフォルトRealmの取得
        
        SetUpDesign()
        NavigationDesign()
        
        
        //SaveButton
        saveButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = saveButtonItem
        
        let projectData = realm.objects(Project.self)
        print("🟥全てのデータ\(projectData)")
        
        // 並べ替えるたのやつ
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
        
        SetUpPicker()
  
    }
    
    // セクションが選択されたときの動作
    func SetUpPicker(){
        pickerView.delegate = self
        DaySectionTextField.inputView = pickerView
        // toolbar
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EditViewController.donePicker))
        toolbar.setItems([doneButtonItem], animated: true)
        DaySectionTextField.inputAccessoryView = toolbar
    }
    
    @objc func donePicker() {
        DaySectionTextField.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DaySectionTextField.endEditing(true)
    }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
            //キーボードを閉じる処理
            view.endEditing(true)
        }
    
    
    
    func getID(){
        let realm = try! Realm() //デフォルトRealmの取得
        proID = realm.objects(Project.self) //全データの取得
        
        idLabel.text = String(proID!.count)
            
    }
    
    // 始まる日にちの入力
    let StartDayPicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = UIDatePicker.Mode.date
        dp.timeZone = NSTimeZone.local
        //時間をJapanese(24時間表記)に変更
        dp.locale = Locale.init(identifier: "ja_JP")
        dp.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        dp.addTarget(self, action: #selector(StartDays), for: .valueChanged)
        return dp
    }()
    // 終わる日にちの入力
    let FinishDayPicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = UIDatePicker.Mode.date
        dp.timeZone = NSTimeZone.local
        //時間をJapanese(24時間表記)に変更
        dp.locale = Locale.init(identifier: "ja_JP")
        dp.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        dp.addTarget(self, action: #selector(FinishDays), for: .valueChanged)
        return dp
    }()
    
    // 始まる時間
    let StartTimePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = UIDatePicker.Mode.time
        dp.timeZone = NSTimeZone.local
        //時間をJapanese(24時間表記)に変更
        dp.locale = Locale.init(identifier: "ja_JP")
        dp.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        dp.addTarget(self, action: #selector(StartTime), for: .valueChanged)
        //最小単位（分）を設定
        dp.minuteInterval = 10
        return dp
    }()
    
    let FinishTimePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = UIDatePicker.Mode.time
        dp.timeZone = NSTimeZone.local
        //時間をJapanese(24時間表記)に変更
        dp.locale = Locale.init(identifier: "ja_JP")
        dp.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        dp.addTarget(self, action: #selector(FinishTime), for: .valueChanged)
        //最小単位（分）を設定
        dp.minuteInterval = 10
        return dp
    }()
    
    @objc func StartDays(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        StartDay.text = "\(formatter.string(from: StartDayPicker.date))"
        }
    
    @objc func FinishDays(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        FinishDay.text = "\(formatter.string(from: FinishDayPicker.date))"
        }
    
    @objc func StartTime(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        StartTimeTextField.text = "\(formatter.string(from: StartTimePicker.date))"
        }
    
    @objc func FinishTime(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        FinishTimeTextField.text = "\(formatter.string(from: FinishTimePicker.date))"
        }
    
    
    // NavigationBar装飾
    func NavigationDesign(){
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = pink
        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        //SaveButton
        saveButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = saveButtonItem
        
        getPlanData()
        getPlanDicData()
        
    }
    
    func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
    
    func SetUpDesign (){
        
        TitleLabel.placeholder = "タイトルを入力"
        StartDay.placeholder = "出発日"
        FinishDay.placeholder = "最終日"
        StartTimeTextField.placeholder = "始まる時間"
        FinishTimeTextField.placeholder = "終わる時間"
        DaySectionTextField.placeholder = "日程選択"
        detailTextFiled.placeholder = "予定の詳細"
        mission_random()
        
        StartDay.delegate = self
        StartDay.inputView = StartDayPicker
        
        FinishDay.delegate = self
        FinishDay.inputView = FinishDayPicker
        
        StartTimeTextField.delegate = self
        StartTimeTextField.inputView = StartTimePicker
        
        FinishTimeTextField.delegate = self
        FinishTimeTextField.inputView = FinishTimePicker
        
    }
    
    
    // Missionを更新するためのアクション
    @IBAction func mission_update(){
        mission_random()
    }
    
    //　Missionのランダム生成+ラベルに表示
    func mission_random(){
        // ミッションが入ったArray
        let missionArray = ["映えな写真を撮る","おしゃれなVlogを撮る","ストーリーを1日10個載せる","YouTuber風な動画を撮って編集","面白写真を撮る"]
        // missionArrayからランダムに値を取り出す
        let randomMission = missionArray.randomElement()
        // missionLabelに表示させる
        MissionLabel.text = randomMission
    }
    
    // セーブボタンが押された時のアクション
    @objc func saveButtonPressed(_ sender: UIBarButtonItem){
        
        guard let _ = idLabel.text,
        let _ = TitleLabel.text,
        let _ = StartDay.text,
        let _ = FinishDay.text,
        let _ = MissionLabel.text else {return}
        
        saveProject()
        print("プロジェクト保存")
        
        alert(title: "Success",
              message: "保存が完了しました")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // 1秒後にHome画面に戻る
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    // 企画保存
    func saveProject(){
        guard let idText = idLabel.text,
              let titleText = TitleLabel.text,
              let startDayText = StartDay.text,
              let finishDayText = FinishDay.text,
              let missionText = MissionLabel.text else { return }
        
        let project = Project()
        project.id = idText
        project.title = titleText
        project.startDays = startDayText
        project.finishDays = finishDayText
        project.mission = missionText
        
        try! realm.write({
            realm.add(project) // レコードを追加
        })
        print(project)
        
        
        // planの内容も記録する
        try! realm.write(){
            for plan in plans {
                project.plans.append(plan)
            }
        }
    }
    
    // "予定を追加"をタップされたとき
    @IBAction func addBtn(){
        guard let _ = detailTextFiled.text,
        let _ = StartTimeTextField.text,
        let _ = FinishTimeTextField.text,
        let _ = DaySectionTextField.text
        else {return}
        
        savePlan()
        
        // detailTextFieldを初期化する
        detailTextFiled.text = ""
        StartTimeTextField.text = ""
        FinishTimeTextField.text = ""
        DaySectionTextField.text = ""
        tableView.reloadData()
        print("保存")
        
        
    }
    
    // 予定を保存
    func savePlan(){
        
        guard let planText = detailTextFiled.text,
        let startText = StartTimeTextField.text,
        let finishText = FinishTimeTextField.text,
        let dayText = DaySectionTextField.text
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
    
    // Realmからデータを取得してテーブルビューを再リロードするメソッド
    func getPlanData() {
        // plansの中身は現段階ではからの状態
        plans = []
        tableView.reloadData() // テーブルビューをリロード
    }
    
    // Realmからデータを取得してPlanDicに値を入れる
    func getPlanDicData(){
        // 全部の値が取得されてしまう
        // plans = Array(realm.objects(Plan.self)).reversed()
        
        plansDic = [:]
        for p in plans {
            if plansDic.keys.contains(p.daySection) {
                // ディクショナリーの鍵に日付が含まれてたら、kを追加
                plansDic[p.daySection]?.append(p)
            } else {
                // ディクショナリーの鍵に日付が含まれてなかったら配列を初期化
                plansDic[p.daySection] = [p]
            }
            
        }
        tableView.reloadData()
    }
    
    
}

extension EditViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = Array(plansDic.keys).sorted()
        let key = array[section]
        return plansDic[key]?.count ?? 0
       // return plans.count
      }
    
    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return plansDic.keys.count
    }

    //セクションのタイトル
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
    
//    // TableViewを削除する
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // 変更前
//            // plans.remove(at: indexPath.row)
//            // 変更後
//            var key = Array(plansDic.keys)
//            key.remove(at: indexPath.row)
//
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            print("削除します")
//        }#imageLiteral(resourceName: "simulator_screenshot_781E4049-CE45-4C8F-9C54-3D4FD94E2C03.png")
//
//    }
    
    //TableViewを削除する
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            // keyにplansDic(辞書型)のkey(セクション)の配列を（sortした状態のもの）代入
            let key = Array(plansDic.keys).sorted()
            print("1. ", key)
            
            //planDicのkeyセクションの中からcellの値を削除
            plansDic[key[indexPath.section]]!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            print("2. ", plansDic)
            //もしもセクションの中のcellの値が0になったら
            if plansDic[key[indexPath.section]]!.count == 0{
                //セクションの表示を削除する削除する
                plansDic.removeValue(forKey: String(key[indexPath.section]))
                print("3. ",plansDic)
            }
            
            plans.remove(at: indexPath.row)
            
            print(plansDic)
            // tableViewをリロードする
            // todokebetsunonakamiが更新されたので保存
            // UserDefaults.standard.set(plansDic, forKey: String(key[indexPath.section]) )

            tableView.reloadData()


            print("削除します")
        }

    // TableViewを並べかえる
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        try! realm.write {
//            let key = Array(plansDic.keys).sorted()
//            let listItem = plansDic[key[fromIndexPath.row]]
//            // plansDic.remove(at: fromIndexPath.row)
//            plansDic[key[fromIndexPath.section]]!.remove(at: fromIndexPath.row)
//            plans.insert(listItem, at: to.row)
//            tableView.reloadData()
//            print("並べ替えます")
//        }
    }
    
    //並び替えを可能にする
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}
