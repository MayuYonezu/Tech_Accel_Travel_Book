import Foundation
import RealmSwift

protocol ListPresenterOutput: AnyObject {
    func fetchData()
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
    private weak var view: ListPresenterOutput?

    init(view: ListPresenterOutput) {
        self.view = view

        testSave()
    }
}

extension ListPresenter: ListPresenterInput {

    var numberOfProject: Int {
        self.projects.count
    }

    func returnProject(indexPath: IndexPath) -> Project {
        return self.projects[indexPath.row]
    }

    func didSelectRowAt(indexPath: IndexPath) {
        self.view?.transition(project: self.projects[indexPath.row])
    }

    func getProjectData() {
        guard let realm = MainRealm.shared.realm else {
            return
        }
        self.projects = realm.objects(Project.self).reversed()
        self.view?.fetchData()
    }

    // ここは保存のためのテスト用の記述です。
    private func testSave() {
        guard let realm = MainRealm.shared.realm else {
            return
        }
        var projectId: Results<Project>?
        let project: Results<Project>? = realm.objects(Project.self)
        projectId = project

        let mockPlan: Plan = {
            let plan = Plan()
            plan.planText = "planText"
            plan.startTime = "startText"
            plan.finishTime = "finishText"
            plan.daySection = "dayText"
            return plan
        }()

        let mockProject: Project = {
            let project = Project()
            project.id = "idText\(String(projectId!.count + 4))"
            project.title = "titleText"
            project.startDays = "startDayText"
            project.finishDays = "finishDayText"
            project.mission = "missionText"
            return project
        }()

        mockProject.plans.append(mockPlan)

        try? realm.write {
            realm.add(mockProject)
        }
    }
}
