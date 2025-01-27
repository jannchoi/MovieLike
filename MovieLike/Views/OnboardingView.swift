//
//  OnboardingView.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit
import SnapKit

class OnboardingView: BaseView {
    let mainImageView = UIImageView()
    let onboardingLabel = UILabel()
    let descriptionLabel = UILabel()
    let startButton = UIButton()
    
    override func configureHierachy() {
        addSubview(mainImageView)
        addSubview(onboardingLabel)
        addSubview(descriptionLabel)
        addSubview(startButton)
    }
    override func configureLayout() {
        mainImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(500)
        }
        
        onboardingLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(10)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(50)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(onboardingLabel.snp.bottom).offset(17)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(100)
        }
        startButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(40)
        }
    }
    override func configureView() {
        backgroundColor = .black
        mainImageView.image = UIImage(named: "onboarding")
        onboardingLabel.labelDesign(inputText: "Onboarding", size: 27,weight: .bold, color: .white, alignment: .center)
        descriptionLabel.labelDesign(inputText: "당신만의 영화 세상, MovieLike를 시작해보세요.", size: 17, color: .white, alignment: .center)

        startButton.setButtonTitle(title: "시작하기", color: UIColor.MyBlue.cgColor, size: 17, weight: .bold)
        startButton.backgroundColor = .black
        startButton.clipsToBounds = true
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.MyBlue.cgColor
        DispatchQueue.main.async {
            self.startButton.layer.cornerRadius = self.startButton.frame.height / 2

        }

    }
}
