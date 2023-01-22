//
//  Project.swift
//  MissionTravel
//
//  Created by Mayu Yonezu on 2022/06/08.
//

import Foundation
import RealmSwift

class Project: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var startDays: String = ""
    @objc dynamic var finishDays: String = ""
    @objc dynamic var mission: String = ""
    let plans = List<Plan> ()
    override static func primaryKey() -> String? {
            return "id"
        }
}

class Plan: Object {
    // @objc dynamic var planDay: String = ""
    @objc dynamic var planText: String = ""
    @objc dynamic var startTime: String = ""
    @objc dynamic var finishTime: String = ""
    @objc dynamic var daySection: String = ""
    
//    override static func primaryKey() -> String? {
//            return "daySection"
//        }
    let parentCategory = LinkingObjects(fromType: Project.self, property: "plans")
}
let realm = try! Realm()
let sortedStartTime = realm.objects(Plan.self).sorted(byKeyPath: "startTime")
