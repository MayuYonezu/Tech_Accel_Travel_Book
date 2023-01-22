//
//  ViewController.swift
//  MissionTravel
//
//  Created by Mayu Yonezu on 2022/06/06.
//

import UIKit

class ViewController: UIViewController {
    
    // 新規作成ボタン
    @IBOutlet var newBtn: UIButton!
    // リスト一覧ボタン
    @IBOutlet var listBtn: UIButton!
    
    //ピンク
    let pink = UIColor(red: 242/255.0, green: 167/255.0, blue: 167/255.0, alpha: 1.0) // ボタン背景色設定

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NavigationDesign()
    }
    
    //NavigationBarデザイン
    func NavigationDesign(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = pink
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "home"
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
    }


}

