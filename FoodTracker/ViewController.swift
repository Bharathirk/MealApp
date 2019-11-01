//
//  ViewController.swift
//  FoodTracker
//
//  Created by Raja Bharathi on 2019/10/25.
//  Copyright © 2019 Raja Bharathi. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController ,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var saveNewMeal: UIBarButtonItem!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var selectImage: UIButton!
    @IBOutlet weak var ratingControl: RatingControl!
    

    @IBOutlet weak var photoImageView: UIImageView!
    
  
    
    static let cellName = "ViewController"
    static let cellNib = UINib(nibName: "ViewController", bundle: Bundle.main)
    
    var meal: Meal?
    var selectedIndexPath : IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        
//        // Set up views if editing an existing Meal.
               if let meal = meal {
                   navigationItem.title = meal.name
                   nameTextField.text = meal.name
                   photoImageView.image = meal.photo
                   ratingControl.rating = meal.rating
               }

        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
           // Disable the Save button while editing.
           saveNewMeal.isEnabled = false
       }
//
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    @IBAction func ClickAddPhoto(_ sender: UIButton) {
        // Hide the keyboard.
                                                 nameTextField.resignFirstResponder()
                                                 print("Clicked.....")
                                                 // UIImagePickerController is a view controller that lets a user pick media from their photo library.
                                                 let imagePickerController = UIImagePickerController()

                                                 // Only allow photos to be picked, not taken.
                                                 imagePickerController.sourceType = .photoLibrary

                                                 // Make sure ViewController is notified when the user picks an image.
                                                 imagePickerController.delegate = self
                                                 present(imagePickerController, animated: true, completion: nil)
    }
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        if let selectedImage = info[.originalImage] as? UIImage{
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        }
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveNewMeal else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        // Set the meal to be passed to MealTableViewController after the unwind segue.
       meal = Meal(name: name, photo: photo, rating: rating)
    }
    

    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveNewMeal.isEnabled = !text.isEmpty
    }

    
   
}

