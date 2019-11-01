//
//  ViewController.swift
//  FoodTracker
//
//  Created by Raja Bharathi on 2019/10/25.
//  Copyright © 2019 Raja Bharathi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var saveNewMeal: UIBarButtonItem!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var selectImage: UIButton!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var meal: Meal?
    
    var selectedIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            
            navigationItem.title = meal.name
            
            nameTextField.text = meal.name
            
            photoImageView.image = meal.photo
            
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveNewMeal else {
            return
        }
        
        let name = nameTextField.text ?? ""
        
        let photo = photoImageView.image
        
        let rating = ratingControl.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    
    
    @IBAction func imageTapAction(_ sender: UITapGestureRecognizer) {
                
        self.view.endEditing(true)
        
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    //MARK:- Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        
        saveNewMeal.isEnabled = !text.isEmpty
    }

}

//MARK:- UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
}

//MARK:- UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
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
}

