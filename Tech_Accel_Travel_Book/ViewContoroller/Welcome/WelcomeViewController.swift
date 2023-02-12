//
//  ViewController.swift
//  MissionTravel
//
//  Created by Mayu Yonezu on 2022/06/06.
//

import UIKit

final class WelcomeViewController: UIViewController {
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(asset: Asset.logo)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    // 新規作成ボタン
    private let newProjectButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.newProject, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(asset: Asset.mainPink), for: .normal)
        return button
    }()
    // リスト一覧ボタン
    private let projectListButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.projectList, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(asset: Asset.mainPink), for: .normal)
        return button
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Layout
        view.addSubview(logoImageView)
        view.addSubview(newProjectButton)
        view.addSubview(projectListButton)

        // Navigation Bar Layout
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(asset: Asset.mainPink)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.home
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // logoImageView Layout
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 246)
        ])

        // newProjectButton Layout
        NSLayoutConstraint.activate([
            newProjectButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 70),
            newProjectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])

        // projectListButton Layout
        NSLayoutConstraint.activate([
            projectListButton.topAnchor.constraint(equalTo: newProjectButton.bottomAnchor, constant: 10),
            projectListButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])

        // AddTarget
        projectListButton.addTarget(self, action: #selector(toLookVC), for: .touchUpInside)
    }

    @objc func toLookVC() {
        let lookVC = LookViewController()
        self.navigationController?.pushViewController(lookVC, animated: true)
    }
}
