//
//  LookViewModel.swift
//  Tech_Accel_Travel_Book
//
//  Created by 神原 良継 on 2023/03/09.
//

import Foundation
import RealmSwift
import RxSwift
import RxRelay

protocol LookViewModelInput {
    var fetchStart: PublishRelay<Void> { get }
}

protocol LookViewModelOutput {
    var projectDataRelay: BehaviorRelay<Project?> { get }
    var plansDictionaryRelay: BehaviorRelay<[String: [Plan]]> { get }
    var reloadDataRelay: PublishRelay<Void> { get }
}

protocol LookViewModelType {
    var input: LookViewModelInput { get }
    var output: LookViewModelOutput { get }
}

final class LookViewModel: LookViewModelType, LookViewModelInput, LookViewModelOutput {

    var input: LookViewModelInput { self }
    var output: LookViewModelOutput { self }

    // input
    let fetchStart: PublishRelay<Void> = PublishRelay()

    // output
    private(set) var projectDataRelay: BehaviorRelay<Project?> = BehaviorRelay(value: nil)
    private(set) var plansDictionaryRelay: BehaviorRelay<[String: [Plan]]> = BehaviorRelay(value: [:])
    private(set) var reloadDataRelay: PublishRelay<Void> = PublishRelay()

    // extra
    private let disposeBag = DisposeBag()

    init(projectID: String) {

        var plansDic = [String: [Plan]]()

        let project = fetchStart
            .compactMap { _ -> Project? in
                guard let projectData = MainRealm.shared.realm?.objects(Project.self).filter("id == '\(projectID)'"),
                      let project = projectData.last else {
                    return nil
                }
                return project
            }
            .share()

        project
            .subscribe(with: self) { owner, project in
                // output
                // projectをProjectDataRelayに流してる
                owner.projectDataRelay.accept(project)
            }
            .disposed(by: disposeBag)

        project
            .subscribe(with: self) { owner, project in
                let sortedPlans = project.plans.reversed()
                for getPlan in sortedPlans {
                    if plansDic.keys.contains(getPlan.daySection) {
                        plansDic[getPlan.daySection]?.append(getPlan)
                    } else {
                        plansDic[getPlan.daySection] = [getPlan]
                    }
                }
                // output
                // plansDictionaryRelayにplansDicを流す
                owner.plansDictionaryRelay.accept(plansDic)
            }
            .disposed(by: disposeBag)

        project
            .subscribe(with: self) { owner, _ in
                // output
                owner.reloadDataRelay.accept(())
            }
            .disposed(by: disposeBag)
    }
}
