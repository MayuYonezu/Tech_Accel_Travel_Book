//
//  MainRealm.swift
//  Tech_Accel_Travel_Book
//
//  Created by Mayu Yonezu on 2023/01/30.
//

// Realmに保存された情報を取得するため作成
import Foundation
import RealmSwift

class MainRealm {
    // シングルトンパターン
    static let shared = MainRealm()
    let realm: Realm?

    init() {
        let realm = try? Realm()
        self.realm = realm
    }
}
