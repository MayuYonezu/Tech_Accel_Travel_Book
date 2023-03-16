import Foundation
import RealmSwift

protocol LookPresenterInput: AnyObject {
    var numberOfProject: Int { get }
    func getPlanData()
    func getProjectData()
    func returnPlan(indexPath: IndexPath) -> Plan
    func returnProject(projectId: Int) -> Project
    var numberOfSection: Int { get }
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

    func returnProject(projectId: Int) -> Project {
        // ListVCで選択されたidのプロジェクトを取得
        return self.projects[projectId]
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

    var numberOfSection: Int {
        var sectionArray:[String] = []
        let plansNumber = self.plans.count
        for plansNumber in 0 ..< (plansNumber-1) {
            let plansDetail = self.plans[plansNumber]
            sectionArray.append(plansDetail.daySection)
        }
        sectionArray = Array(Set(sectionArray))
        return sectionArray.count
    }
}
