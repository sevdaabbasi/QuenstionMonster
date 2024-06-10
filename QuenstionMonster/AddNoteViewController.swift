//
//  AddNoteViewController.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 5.06.2024.
//
import UIKit

protocol AddNoteViewControllerDelegate: AnyObject {
    func didSaveNote()
}

class AddNoteViewController: UIViewController, UITextViewDelegate {
    
  
    @IBOutlet weak var textView: UITextView!
    
    
    weak var delegate: AddNoteViewControllerDelegate?
    
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.text = note?.content ?? ""
    }
    
    
    @IBAction func saveNoteButtonTapped(_ sender: Any) {
    
    
    
    
        let noteText = textView.text ?? ""
        var notes = [Note]()
        
        if let data = UserDefaults.standard.data(forKey: "notes") {
            do {
                notes = try JSONDecoder().decode([Note].self, from: data)
            } catch {
                print("Failed to load notes.")
            }
        }
        
        if let existingNote = note {
            if let index = notes.firstIndex(where: { $0.id == existingNote.id }) {
                notes[index].content = noteText
            }
        } else {
            let newNote = Note(id: UUID().uuidString, content: noteText)
            notes.append(newNote)
        }
        
        do {
            let data = try JSONEncoder().encode(notes)
            UserDefaults.standard.set(data, forKey: "notes")
        } catch {
            print("Failed to save notes.")
        }
        
        delegate?.didSaveNote()
        navigationController?.popViewController(animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}
