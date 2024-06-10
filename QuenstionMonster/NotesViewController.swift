//
//  NotesViewController.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 20.04.2024.
//
import UIKit

class NotesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotes()
    }
    
    func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: "notes") {
            do {
                notes = try JSONDecoder().decode([Note].self, from: data)
                tableView.reloadData()
            } catch {
                print("Failed to load notes.")
            }
        }
    }
    
    func saveNotes() {
        do {
            let data = try JSONEncoder().encode(notes)
            UserDefaults.standard.set(data, forKey: "notes")
        } catch {
            print("Failed to save notes.")
        }
    }
    
    @IBAction func addNoteButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showAddNote", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddNote",
           let destination = segue.destination as? AddNoteViewController {
            if let selectedNote = sender as? Note {
                destination.note = selectedNote
            }
            destination.delegate = self
        }
    }
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNote = notes[indexPath.row]
        performSegue(withIdentifier: "showAddNote", sender: selectedNote)
    }
}

extension NotesViewController: AddNoteViewControllerDelegate {
    func didSaveNote() {
        loadNotes()
    }
}
