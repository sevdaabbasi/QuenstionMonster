//
//  TableViewCell.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 13.05.2024.
//
import UIKit

protocol TableViewCellDelegate: AnyObject {
    func didTapSaveButton(documentID: String, isSaved: Bool)
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton! // UIButton için IBOutlet ekleyin
    
    var documentID: String?
    var isSaved: Bool = false {
        didSet {
            updateSaveButtonAppearance()
        }
    }
    weak var delegate: TableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        updateSaveButtonAppearance()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        if let documentID = documentID {
            delegate?.didTapSaveButton(documentID: documentID, isSaved: isSaved)
        }
    }

    @IBAction func commentButtonClicked(_ sender: Any) {
    }
    
    private func updateSaveButtonAppearance() {
        let imageName = isSaved ? "bookmark.fill" : "bookmark"
        saveButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
