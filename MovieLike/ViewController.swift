//
//  ViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit

class ViewController: UIViewController {

    let mainView = OnboardingView()
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .Myblack
    }


}

