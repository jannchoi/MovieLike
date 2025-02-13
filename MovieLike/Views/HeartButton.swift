//
//  HeartButton.swift
//  MovieLike
//
//  Created by 최정안 on 2/13/25.
//

import UIKit
final class HeartButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    var id: Int?
    init(id: Int) {
        print("heartButton init")
        self.id = id
        super.init(frame: .zero)
        setImage(UIImage(systemName: "heart"), for: .normal)
        tintColor = .MyBlue
        self.prepareDesign()
        
    }
    override var isSelected: Bool {
        didSet {
            self.toggleDesign()
        }
    }
    func toggleDesign() {
        guard let id else {return}

        if isSelected {
            if !UserDefaultsManager.like.contains(id) {
                UserDefaultsManager.like.append(id)
            }
            setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            if let idx = UserDefaultsManager.like.firstIndex(of: id) {
                UserDefaultsManager.like.remove(at: idx)
            }
            setImage((UIImage(systemName: "heart")), for: .normal)
        }
        print("toggleDesign", isSelected)
    }
    private func prepareDesign() {
        guard let id else {return}
        if UserDefaultsManager.like.contains(id) {
            isSelected = true
        }
        else {
            isSelected = false
        }
        toggleDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAction() {
        self.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
    }
    @objc func heartButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}
