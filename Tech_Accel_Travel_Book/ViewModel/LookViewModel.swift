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
    var fetch: PublishRelay<Int> { get }
}

protocol LookViewModelOutput {
    var projectDataRelay: PublishRelay<Project> { get }
    var plansRelay: PublishRelay<List<Plan>> { get }
//    var plansDictionary: PublishRelay<[String: [Plan]]> { get }
}

protocol LookViewModelType {
    var input: LookViewModelInput { get }
    var output: LookViewModelOutput { get }
}

final class LookViewModel: LookViewModelType, LookViewModelInput, LookViewModelOutput {

    var input: LookViewModelInput { self }
    var output: LookViewModelOutput { self }

    //input
    let fetch: PublishRelay<Int> = PublishRelay()

    //output
    var projectDataRelay: PublishRelay<Project> = PublishRelay()
    var plansRelay: PublishRelay<List<Plan>> = PublishRelay()
//    var plansDictionary: PublishRelay<[String: [Plan]]> = PublishRelay()

    //extra
    private let disposeBag = DisposeBag()

    init() {

        fetch
            .subscribe(with: self) { owner, num in
                guard let projectData = MainRealm.shared.realm?.objects(Project.self).filter("id == '\(num)'") else {
                    return
                }
                owner.projectDataRelay.accept(projectData.last ?? ._rlmDefaultValue())

            }
            .disposed(by: disposeBag)

        projectDataRelay
            .subscribe(with: self) { owner, projectData in
//                owner.plansRelay.accept(projec)
            }
            .disposed(by: disposeBag)
    }

}
