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
    
    
    
    
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NavigationDesign()
    }
    
    //NavigationBarデザイン
    func NavigationDesign(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(asset: Asset.mainPink)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "home"
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
    }


}

