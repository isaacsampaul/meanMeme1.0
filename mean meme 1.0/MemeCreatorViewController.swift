//
//  ViewController.swift
//  mean meme 1.0
//
//  Created by Isaac sam paul on 9/22/16.
//  Copyright © 2016 Isaac sam paul. All rights reserved.
//

import UIKit
import Foundation

class memeCreatorViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate ,UITextFieldDelegate{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var topEditor: UITextField!
    @IBOutlet weak var bottomEditor: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    struct meme
    {
        var topText: String!
        var bottomText: String!
        var originalImage: UIImage!
        var memedImage: UIImage!
    }
    
    let memeTextAttributes = [ NSStrokeColorAttributeName: UIColor.black, NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size:30)!, NSStrokeWidthAttributeName: -3.0] as [String : Any]
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        topEditor.defaultTextAttributes = memeTextAttributes
        bottomEditor.defaultTextAttributes = memeTextAttributes
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        topEditor.text = "Top"
        bottomEditor.text = "Bottom"
        shareButton.isEnabled = false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        topEditor.textAlignment = NSTextAlignment.center
        bottomEditor.textAlignment = NSTextAlignment.center
        
    }
    
    func sourceSelector(sourceType: UIImagePickerControllerSourceType)
    {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = sourceType
        self.present(image, animated: true, completion: nil)
        
    }
    
    @IBAction func phototaker(_ sender: AnyObject)
    {
        sourceSelector(sourceType: UIImagePickerControllerSourceType.camera)
    }
    
    @IBAction func imagepicker(_ sender: AnyObject)
    {
        sourceSelector(sourceType: UIImagePickerControllerSourceType.photoLibrary)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo: [String:Any]) {
        if let image = didFinishPickingMediaWithInfo[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.imageview.contentMode = .scaleAspectFit
            self.imageview.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func TopEditorIsUsed(_ sender: AnyObject)
    {
        topEditor.text = ""
    }
    
    
    @IBAction func bottomEditorIsUsed(_ sender: AnyObject)
    {
        bottomEditor.text = ""
        subscribeToKeyboardWillShowNotifications()
        
    }
    
    
    @IBAction func bottomEditorIsEdited(_ sender: AnyObject)
    {
        unsubscribeFromKeyboardWillShowNotifications()
        subscribeToKeyboardWillHideNotifications()
        unsubscribeFromKeyboardWillHideNotifications()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
       
        shareButton.isEnabled = true
        textField.resignFirstResponder()
        return true
    }
    
    
    func generatedMemedImage() -> UIImage
    {
        
        toolBar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        toolBar.isHidden = false
        return memedImage
        
        
    }
    
    
    func save()
    {
        let Meme = meme( topText: topEditor.text,bottomText: bottomEditor.text, originalImage: imageview.image, memedImage: generatedMemedImage())
    }
    
    
    @IBAction func share(_ sender: AnyObject)
    {
        let image = generatedMemedImage()
        let sharedImage = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(sharedImage,animated: true,completion: nil)
        save()
    }
    
    func subscribeToKeyboardWillShowNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(memeCreatorViewController.keyboardWillShow(notification:)) , name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func subscribeToKeyboardWillHideNotifications()
    {
       NotificationCenter.default.addObserver(self, selector: #selector(memeCreatorViewController.keyboardWillHide(notification:)) , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardWillShowNotifications()
    {
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardWillHideNotifications()
    {
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        view.frame.origin.y -= getKeyboardHeight(notification: notification)
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        view.frame.origin.y += getKeyboardHeight(notification: notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
        }




