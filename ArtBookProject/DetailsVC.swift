

import UIKit
import CoreData

class DetailsVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textField1: UITextField!
    @IBOutlet var textField2: UITextField!
    @IBOutlet var textField3: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    
    var chosenPainting = ""
    var chosenPaintingId : UUID?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chosenPainting != ""{
            
            saveButton.isEnabled = false
        
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
           
            let fetchReguest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
           
            let idString = chosenPaintingId?.uuidString
            
            fetchReguest.returnsObjectsAsFaults = true
            fetchReguest.predicate = NSPredicate(format: "id = %@", idString!)
            
            do {
                
                let results = try context.fetch(fetchReguest)
                    
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject]{
                        
                        if let name = result.value(forKey: "name") as? String {
                            
                            textField1.text = name

                            
                        }
                        if let artist = result.value(forKey: "Artist") as? String {
                            
                            
                            textField2.text = artist

                            
                            
                        }
                        if let year = result.value(forKey: "Year") as? Int {
                            
                            
                            
                                                textField3.text = String(year)
                            
                            
                            
                        }
                        if let imageData = result.value(forKey: "image") as? Data {
                            
                            let image = UIImage(data: imageData)
                            
                            imageView.image = image
                            
                       
                        }
                        
                        
                    }
                 
                }
                    
                
                
            }
            catch {
                
                
                
                
            }
            
            
            
            
        }else {
            
            saveButton.isEnabled = false
            saveButton.isHidden = false
            
            
            textField1.text = ""
            textField2.text = ""
            textField3.text = ""
            
            
            
        }
        
        
//  Recognizers

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        
        let userTabrecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTab))
        
        imageView.addGestureRecognizer(userTabrecognizer)
        
       
    }
    
    
    @objc func hideKeyboard(){
        
        view.endEditing(true)
        
    }
    
    @objc func imageTab(){
        
    
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker , animated: true , completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        imageView.image = info[.originalImage] as? UIImage
        
        saveButton.isEnabled = true
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    @IBAction func saveButton(_ sender: Any) {
      
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
            
        newPainting.setValue(textField1.text, forKey: "name")
        newPainting.setValue(textField2.text, forKey: "Artist")
        
        if let year = Int(textField3.text!) {
              newPainting.setValue(year, forKey: "year")
                 }
                 
                 newPainting.setValue(UUID(), forKey: "id")
                 
                 let data = imageView.image!.jpegData(compressionQuality: 0.5)
                 
                 newPainting.setValue(data, forKey: "image")
                 
                 do {
                     try context.save()
                     print("success")
                 } catch {
                     print("error")
                
            }
        
        
        NotificationCenter.default.post(name: NSNotification.Name("NewData"),object: nil)
        self.navigationController?.popViewController(animated: true)
           
            
            
        }
        
      
        
    }
    
    
    


