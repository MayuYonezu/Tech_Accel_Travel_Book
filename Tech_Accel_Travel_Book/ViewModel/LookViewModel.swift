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
    var fetchStart: PublishRelay<Int> { get }
}

protocol LookViewModelOutput {
    var projectDataRelay: PublishRelay<Project> { get }
    var plansRelay: PublishRelay<List<Plan>> { get }
    var plansDictionaryRelay: PublishRelay<[String: [Plan]]> { get }
}

protocol LookViewModelType {
    var input: LookViewModelInput { get }
    var output: LookViewModelOutput { get }
}

final class LookViewModel: LookViewModelType, LookViewModelInput, LookViewModelOutput {

    var input: LookViewModelInput { self }
    var output: LookViewModelOutput { self }

    //input
    let fetchStart: PublishRelay<Int> = PublishRelay()

    //output
    var projectDataRelay: PublishRelay<Project> = PublishRelay()
    var plansRelay: PublishRelay<List<Plan>> = PublishRelay()
    var plansDictionaryRelay: PublishRelay<[String: [Plan]]> = PublishRelay()

    //extra
    private let disposeBag = DisposeBag()

    init() {

        var plansDic = [String: [Plan]]()

        fetchStart
            .subscribe(with: self) { owner, num in
                guard let projectData = MainRealm.shared.realm?.objects(Project.self).filter("id == '\(num)'") else {
                    return
                }
                owner.projectDataRelay.accept(projectData.last ?? ._rlmDefaultValue())

            }
            .disposed(by: disposeBag)

        projectDataRelay
            .subscribe(with: self) { owner, projectData in
                owner.plansRelay.accept(projectData.plans)
            }
            .disposed(by: disposeBag)

        plansRelay
            .subscribe(with: self) { owner, plans in
                let sortedPlans = plans.reversed()
                print(plans)
                for getPlan in sortedPlans {
                    if plansDic.keys.contains(getPlan.daySection) {
                        plansDic[getPlan.daySection]?.append(getPlan)
                    } else {
                        plansDic[getPlan.daySection] = [getPlan]
                    }
                }
                owner.plansDictionaryRelay.accept(plansDic)
            }
            .disposed(by: disposeBag)
    }

}
