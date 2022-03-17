//
//  ViewController.swift
//  ListApp
//
//  Created by Cihan Çallı on 16.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var alertController = UIAlertController()
    
    @IBOutlet weak var tableView:UITableView!
    
    
    var data = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func didRemoveBarButtonItemTapped(_ sender: UIBarButtonItem){
        presentAlert(title: "Uyarı",
                     message: "Listedeki bütün öğeleri silmek istediğinize emin misiniz?",
                     defaultButtunTitle: "Evet",
                     cancelButtonTitle: "Vazgeç") { _ in
            self.data.removeAll()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func didAddBarButtonItemTapped(_ sender: UIBarButtonItem){
        self.presentAddAlert()
    }
    
    func presentAddAlert(){
        
        presentAlert(title: "Yeni Eleman Ekle",
                     message: nil,
                     defaultButtunTitle: "Ekle",
                     cancelButtonTitle: "İptal",
                     isTextFieldAvailable: true,
                     defaultButtunHandler: { _ in
                     let text = self.alertController.textFields?.first?.text
                     if text != ""{
                         self.data.append((text)!)
                        self.tableView.reloadData()
                     }else{
                        self.presentWarningAlert()
                     }
        })
    }
    
    func presentWarningAlert(){
        presentAlert(title: "Uyarı!",
                     message: "Liste elemanı boş olamaz.",
                     cancelButtonTitle: "Tamam")
    }

    func presentAlert(title: String?,
                      message: String?,
                      preferredStyle: UIAlertController.Style = .alert,
                      defaultButtunTitle: String? = nil,
                      cancelButtonTitle: String?,
                      isTextFieldAvailable: Bool = false,
                      defaultButtunHandler: ((UIAlertAction) -> Void)? = nil){
        alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: preferredStyle)
        if defaultButtunTitle != nil {
            let defaultButton = UIAlertAction(title: defaultButtunTitle,
                                              style: .default,
                                              handler: defaultButtunHandler)
            alertController.addAction(defaultButton)
        }
        
        let cancelButton = UIAlertAction(title: cancelButtonTitle,
                                         style: .cancel)
        if isTextFieldAvailable {
            alertController.addTextField()
        }
        
        alertController.addAction(cancelButton)
        present(alertController, animated: true)
    }

}
//TableView Method
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "Sil") { _, _, _ in
            self.data.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let editAction = UIContextualAction(style: .normal,
                                            title: "Düzenle"){ _, _, _ in
            self.presentAlert(title: "Elemanı Düzenle",
                         message: nil,
                         defaultButtunTitle: "Düzenle",
                         cancelButtonTitle: "İptal",
                         isTextFieldAvailable: true,
                         defaultButtunHandler: { _ in
                         let text = self.alertController.textFields?.first?.text
                         if text != ""{
                             self.data[indexPath.row] = text!
                            self.tableView.reloadData()
                         }else{
                            self.presentWarningAlert()
                         }
            })
    }
        editAction.backgroundColor = .systemBlue
        deleteAction.backgroundColor = .systemRed
        let config = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        return config
    }
}
