//
//  SearchTableViewCell.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import UIKit
import SnapKit


final class SearchTableViewCell: BaseTableViewCell {

    static let id = "SearchTableViewCell"
    
    private let posterImage = UIImageView()
    private let titleLable = UILabel()
    private let dateLabel = UILabel()
    private let genreStack = UIStackView()
    private lazy var heartButton = HeartButton(id: tag)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "SearchTableViewCell")
        self.isSkeletonable = true
        posterImage.isSkeletonable = true
        titleLable.isSkeletonable = true
        dateLabel.isSkeletonable = true
        genreStack.isSkeletonable = true
        heartButton.isSkeletonable = true
    }
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(item: MovieDetail, txt: String) {

        posterImage.setOptionalImage(imgPath: item.poster_path)
        titleLable.labelDesign(inputText: item.title, size: 14, weight: .bold, color: .white, lines: 2)
        titleLable.ColoringSubString(subString: txt)
        dateLabel.labelDesign(inputText: item.release_date?.dateFormat() ?? "None", size: 12, color: .MylightGray)
        configGenre(ids: item.genre_ids ?? [])
        
    }
    private func configGenre(ids: [Int]) {
        
        genreStack.arrangedSubviews.forEach { (view) in
            genreStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        if ids.count > 0 {
            let maxNum = 2
            let num = min(ids.count, maxNum) - 1
            
            for i in 0...num {
                let label = UILabel()
                genreStack.addArrangedSubview(label)
                label.setContentHuggingPriority(.required, for: .horizontal)
                label.setContentCompressionResistancePriority(.required, for: .horizontal)
                label.backgroundColor = .darkGray
                label.layer.cornerRadius = 5
                label.clipsToBounds = true
                if let genretxt = GenreManager.shared.getGenre(ids[i]) {
                    label.labelDesign(inputText:  " " + genretxt + " ", size: 12, color: .white)
                }
            }
        }

    }

    override func configureHierachy() {
        contentView.addSubview(posterImage)
        contentView.addSubview(titleLable)
        contentView.addSubview(dateLabel)
        contentView.addSubview(genreStack)
        contentView.addSubview(heartButton)
    }
    
    override func configureLayout() {
        posterImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(72)
            make.height.equalTo(96)
        }
        titleLable.snp.makeConstraints { make in
            make.leading.equalTo(posterImage.snp.trailing).offset(10)
            make.top.equalTo(posterImage)
            make.trailing.greaterThanOrEqualToSuperview().inset(8)
            make.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImage.snp.trailing).offset(10)
            make.trailing.greaterThanOrEqualToSuperview().inset(8)
            make.top.equalTo(titleLable.snp.bottom).offset(4)
            make.height.equalTo(15)
        }
        genreStack.snp.makeConstraints { make in
            make.leading.equalTo(posterImage.snp.trailing).offset(10)
            make.bottom.equalTo(posterImage.snp.bottom)
            make.height.equalTo(17)
        }
        heartButton.snp.makeConstraints { make in
            make.centerY.equalTo(genreStack)
            make.trailing.equalToSuperview().inset(8)
        }
    }
    override func configureView() {
        backgroundColor = .clear
        heartButton.setAction()
        genreStack.spacing = 5
        genreStack.axis = .horizontal
    }
}
