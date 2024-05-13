//
//  HomePageViewController.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 20.04.2024.
//

import UIKit

class HomePageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    var selectedClassRow = 0
    var selectedLessonRow = 0
    
    @IBOutlet weak var pickerViewButtonLesson: UIButton!
    @IBOutlet weak var pickerViewButtonClass: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var classSelection = [
        "Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5", "Grade 6",
        "Grade 7", "Grade 8", "Grade 9", "Grade 10", "Grade 11", "Grade 12"
    ]
    
    var lessonSelection = [
        "Math", "Science", "History", "English", "Art"
    ]
    @IBAction func popUpPickerClass(_ sender: Any) {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(selectedClassRow, inComponent: 0, animated: false)
        
        let alertController = UIAlertController(title: nil, message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alertController.view.addSubview(pickerView)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func popUpPickerLesson(_ sender: Any) {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(selectedLessonRow, inComponent: 0, animated: false)
        
        let alertController = UIAlertController(title: nil, message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alertController.view.addSubview(pickerView)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
  
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      
            return classSelection.count
      
    }
  
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
      
            label.text = classSelection[row]
      
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     
            pickerViewButtonClass.setTitle(classSelection[row], for: .normal)
            selectedClassRow = row
      
    }
    
    
  
    
}
