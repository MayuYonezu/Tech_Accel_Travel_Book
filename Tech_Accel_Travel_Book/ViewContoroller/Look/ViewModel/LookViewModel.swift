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
    var projectData: PublishRelay<Project> { get }
//    var plans: PublishRelay<List<Plan>> { get }
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
    var projectData: PublishRelay<Project> = PublishRelay()
//    var plans: PublishRelay<List<Plan>> = PublishRelay()
//    var plansDictionary: PublishRelay<[String: [Plan]]> = PublishRelay()

    //extra
    private let disposeBag = DisposeBag()
    private var model: LookModel

    init() {
        self.model = LookModel()

        fetch
            .subscribe(with: self) { owner, num in
                owner.model.realm_process(num: num)

                //publishRelayに保存
//                owner.projectData.accept(owner.model.projectData.projectData)
            }
            .disposed(by: disposeBag)

    }

}
