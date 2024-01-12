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

protocol WelcomeViewModelType {
  var input: WelcomeViewModelInput { get }
  var output: WelcomeViewModelOutput { get }
}

final class WelcomeViewModel: WelcomeViewModelInput, WelcomeViewModelOutput, WelcomeViewModelType {

    var input: WelcomeViewModelInput { self }
    var output: WelcomeViewModelOutput { self }

    // input
    let didTapNewProjectButton: PublishRelay<Void> = PublishRelay()
    let didTapProjectListButton: PublishRelay<Void> = PublishRelay()

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
