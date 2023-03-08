//
//  LookModel.swift
//  Tech_Accel_Travel_Book
//
//  Created by 神原 良継 on 2023/03/09.
//

import Foundation
import RealmSwift

struct LookModel {
//    var num: Int
//
//    init(num: Int) {
//        self.num = num
//    }

//    var projectData: Project
//
//    init(projectData: Project) {
//        self.projectData = projectData
//    }

    mutating func realm_process(num: Int) -> Project {
        guard let projectData = MainRealm.shared.realm?.objects(Project.self).filter("id == '\(num)'") else {
            return
        }
        return projectData.last
    }
}
