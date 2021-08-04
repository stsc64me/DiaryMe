//
//  DetailDiaryViewController.swift
//  DiaryME
//
//  Created by Sittisak Teanpanom on 3/8/2564 BE.
//

import UIKit

class DetailDiaryViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var diaryNameLabel: UILabel!
    
    @IBOutlet var diaryImage: UIImageView!
    @IBOutlet var contentTextView: UITextView!
    
    @IBOutlet var btnSelectImage: UIButton!
    
    @IBOutlet var loadingView: UIView!
    var diaryUrlImage:[String]?
    var diaryName:[String]?
    var diaryContent:[String]?
    var diaryTime:[String]?
    var indexIsSelect:Int?
    
    var isEdit: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSelectImage.isHidden = true
        self.contentTextView.isEditable = false
        self.setUIDiaryDetail()
    }
    
    private func setUIDiaryDetail() {
        guard let index = indexIsSelect else {return}
        self.loadingView.isHidden = true
        self.dateTimeLabel.text = diaryTime?[index]
        self.diaryNameLabel.text = diaryName?[index]
        self.diaryImage.image = diaryUrlImage?[index].toImage()
        self.contentTextView.text = diaryContent?[index]
    }
    
    func addToPlist(diaryUrlImage: [String],diaryName: [String],diaryContent:[String],diaryTime:[String], completion: (() -> Void)? = nil) {
        self.loadingView.isHidden = false
        guard let pathPlist = Bundle.main.path(forResource: "DiaryList", ofType: "plist") else {return}
        
        let plistProfileModel = NSMutableDictionary(contentsOfFile: pathPlist)
        
        plistProfileModel?.setValue(diaryUrlImage as Any,forKey: "urlImage")
        
        plistProfileModel?.setValue(diaryName as Any, forKey: "nameImage")
        
        plistProfileModel?.setValue(diaryContent as Any, forKey: "content")
        
        plistProfileModel?.setValue(diaryTime as Any, forKey: "time")
        
        
        let docsBaseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let customPlistURL = docsBaseURL.appendingPathComponent("DiaryList.plist")
        do  {
            let data = try PropertyListSerialization.data(fromPropertyList: plistProfileModel!, format: PropertyListSerialization.PropertyListFormat.binary, options: 0)
            do {
                try data.write(to: customPlistURL, options: .atomic)
                completion?()
            } catch (let err){
                _ = alert(message: "\(err.localizedDescription)")
            }
        } catch (let err){
            _ = alert(message: "\(err.localizedDescription)")
        }
    }
    
    func alert(message: String, title: String = "") -> UIAlertController? {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .default, handler: nil)
      alertController.addAction(OKAction)
      present(alertController, animated: true, completion: nil)
      return alertController
    }
    
    @IBAction func actionEdit(_ sender: Any) {
        if isEdit == false {
            isEdit = true
            self.btnSelectImage.isHidden = false
            self.btnEdit.setTitle("Done", for: .normal)
            self.contentTextView.isEditable = true
        }else {
            isEdit = false
            self.btnSelectImage.isHidden = true
            self.btnEdit.setTitle("Edit", for: .normal)
            self.contentTextView.isEditable = false
            guard let index = indexIsSelect else {return}
            
            self.diaryUrlImage?[index] = self.diaryImage.image?.toPngString() ?? ""
            
            self.diaryName?[index] = self.diaryNameLabel.text ?? ""
            
            self.diaryContent?[index] = self.contentTextView.text
            
            self.diaryTime?[index] = dateTimeLabel.text ?? ""
            
            self.addToPlist(
                diaryUrlImage: diaryUrlImage ?? [],
                diaryName: diaryName ?? [],
                diaryContent: diaryContent ?? [],
                diaryTime: diaryTime ?? [],
                completion: {
                    self.loadingView.isHidden = true
                    _ = self.alert(message: "Edit Success")
                    
                })
        }
    }
    
    @IBAction func actionSelectImg(_ sender: Any) {
        self.hendleUploadTap()
    }
}
extension DetailDiaryViewController:UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectImagePicker:UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            selectImagePicker = editedImage
        } else if let originialImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            selectImagePicker = originialImage
        }
        diaryImage.image = selectImagePicker
        self.loadingView.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.loadingView.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    func hendleUploadTap() {
        loadingView.isHidden = false
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image"]
        present(imagePickerController,animated:true,completion: nil)
    }
}
