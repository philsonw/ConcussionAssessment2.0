//
//  ListPlayerProfilesController.swift
//  ConcussionAssessment
//
//  Created by Yvone Chau on 2/23/16.
//  Copyright © 2016 PYKS. All rights reserved.
//

import Foundation
import UIKit

class ListPlayerProfileController: UITableViewController {
    var player1: UITableViewCell = UITableViewCell()
    var player2: UITableViewCell = UITableViewCell()
    var player3: UITableViewCell = UITableViewCell()
    var doListPlayers: Bool = true
    var listOfPlayers: [Player]
    var typeOfProfilePage: String
    let numberOfSections = 1
    var originalView = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.navigationItem.setHidesBackButton(true, animated: true)

        if typeOfProfilePage == "List" {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.createNewProfile))
            if doListPlayers == true {
                //self.navigationItem.leftBarButtonItem = editButtonItem()
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        
        // set the title
        self.navigationItem.title = "Profile"
        
        if typeOfProfilePage == "List" && doListPlayers == true {
            //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(editProfiles))

        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        listOfPlayers = database.fetchPlayers()
        if listOfPlayers.count <= 0 {
            doListPlayers = false
        }
        else {
            doListPlayers = true
        }
        self.tableView!.reloadData()

    }
    
    init(style: UITableViewStyle, type: String, original: Int) {
        listOfPlayers = database.fetchPlayers()
        if listOfPlayers.count <= 0 {
            doListPlayers = false
        }
        self.typeOfProfilePage = type
        self.originalView = original
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Return the number of sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    // Return the number of rows for each section in your static table
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if doListPlayers {
            return listOfPlayers.count
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Return the row for the corresponding section and row
        if doListPlayers == true {
            let fullPlayerName: String = listOfPlayers[indexPath.row].firstName! + " " + listOfPlayers[indexPath.row].lastName!
            let playerID: String = listOfPlayers[indexPath.row].playerID!
            
            if typeOfProfilePage == "List" {
                switch(indexPath.section) {
                case 0:
                    let PlayerProfileSelection = PlayerProfileViewController(name: fullPlayerName, playerID: playerID) as PlayerProfileViewController
                    self.navigationController?.pushViewController(PlayerProfileSelection, animated: true)
                default:
                    fatalError("Invalid section")
                }
            } else if typeOfProfilePage == "Select" {
                switch(indexPath.section) {
                case 0:
                    currentScoreID = NSUUID().UUIDString
                    /*
                    currentScoreID = NSUUID().UUIDString
                    database.insertNewScore(playerID, scoreID: currentScoreID!)
                    
                    let (sympEvalPageTitles, sympEvalTestName, sva, sympEvalInstr) = getSympEvalStrings()
                    let(orientationTitle, orientationTestName, orientationCOA, orientationInstr) = getCogAssOrientationStrings()
                    let(memPageTitle, memTestName, memCOA, memInstr) = getCogAssImmediateStrings()
                    let(numPageTitle, numTestName, numCOA, numInstr) = getCogAssNumStrings()
                    let(monthPageTitle, monthTestName, monthCOA, monthInstr) = getCogAssMonthStrings()
                    let(sacPageTitle,sacTestName, sac, sacInstr) = getSACDelayRecallStrings(memPageTitle)
                    
                    //SAC DELAYED RECALL: IMMEDIATE MEMORY
                    let SacDelayedRecallView = TablePageViewController(pageTitles: sacPageTitle, labelArray: sac, testName: sacTestName, instructionPage: nil, instructions: sacInstr, next: nil, original: self, numTrials: nil, singlePage: true) as TablePageViewController
                    
                    
                    //COGNATIVE ASSESSMENT: MONTH
                    let CognitiveMonthsBackwardsView = TablePageViewController(pageTitles: monthPageTitle, labelArray: monthCOA, testName: monthTestName, instructionPage: nil, instructions: monthInstr, next: SacDelayedRecallView, original: self, numTrials: nil, singlePage: false) as TablePageViewController
                    
                    //COGNATIVE ASSESSMENT: NUMBER
                    let CognitiveNumBackwardsView = TablePageViewController(pageTitles: numPageTitle, labelArray: numCOA, testName: numTestName, instructionPage: nil, instructions: numInstr, next: CognitiveMonthsBackwardsView, original: self, numTrials: [0, 1], singlePage: false) as TablePageViewController
                    
                    //COGNATIVE ASSESSMENT: IMMEDIATE MEMORY
                    let CognitiveImmediateMemView = TablePageViewController(pageTitles: memPageTitle, labelArray: memCOA, testName: memTestName, instructionPage: nil, instructions: memInstr, next: CognitiveNumBackwardsView, original: self, numTrials: [0, 3], singlePage: true) as TablePageViewController
                    
                    //COGNATIVE ASSESSMENT: ORIENTATION
                    let CognitiveOrientationView = TablePageViewController(pageTitles: orientationTitle, labelArray: orientationCOA, testName: orientationTestName, instructionPage: nil, instructions: orientationInstr, next: CognitiveImmediateMemView, original: self, numTrials: nil, singlePage: false) as TablePageViewController
                    
                    //SYMPTOM EVALUATION
                    let SymptomView = TablePageViewController(pageTitles: sympEvalPageTitles, labelArray: sva, testName: sympEvalTestName, instructionPage: nil, instructions: sympEvalInstr, next: CognitiveOrientationView, original: self, numTrials: nil, singlePage: false) as TablePageViewController
                    
                    self.navigationController?.pushViewController(SymptomView, animated: true)
                    */
                    
                    let TestType = TestTypeController(playerID: playerID, original: originalView + 1)
                    self.navigationController?.pushViewController(TestType, animated: true)
                    
                    break;
                default:
                    fatalError("Invalid section")
                }
            } else if typeOfProfilePage == "Cognitive Assessment" {
                currentScoreID = NSUUID().UUIDString
                database.insertNewScore(playerID, scoreID: currentScoreID!)
                
                print("Cogantive Ass");
                
                let(orientationTitle, orientationTestName, orientationCOA, orientationInstr) = getCogAssOrientationStrings()
                let(memPageTitle, memTestName, memCOA, memInstr) = getCogAssImmediateStrings()
                let(numPageTitle, numTestName, numCOA, numInstr) = getCogAssNumStrings()
                let(monthPageTitle, monthTestName, monthCOA, monthInstr) = getCogAssMonthStrings()
                
                //COGNATIVE ASSESSMENT: MONTH
                let CognitiveMonthsBackwardsView = TablePageViewController(pageTitles: monthPageTitle, labelArray: monthCOA, testName: monthTestName, instructionPage: nil, instructions: monthInstr, next: nil, original: self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - originalView] , numTrials: nil, singlePage: false) as TablePageViewController
            
                
                //COGNATIVE ASSESSMENT: NUMBER
                let CognitiveNumBackwardsView = TablePageViewController(pageTitles: numPageTitle, labelArray: numCOA, testName: numTestName, instructionPage: nil, instructions: numInstr, next: CognitiveMonthsBackwardsView, original: self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - originalView], numTrials: [0, 1], singlePage: false) as TablePageViewController
                
                //COGNATIVE ASSESSMENT: IMMEDIATE MEMORY
                let CognitiveImmediateMemView = TablePageViewController(pageTitles: memPageTitle, labelArray: memCOA, testName: memTestName, instructionPage: nil, instructions: memInstr, next: CognitiveNumBackwardsView, original: self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - originalView], numTrials: [0, 3], singlePage: true) as TablePageViewController
                
                //COGNATIVE ASSESSMENT: ORIENTATION
                let CognitiveOrientationView = TablePageViewController(pageTitles: orientationTitle, labelArray: orientationCOA, testName: orientationTestName, instructionPage: nil, instructions: orientationInstr, next: CognitiveImmediateMemView, original: self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - originalView], numTrials: nil, singlePage: false) as TablePageViewController
                
                self.navigationController?.pushViewController(CognitiveOrientationView, animated: true)
                
            } else if typeOfProfilePage == "Symptom Evaluation" {
                currentScoreID = NSUUID().UUIDString
                database.insertNewScore(playerID, scoreID: currentScoreID!)
                
                let (sympEvalPageTitles, sympEvalTestName, sva, sympEvalInstr) = getSympEvalStrings()
                
                //SYMPTOM EVALUATION
                let SymptomView = TablePageViewController(pageTitles: sympEvalPageTitles, labelArray: sva, testName: sympEvalTestName, instructionPage: nil, instructions: sympEvalInstr, next: nil, original: self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - originalView], numTrials: nil, singlePage: false) as TablePageViewController
                
                self.navigationController?.pushViewController(SymptomView, animated: true)
                
            } else if typeOfProfilePage == "Neck Examination" {
                currentScoreID = NSUUID().UUIDString
                database.insertNewScore(playerID, scoreID: currentScoreID!)
                
                let(neckPageTitle, neckTestName, neckQuestionArray, neckInstr) = getNeckStrings()
                
                let NeckView = NeckExamViewController(pageTitles: neckPageTitle, pageContent: neckQuestionArray, testName: neckTestName, instructions: neckInstr, next: nil, original: self, numTrials: nil, singlePage: false)
                
                self.navigationController?.pushViewController(NeckView, animated: true)
                
            } else if typeOfProfilePage == "BESS" {
                currentScoreID = NSUUID().UUIDString
                database.insertNewScore(playerID, scoreID: currentScoreID!)
              
              let (balancePageTitles, balanceTestName, balanceInstructions) = getBalanceStrings()
              let BalanceView = BalanceViewController(pageTitles: balancePageTitles, testName: balanceTestName, instructions: balanceInstructions, original: self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - originalView], next: nil)
              self.navigationController?.pushViewController(BalanceView, animated: true)
              
              
            } else if typeOfProfilePage == "Glasgow" {
                currentScoreID = NSUUID().UUIDString
                database.insertNewScore(playerID, scoreID: currentScoreID!)
                
                let (pageTitles, testName, gla, instr) = getGlasgowStrings()
                
                let GlasgowView = TablePageViewController(pageTitles: pageTitles, labelArray: gla, testName: testName, instructionPage: nil, instructions: instr, next: nil, original: self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - originalView], numTrials: nil, singlePage: false) as TablePageViewController
                
                self.navigationController?.pushViewController(GlasgowView, animated: true)
                
            } else if typeOfProfilePage == "Maddocks" {
                currentScoreID = NSUUID().UUIDString
                database.insertNewScore(playerID, scoreID: currentScoreID!)
                
                let (pageTitles, testName, ma, instr) = getMaddocksStrings()
                
                let MaddocksView = TablePageViewController(pageTitles: pageTitles, labelArray: ma, testName: testName, instructionPage: nil, instructions: instr, next: nil, original: self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - originalView], numTrials: nil, singlePage: false) as TablePageViewController
                
                self.navigationController?.pushViewController(MaddocksView, animated: true)
   
                
            }
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        if doListPlayers == true {
            switch(indexPath.section) {
            case 0:
                // Lists the name and team for each player in the database
                cell.textLabel?.text = listOfPlayers[indexPath.row].firstName! + " " + listOfPlayers[indexPath.row].lastName!
                cell.detailTextLabel?.text = "Team: " + listOfPlayers[indexPath.row].teamName!
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            default: fatalError("Unknown section")
            }
        } else {
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.text = "No players created yet!"
        }
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
         if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            if listOfPlayers.count == 0 {
                doListPlayers = false
            }
         } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
     }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     }*/
    
    func editProfiles() {
        
    }
    
    func createNewProfile() {
        let CreateProfileController = CreateProfileTableViewController(style: UITableViewStyle.Grouped) as CreateProfileTableViewController
        self.navigationController?.pushViewController(CreateProfileController, animated: true)
    }
}

