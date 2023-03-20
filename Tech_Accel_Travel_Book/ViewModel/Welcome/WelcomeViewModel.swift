import UIKit
import RxSwift
import RxRelay

protocol WelcomeViewModelInput {
    var didTapNewProjectButton: PublishRelay<Void> { get }
    var didTapProjectListButton: PublishRelay<Void> { get }
}

protocol WelcomeViewModelOutput {
    var nextVC: PublishRelay<Void> { get }
}

//protocol WelcomeViewModelOutput {
//
//}

final class WelcomeViewModel: WelcomeViewModelInput, WelcomeViewModelOutput {

    var input: WelcomeViewModelInput { self }
    var output: WelcomeViewModelOutput { self }

    // input
    var didTapNewProjectButton: PublishRelay<Void> = PublishRelay()
    var didTapProjectListButton: PublishRelay<Void> = PublishRelay()

    // output
    private(set) var nextVC: PublishRelay<Void> = PublishRelay()

    // extra
    private let disposeBag = DisposeBag()

    init() {
        didTapProjectListButton
            .subscribe(with: self) { owner, _ in
                owner.nextVC.accept(())
        }
        .disposed(by: disposeBag)
    }
}
