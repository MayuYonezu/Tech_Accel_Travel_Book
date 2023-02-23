//
//  MainRealm.swift
//  Tech_Accel_Travel_Book
//
//  Created by Mayu Yonezu on 2023/01/30.
//

import Foundation
import RealmSwift

// 共通のRealmに対してどこからでもアクセスできるようにシングルトンクラスを作成
final class MainRealm {
    static let shared = MainRealm()
    let realm: Realm?

    init() {
        let realm = try? Realm()
        self.realm = realm
    }
}
