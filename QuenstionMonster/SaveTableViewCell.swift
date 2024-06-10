//
//  SaveTableViewCell.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 4.06.2024.
//

import UIKit

// Veri modeli
struct CellData {
    let documentID: String
    let userName: String
    let explanation: String
    let answer: String
    let isSaved: Bool
    let userImage: UIImage 
}

protocol SaveTableViewCellDelegate: AnyObject {
    func didTapSaveButton(documentID: String, isSaved: Bool)
}

class SaveTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    
    weak var delegate: SaveTableViewCellDelegate?
    var documentID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        guard let documentID = documentID else { return }
        delegate?.didTapSaveButton(documentID: documentID, isSaved: true)
    }
    
    func configure(with data: CellData) {
        userImageView.image = data.userImage
        answerLabel.text = data.answer
        userNameLabel.text = data.userName
        explanationLabel.text = data.explanation
        documentID = data.documentID
    }
}
