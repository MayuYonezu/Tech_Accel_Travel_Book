import Foundation
import RealmSwift

protocol LookPresenterInput: AnyObject {
    var numberOfProject: Int { get }
    func getPlanData()
    func getProjectData()
    func returnPlan(indexPath: IndexPath) -> Plan
    func returnProject() -> Project
}

final class LookPresenter {

    private(set) var projects: [Project] = []
    private(set) var plans: [Plan] = []

    init() {}
}

extension LookPresenter: LookPresenterInput {

    var numberOfProject: Int {
        self.plans.count
    }

    func returnPlan(indexPath: IndexPath) -> Plan {
        return self.plans[indexPath.row]
    }

    func returnProject() -> Project {
        // ここのprojectナンバーの指定方法が知りたいです...！
        return self.projects[0]
    }

    func getPlanData() {
        guard let realm = MainRealm.shared.realm else {
            return
        }
        self.plans = realm.objects(Plan.self).reversed()
    }

    func getProjectData() {
        guard let realm = MainRealm.shared.realm else {
            return
        }
        self.projects = realm.objects(Project.self).reversed()
    }

}
