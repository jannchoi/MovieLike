//
//  OnboardingViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit

final class OnboardingViewController: UIViewController {

    private let mainView = OnboardingView()
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc func startButtonTapped() {
        navigationController?.pushViewController(ProfileSettingViewController(), animated: true)
    }
}
