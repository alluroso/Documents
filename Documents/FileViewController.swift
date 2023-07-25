//
//  FileViewController.swift
//  Documents
//
//  Created by Алексей Калинин on 24.07.2023.
//

import UIKit

class FileViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    var sort = true
    
    var files: [String] {
        do {
            if sort {
                return try FileManager.default.contentsOfDirectory(atPath: path).sorted(by: >)
            } else {
                return try FileManager.default.contentsOfDirectory(atPath: path).sorted(by: <)
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sort = UserDefaults.standard.bool(forKey: "sortSettings")
        
        setupView()
        barButtonItem()
    }
    
    func setupView() {
        title = NSString(string: path).lastPathComponent
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    func barButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createFile))
    }
    
    @objc func createFile() {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        if let data = selectedImage.jpegData(compressionQuality: 0.8) {
            do {
                try data.write(to: (getDocumentsDirectory().appendingPathComponent(randomName(length: 5))))
                tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        cell.textLabel?.text = files[indexPath.row]
        
        let cellImagePath = path + "/" + files[indexPath.row]
        cell.imageView?.image = UIImage(contentsOfFile: cellImagePath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pathForDelete = path + "/" + files[indexPath.row]
            try? FileManager.default.removeItem(atPath: pathForDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func randomName(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! }) + ".jpeg"
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension FileViewController: SettingsViewControllerDelegate {
    func sortTableView() {
        sort.toggle()
        tableView.reloadData()
        UserDefaults.standard.set(sort, forKey: "sortSettings")
    }
}
