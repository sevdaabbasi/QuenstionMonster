//
//  MaterialsViewController.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 20.04.2024.
//
import UIKit
import MobileCoreServices

class MaterialsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var materials = [Material]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMaterialTapped))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
        }
        
        loadMaterials()
    }
    
    @objc func addMaterialTapped() {
        let alertController = UIAlertController(title: "Add Material", message: "Choose material type", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Add Name", style: .default, handler: { (_) in
            self.addMaterialWithName()
        }))
        
        alertController.addAction(UIAlertAction(title: "Select File", style: .default, handler: { (_) in
            self.selectFile()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func addMaterialWithName() {
        let alertController = UIAlertController(title: "Add Material Name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Material Name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let name = alertController.textFields?.first?.text, !name.isEmpty else { return }
            let newMaterial = Material(id: UUID().uuidString, name: name, type: .text, fileURL: nil)
            self.materials.append(newMaterial)
            self.saveMaterials()
            self.collectionView.reloadData()
        }
        
        alertController.addAction(addAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func selectFile() {
        let alertController = UIAlertController(title: "Select File Type", message: nil, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Image or Video", style: .default, handler: { (_) in
            self.showImagePicker()
        }))
        
        alertController.addAction(UIAlertAction(title: "PDF", style: .default, handler: { (_) in
            self.showDocumentPicker()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let mediaType = info[.mediaType] as? String else { return }
        
        var fileType: MaterialType
        if mediaType == kUTTypeImage as String {
            fileType = .image
        } else if mediaType == kUTTypeMovie as String {
            fileType = .video
        } else {
            return
        }
        
        if let fileURL = info[.mediaURL] as? URL ?? info[.imageURL] as? URL {
            let alertController = UIAlertController(title: "Add Material Name", message: nil, preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.placeholder = "Material Name"
            }
            
            let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
                guard let name = alertController.textFields?.first?.text, !name.isEmpty else { return }
                let newMaterial = Material(id: UUID().uuidString, name: name, type: fileType, fileURL: fileURL)
                self.materials.append(newMaterial)
                self.saveMaterials()
                self.collectionView.reloadData()
            }
            
            alertController.addAction(addAction)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            picker.dismiss(animated: true) {
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else { return }
        
        let alertController = UIAlertController(title: "Add Material Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Material Name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let name = alertController.textFields?.first?.text, !name.isEmpty else { return }
            let newMaterial = Material(id: UUID().uuidString, name: name, type: .pdf, fileURL: fileURL)
            self.materials.append(newMaterial)
            self.saveMaterials()
            self.collectionView.reloadData()
        }
        
        alertController.addAction(addAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return materials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaterialCell", for: indexPath) as! MaterialCollectionViewCell
        let material = materials[indexPath.item]
        cell.configure(with: material)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    // MARK: - Data Persistence
    func loadMaterials() {
        if let data = UserDefaults.standard.data(forKey: "materials") {
            do {
                materials = try JSONDecoder().decode([Material].self, from: data)
            } catch {
                print("Failed to load materials.")
            }
        }
    }
    
    func saveMaterials() {
        do {
            let data = try JSONEncoder().encode(materials)
            UserDefaults.standard.set(data, forKey: "materials")
        } catch {
            print("Failed to save materials.")
        }
    }
}
