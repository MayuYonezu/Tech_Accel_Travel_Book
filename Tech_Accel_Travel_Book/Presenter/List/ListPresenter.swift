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
        print("projects:\(projects)")
        self.view?.fetchData()
    }
}
