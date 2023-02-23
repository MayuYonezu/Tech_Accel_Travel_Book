//
//  ListPresenter.swift
//  Tech_Accel_Travel_Book
//
//  Created by 新垣 清奈 on 2023/02/23.
//

import Foundation
import RealmSwift

protocol ListPresenterOutput: AnyObject {
    func fetchedData()
    func transition(project: Project)
}

protocol ListPresenterInput: AnyObject {
    var numberOfProject: Int { get }
    func didSelectRowAt(indexPath: IndexPath)
    func getProjectData()
    func returnProject(indexPath: IndexPath) -> Project
}

final class ListPresenter {

    private(set) var projects: [Project] = []
    private weak var output: ListPresenterOutput?

    init() {}
}

extension ListPresenter: ListPresenterInput {

    var numberOfProject: Int {
        self.projects.count
    }

    func returnProject(indexPath: IndexPath) -> Project {
        return self.projects[indexPath.row]
    }

    func didSelectRowAt(indexPath: IndexPath) {
        self.output?.transition(project: self.projects[indexPath.row])
    }

    func getProjectData() {
        guard let realm = MainRealm.shared.realm else {
            return
        }
        self.projects = realm.objects(Project.self).reversed()
    }
}
