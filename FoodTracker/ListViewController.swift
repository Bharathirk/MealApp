//
//  ListViewController.swift
//  FoodTracker
//
//  Created by Raja Bharathi on 2019/10/28.
//  Copyright © 2019 Raja Bharathi. All rights reserved.
//

import UIKit
import os.log


class ListViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var navigationAddButton: UIBarButtonItem!
    @IBOutlet weak var foodListTableView: UITableView!
    
    var meals = [Meal]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.foodListTableView.register(InfoTableViewCell.cellNib, forCellReuseIdentifier: InfoTableViewCell.cellName)
        
        
        // Use the edit button item provided by the table view controller.
//        navigationItem.leftBarButtonItem = editButtonItem
       // Load any saved meals, otherwise load sample data.
//         loadSampleMeals()
        
       if let savedMeals = loadMeals() {
           meals += savedMeals
       }
       else {
           // Load the sample data.
           loadSampleMeals()
       }
        
        
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let sVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController

        self.navigationController?.pushViewController(sVC, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        foodListTableView.isEditing = editing
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
                   // Delete the row from the data source
                   meals.remove(at: indexPath.row)
//                   saveMeals()
                   foodListTableView.deleteRows(at: [indexPath], with: .fade)
               }
         else if editingStyle == .insert {
                   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            print("Editing.......")
            let sVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController

                   self.navigationController?.pushViewController(sVC, animated: true)
            
               }
    }


    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }

   private func loadMeals() -> [Meal]?  {
       return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
   }
    
    private func loadSampleMeals() {

        let photo1 = UIImage(named: "food1")
        let photo2 = UIImage(named: "food2")
        let photo3 = UIImage(named: "food4")

        guard let meal1 = Meal(name: "Dosa", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }

        guard let meal2 = Meal(name: "Briyani", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }

        guard let meal3 = Meal(name: "Vada", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal2")
        }

        meals += [meal1, meal2, meal3]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        meals.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70.0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.cellName) as! InfoTableViewCell
        
        
        let user = meals[indexPath.row]
                
        cell.foodLableName.text = user.name

        cell.foodRating.rating = user.rating

        cell.foodImage.image = user.photo
            ?? UIImage()

        return cell
    }
    
    
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ViewController, let meal = sourceViewController.meal ,(sourceViewController.selectedIndexPath != IndexPath.init(row: meals.count, section: 0)){
                      
                print("pathh....")
                if let getselectedIndexPath = sourceViewController.selectedIndexPath {
                        // Update an existing meal.
                        print("Edited...")
                        meals[getselectedIndexPath.row] = meal
                        self.foodListTableView.reloadRows(at: [getselectedIndexPath], with: .none)
                    }
                    else{
                        // Add a new meal.
                            let newIndexPath = IndexPath(row: meals.count, section: 0)
                        print("Added.....")
                            meals.append(meal)
                        self.foodListTableView.insertRows(at: [newIndexPath], with: .automatic)
                    }
                
                    saveMeals()
                    
                  }
            else{
                print("GetErrror....")
        }
              }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let sVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        
        let selectedMeal = meals[indexPath.row]
        let selectIndexpath = indexPath
        sVC.meal = selectedMeal
        sVC.selectedIndexPath = selectIndexpath
        self.navigationController?.pushViewController(sVC, animated: true)
        

    }
   
}
