//
//  CreateDiaryViewController.swift
//  DiaryME
//
//  Created by Sittisak Teanpanom on 3/8/2564 BE.
//

import UIKit
import MobileCoreServices

class CreateDiaryViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var bgCreateDiary: UIView!
    @IBOutlet var textName: UITextField!
    
    @IBOutlet var contentTextView: UITextView!
    
    @IBOutlet var btnAddDiary: UIButton!
    @IBOutlet var imageShow: UIImageView!
    var diaryUrlImage:[String] = []
    var diaryName:[String] = []
    var diaryContent:[String] = []
    var diaryTime:[String] = []
    
    var urlStr:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let dismiss: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismiss)
        
        contentTextView.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //MARK: - object functions
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addToPlist(diaryUrlImage: [String],diaryName: [String],diaryContent:[String],diaryTime:[String], completion: (() -> Void)? = nil) {
        
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
    
    func loading() {
        self.btnAddDiary.isHidden = true
        self.bgCreateDiary.isHidden = true
    }
    
    func dismissLoading() {
        self.btnAddDiary.isHidden = false
        self.bgCreateDiary.isHidden = false
    }
    
    func alert(message: String, title: String = "") -> UIAlertController? {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .default, handler: nil)
      alertController.addAction(OKAction)
      present(alertController, animated: true, completion: nil)
      return alertController
    }
    
    @IBAction func addImageFromlocal(_ sender: Any) {
        self.loading()
        self.hendleUploadTap()
    }
    
    @IBAction func addDiary(_ sender: Any) {
        self.loading()
        let name = textName.text ?? ""
        let currentTime = NSDate().description
        if name != "" {
            diaryName.append(name)
        }else {
            textName.becomeFirstResponder()
            self.dismissLoading()
            return
        }
        
        if let text = contentTextView.text {
            diaryContent.append(text)
        } else {
            diaryContent.append("")
        }
        
        diaryUrlImage.append(urlStr)
        diaryTime.append(currentTime)
        
        self.addToPlist(
            diaryUrlImage: diaryUrlImage,
            diaryName: diaryName,
            diaryContent: diaryContent,
            diaryTime: diaryTime,
            completion: {
                self.dismissLoading()
                self.navigationController?.popViewController(animated: true)
            })
    }
}

extension CreateDiaryViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectImagePicker:UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            selectImagePicker = editedImage
        } else if let originialImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            selectImagePicker = originialImage
        }
        urlStr = selectImagePicker?.toPngString() ?? ""
        imageShow.image = selectImagePicker
        dismiss(animated: true, completion: {
            self.dismissLoading()
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: {
            self.dismissLoading()
        })
    }
    
    func hendleUploadTap() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image"]
        present(imagePickerController,animated:true,completion: nil)
    }
}

//MARK: - UIImage Custome functions
extension UIImage {
    func toPngString() -> String? {
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
  
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
