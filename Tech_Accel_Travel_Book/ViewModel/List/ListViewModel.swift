import Foundation
import RealmSwift
import RxSwift
import RxRelay

protocol ListViewModelInput {
    var fetchStart: PublishRelay<Void> { get }
    var projectId: PublishRelay<Any> { get }
}

protocol ListViewModelOutput {
    var projectDataRelay: BehaviorRelay<Project?> { get }
    var projectDataCountRelay: BehaviorRelay<Int?> { get }
    var reloadDataRelay: PublishRelay<Void> { get }
}

protocol ListViewModelType {
    var input: ListViewModelInput { get }
    var output: ListViewModelOutput { get }
}

final class ListViewModel: ListViewModelType, ListViewModelInput, ListViewModelOutput {

    var input: ListViewModelInput { self }
    var output: ListViewModelOutput { self }

    // input
    let fetchStart: PublishRelay<Void> = PublishRelay()
    var projectId: RxRelay.PublishRelay<Any>

    // output
    private(set) var projectDataRelay: BehaviorRelay<Project?> = BehaviorRelay(value: nil)
    private(set) var projectDataCountRelay: RxRelay.BehaviorRelay<Int?>
    private(set) var reloadDataRelay: PublishRelay<Void> = PublishRelay()

    // extra
    private let disposeBag = DisposeBag()

    private(set) var projects: [Project] = []

    init() {

        // Realmからproject取得
        let project = fetchStart
            .compactMap { _ -> Project? in
                guard let realm = MainRealm.shared.realm else {
                    return
                }
                self.projects = realm.objects(Project.self).reversed()
                return project
            }
            .share()

        project
            .subscribe(with: self) { owner in
                owner.projectDataCountRelay.accept(projects.count)
            }
    }

}
