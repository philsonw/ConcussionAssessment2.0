//
//  DataModel.swift
//  ConcussionAssessment
//
//  Created by Yvone Chau on 2/25/16.
//  Copyright © 2016 PYKS. All rights reserved.
//

import Foundation
import CoreData

class DataModel : NSObject {
    var managedObjectContext : NSManagedObjectContext
    var persistentStoreCoordinator : NSPersistentStoreCoordinator
    
    // initialize the database
//    override init() {
//        // This resource is the same name as your xcdatamodeld contained in your project.
//        guard let modelURL = NSBundle.mainBundle().URLForResource("DataModel", withExtension:"momd") else {
//            fatalError("Error loading model from bundle")
//        }
//        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
//        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
//            fatalError("Error initializing mom from: \(modelURL)")
//        }
//        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
//        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = psc
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
//            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//            let docURL = urls[urls.endIndex-1]
//            /* The directory the application uses to store the Core Data store file.
//             This code uses a file named "DataModel.sqlite" in the application's documents directory.
//             */
//            let storeURL = docURL.URLByAppendingPathComponent("DataModel.sqlite")
//            do {
//                try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
//            } catch {
//                fatalError("Error migrating store: \(error)")
//            }
//        }
//        super.init()
//    }
    
    init (persistentStoreCoordinator : NSPersistentStoreCoordinator, managedObjectContext : NSManagedObjectContext) {
        self.persistentStoreCoordinator = persistentStoreCoordinator
        self.managedObjectContext = managedObjectContext
    }
    
    // create a Player Object and save it
    func insertNewPlayer(playerID: String, firstName: String, lastName: String, teamName: String, birthday: NSDate, gender: String, studentID: String) {
        let player = NSEntityDescription.insertNewObjectForEntityForName("Player", inManagedObjectContext: managedObjectContext) as! Player
        
        player.playerID = playerID
        player.firstName = firstName
        player.lastName  = lastName
        player.teamName  = teamName
        player.birthday  = birthday
        player.gender    = gender
        player.idNumber  = studentID
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Month, .Day, .Year],fromDate: date)
        let components = NSDateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        player.dateCreated = calendar.dateFromComponents(components)
        
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Player Object")
        }
    }
    
    // create new Player Object without info
    func insertNewPlayer(playerID: String)
    {
        let player = NSEntityDescription.insertNewObjectForEntityForName("Player", inManagedObjectContext: managedObjectContext) as! Player
        player.playerID = playerID
        player.dateCreated = NSDate()
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Player Object")
        }
    }
    
    // create a Score Object and save it
    func insertNewScore(playerID: String, scoreID: String) {
        let score = NSEntityDescription.insertNewObjectForEntityForName("Score", inManagedObjectContext: managedObjectContext) as! Score
        score.playerID = playerID
        score.scoreID  = scoreID
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Month, .Day, .Year],fromDate: date)
        let components = NSDateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        score.date = calendar.dateFromComponents(components)
        
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Score Object with playerID")
        }
        
    }
    
    func insertNewScoreNoPlayer(scoreID: String) {
        let score = NSEntityDescription.insertNewObjectForEntityForName("Score", inManagedObjectContext: managedObjectContext) as! Score
        //score.playerID = playerID
        //score.scoreID  = NSUUID().UUIDString
        score.date     = NSDate()
        score.scoreID  = scoreID
        
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Score Object with playerID")
        }
        
    }

// This function probably is not needed because core data does not use unique id keys
    
//    func insertNewScoreWithoutPlayer(scoreID: String){
//        let score = NSEntityDescription.insertNewObjectForEntityForName("Score", inManagedObjectContext: managedObjectContext) as! Score
//        score.playerID = "-1"
//        score.date     = NSDate()
//        score.scoreID  = scoreID
//        
//        do {
//            try self.managedObjectContext.save()
//        } catch {
//            fatalError("Cannot create Score Object with playerID")
//        }
//    }
    
    /*
    // assumes global Score Object
    func saveCurrentScore() {
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Score Object with Score Object")
        }
    }*/
    
    
    // Get the Player object with specific name
    func playerWithName(name: String) -> [Player] {
        let fetchRequest = NSFetchRequest(entityName: "Player");
        fetchRequest.predicate = NSPredicate(format: "firstName == %@", name);
        
        do {
            let fetchedPlayers = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Player]
            for e in fetchedPlayers {
                NSLog(e.firstName! + " " + e.lastName!)
            }
            return fetchedPlayers
        } catch {
            fatalError("Failed to fetch players")
        }
        
        return []
    }
    
    func playerWithID(playerID: String) -> [Player]
    {
        let fetchRequest = NSFetchRequest(entityName: "Player");
        fetchRequest.predicate = NSPredicate(format: "playerID == %@", playerID);
        
        do {
            let fetchedPlayers = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Player]
            for e in fetchedPlayers {
                NSLog(e.firstName! + " " + e.lastName!)
            }
            return fetchedPlayers
        } catch {
            fatalError("Failed to fetch players")
        }
        
        return []
    }
    
    // Get all Player Objects that exist
    func fetchPlayers() -> [Player] {
        let fetchRequest = NSFetchRequest(entityName: "Player");

        do {
            let fetchedPlayers = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Player]
            for e in fetchedPlayers {
                NSLog(e.firstName! + " " + e.lastName!)
            }
            return fetchedPlayers
        } catch {
            fatalError("Failed to fetch players")
        }
        
        return []
    }
    
    
    
    // Get the Score object with specific Player
    func scoresOfPlayer(id: String) -> [Score] {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "playerID == %@", id);
        
        do {
            let fetchedScores = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
//            for e in fetchedScores {
//                NSLog(e.playerID + " " + e.SACTotal!.stringValue)
//            }
            return fetchedScores
        } catch {
            fatalError("Failed to fetch Scores")
        }
        
        return []
    }
    
    // Get the Score object with specific ScoreID
    func scoreWithID(id: String) -> [Score] {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
        
        do {
            let fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
            return fetchScore
        } catch {
            fatalError("Failed to get Score")
        }
        
        return []
    }
    
    // Get the Score objects with Specific Baseline
    func scoresWithBaseline(id: String) -> ([String], Int) {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "baselineScore == %@", id);
        
        var scoreIDs: [String] = []
        do {
            let fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
            if(fetchScore.count > 1)
            {
                for index in 0 ... (fetchScore.count - 1)
                {
                    scoreIDs.append(fetchScore[index].scoreID!)
                }
            }
            else if(fetchScore.count == 1)
            {
                scoreIDs.append(fetchScore[0].scoreID!)
            }
            return (scoreIDs, fetchScore.count)
        } catch {
            fatalError("Failed to get Score")
        }
        
        return ([],0)
    }
    
    func numPlayerScores(id: String) -> Int
    {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "playerID == %@", id);
        
        do {
            let fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
            return fetchScore.count
        } catch {
            fatalError("Failed to get Score")
        }
        
        return 0
    }
    
    // Get all Score Data Members as a String Array with specific ScoreID
    func scoreStringArray(id: String) -> ([String], [String?], [[String?]])
    {
        let scoreTitle = ["Number of Symptoms", "Symptom Severity", "Orientation", "Immediate Memory", "Concentration", "Delayed Recall", "SAC Total", "Balance Examination Score"]
        var scoreResults: [String?] = ["--", "--", "--", "--", "--", "--", "--", "--", "--", "--"]
        var neckExam: [[String?]] = [["Flexion", "--"], ["Extension", "--"], ["Right Rotation", "--"], ["Left Rotation", "--"], ["Right Lateral Flexion", "--"], ["Left Lateral Flexion", "--"],
                                     ["Tenderness in the Right Paraspinal", "--"], ["Tenderness in the Left Paraspinal", "--"], ["Tenderness in the Bone", "--"],
                                     ["Right Upper Arm Sensation", "--"], ["Left Upper Arm Sensation", "--"],
                                     ["Right Upper Arm Strength", "--"],  ["Left Upper Arm Strength", "--"],
                                     ["Right Lower Arm Sensation", "--"], ["Left Lower Arm Sensation", "--"],
                                     ["Right Lower Arm Strength", "--"],  ["Left Lower Arm Strength", "--"]]
        
        if(id == "N/A")
        {
            return (scoreTitle, scoreResults, neckExam)
        }
        
        var score = scoreWithID(id)
        let currentScore = score[0]
      
        print(currentScore.domFoot)
        
        scoreResults[0] = (currentScore.numSymptoms)?.stringValue
        scoreResults[1] = (currentScore.severity)?.stringValue
        scoreResults[2] = (currentScore.orientation)?.stringValue
        scoreResults[3] = (currentScore.immediateMemory)?.stringValue
        scoreResults[4] = (currentScore.concentration)?.stringValue
        scoreResults[5] = (currentScore.delayedRecall)?.stringValue
        
        var total: Int = 0
        for i in 2...5
        {
            if let str = scoreResults[i]{
                total += Int(str)!
            }
        }
        
        scoreResults[6] = String(total)
        
        scoreResults[7] = (currentScore.balance)?.stringValue
        
        for index in 0...7
        {
            var score : String
            
            if let str = scoreResults[index] {
                score = str
            } else {
                score = "--"
            }
            
            scoreResults[index] = score
        }
        
        
        neckExam[0][1] = (currentScore.flexion)
        neckExam[1][1] = (currentScore.exten)
        neckExam[2][1] = (currentScore.rRotation)
        neckExam[3][1] = (currentScore.lRotation)
        neckExam[4][1] = (currentScore.rLateralFlex)
        neckExam[5][1] = (currentScore.lLateralFlex)
        
        neckExam[6][1] = (currentScore.rParaspinalTenderness)
        neckExam[7][1] = (currentScore.lParaspinalTenderness)
        neckExam[8][1] = (currentScore.bonyTenderness)
    
        neckExam[9][1] = (currentScore.rUpSensation)
        neckExam[10][1] = (currentScore.lUpSensation)
        
        neckExam[11][1] = (currentScore.rUpStrength)
        neckExam[12][1] = (currentScore.lUpStrength)
        
        neckExam[13][1] = (currentScore.rLowSensation)
        neckExam[14][1] = (currentScore.lLowSensation)
        
        neckExam[15][1] = (currentScore.rLowStrength)
        neckExam[16][1] = (currentScore.lLowStrength)
        
        
        return (scoreTitle, scoreResults, neckExam)
        
        /*
        Use this for scoreResults:
         if scoreResults[i] is nil then print untested
         
        if let str = scoreResults[index] {
            score.text = str
        } else {
            score.text = "Untested"
        }
         
        to call: 
        
        let (scoreTitles, scoreResults) = database.scoreStringArray( < ID > )
        
        */
        
    }
    
    func getPlayerBaseline(id: String) -> String
    {
        let fetchRequest = NSFetchRequest(entityName: "Player");
        fetchRequest.predicate = NSPredicate(format: "playerID == %@", id);
        
        do {
            let fetchedPlayers = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Player]
            for e in fetchedPlayers {
                NSLog(e.firstName! + " " + e.lastName!)
            }
            var m_bl: String?
            if let m_bl = fetchedPlayers[0].baselineScore
            {
                return m_bl
            }
            else
            {
                return "N/A"
            }
        } catch {
            fatalError("Failed to fetch players")
        }
        
        return "0"

    }
    
    func getScoreDate(id: String) -> NSDate
    {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
        
        do {
            let fetchedScores = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
            
            return fetchedScores[0].date!
        } catch {
            fatalError("Failed to fetch players")
        }
        
        let myDate: NSDate
        
        return myDate
        
    }
    
    func getScoreType(id: String) -> String
    {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
        
        do {
            let fetchedScores = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
            
            return fetchedScores[0].scoreType!
        } catch {
            fatalError("Failed to fetch players")
        }
        
        
        return "N/A"
        
    }
    
    
    
    
    
    /********************************************************************************************
     * SCORE SETTER FUNCTIONS
     ********************************************************************************************/
    
    func setBaselineForScore(id: String, baseline: String) {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
        var fetchScore: [Score]
        
        do {
            fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
        } catch {
            fatalError("Failed to get Score")
        }
        fetchScore[0].baselineScore = baseline;
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Score Object with playerID")
        }
    }
    

    func setNumSymptoms(id: String, score: NSNumber) {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
        var fetchScore: [Score]
        
        do {
            fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
        } catch {
            fatalError("Failed to get Score")
        }
        fetchScore[0].numSymptoms = score;
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Score Object with playerID")
        }
    }
    
    func setSeverity(id: String, score: NSNumber) {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
        var fetchScore: [Score]
        
        do {
            fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
        } catch {
            fatalError("Failed to get Score")
        }
        fetchScore[0].severity = score;
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Score Object with playerID")
        }
    }
    
    func setOrientation(id: String, score: NSNumber) {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
        var fetchScore: [Score]
        
        do {
            fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
        } catch {
            fatalError("Failed to get Score")
        }
        fetchScore[0].orientation = score;
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Score Object with playerID")
        }
    }
    
    func setImmMemory(id: String, score: NSNumber) {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
        var fetchScore: [Score]
        
        do {
            fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
        } catch {
            fatalError("Failed to get Score")
        }
        fetchScore[0].immediateMemory = score;
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Score Object with playerID")
        }
    }
    
    func setConcentration(id: String, score: NSNumber) {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
        var fetchScore: [Score]
        
        do {
            fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
        } catch {
            fatalError("Failed to get Score")
        }
        fetchScore[0].concentration = score;
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Score Object with playerID")
        }
    }
    
    func setDelayedRecall(id: String, score: NSNumber) {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
        var fetchScore: [Score]
        
        do {
            fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
        } catch {
            fatalError("Failed to get Score")
        }
        fetchScore[0].delayedRecall = score;
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Score Object with playerID")
        }
    }
    
    func setSACTotal(id: NSNumber, score: NSNumber) {
        
    }
    
    func setMaddocks(id: String, score: NSNumber) {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
        var fetchScore: [Score]
        
        do {
            fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
        } catch {
            fatalError("Failed to get Score")
        }
        fetchScore[0].maddocks = score;
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Score Object with playerID")
        }
    }
    
    func setGlasgow(id: String, score: NSNumber) {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
        var fetchScore: [Score]
        
        do {
            fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
        } catch {
            fatalError("Failed to get Score")
        }
        fetchScore[0].glasgow = score;
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Score Object with playerID")
        }
    }
  
    func setBalance(id: String, score: NSNumber) {
      let fetchRequest = NSFetchRequest(entityName: "Score");
      fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
      var fetchScore: [Score]
      
      do {
        fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
      } catch {
        fatalError("Failed to get Score")
      }
      fetchScore[0].balance = score;
      
      do {
        try self.managedObjectContext.save()
      } catch {
        fatalError("Cannot create Score Object with playerID")
      }
    }
  
    func setScoreType(id: String, type: String) {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
        var fetchScore: [Score]
        
        do {
            fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
        } catch {
            fatalError("Failed to get Score")
        }
        fetchScore[0].scoreType = type;
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Score Object with playerID")
        }
    }

    
    func setNeckExam(id: String, flexVal: [String]) {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
        var fetchScore: [Score]
        
        do {
            fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
        } catch {
            fatalError("Failed to get Score")
        }
      for i in 0..<flexVal.count
      {
        switch i{
          case 0:   fetchScore[0].flexion = flexVal[i];
          case 1:   fetchScore[0].exten = flexVal[i];
          case 2:   fetchScore[0].rRotation = flexVal[i];
          case 3:   fetchScore[0].lRotation = flexVal[i];
          case 4:   fetchScore[0].rLateralFlex = flexVal[i];
          case 5:   fetchScore[0].lLateralFlex = flexVal[i];
          default: print("out of bounds")
        }

      }
      
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Score Object with playerID")
        }
    }
    
    func setNeckExam(id: String, tenderVal: [String]) {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
        var fetchScore: [Score]
        
        do {
            fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
        } catch {
            fatalError("Failed to get Score")
        }
      for i in 0..<tenderVal.count
      {
        switch i{
        case 0:   fetchScore[0].rParaspinalTenderness = tenderVal[i];
        case 1:   fetchScore[0].lParaspinalTenderness  = tenderVal[i];
        case 2:   fetchScore[0].bonyTenderness  = tenderVal[i];
        default: print("out of bounds")
        }
        
      }

        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Score Object with playerID")
        }
    }
    
  func setNeckExamUpperSensation(id: String, upSenseVal: [String]) {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
        var fetchScore: [Score]
        
        do {
            fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
        } catch {
            fatalError("Failed to get Score")
        }
    
        for i in 0..<upSenseVal.count
        {
          switch i{
          case 0:   fetchScore[0].rUpSensation = upSenseVal[i];
          case 1:   fetchScore[0].lUpSensation  = upSenseVal[i];
          default: print("out of bounds")
          }
          
        }


        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot create Score Object with playerID")
        }
    }
    
  func setNeckExamUpperStrength(id: String, upStrengthVal: [String]) {
    let fetchRequest = NSFetchRequest(entityName: "Score");
    fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
    var fetchScore: [Score]
    
    do {
      fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
    } catch {
      fatalError("Failed to get Score")
    }
    
    for i in 0..<upStrengthVal.count
    {
      switch i{
      case 0:   fetchScore[0].rUpStrength = upStrengthVal[i];
      case 1:   fetchScore[0].lUpStrength  = upStrengthVal[i];
      default: print("out of bounds")
      }
      
    }
    
    
    do {
      try self.managedObjectContext.save()
    } catch {
      fatalError("Cannot create Score Object with playerID")
    }
  }
  
  func setNeckExamLowerSensation(id: String, loSenseVal: [String]) {
    let fetchRequest = NSFetchRequest(entityName: "Score");
    fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
    var fetchScore: [Score]
    
    do {
      fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
    } catch {
      fatalError("Failed to get Score")
    }
    
    for i in 0..<loSenseVal.count
    {
      switch i{
      case 0:   fetchScore[0].rLowSensation = loSenseVal[i];
      case 1:   fetchScore[0].lLowSensation  = loSenseVal[i];
      default: print("out of bounds")
      }
      
    }
    
    
    do {
      try self.managedObjectContext.save()
    } catch {
      fatalError("Cannot create Score Object with playerID")
    }
  }
  func setNeckExamLowerStrength(id: String, loStrengthVal: [String]) {
    let fetchRequest = NSFetchRequest(entityName: "Score");
    fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
    var fetchScore: [Score]
    
    do {
      fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
    } catch {
      fatalError("Failed to get Score")
    }
    
    for i in 0..<loStrengthVal.count
    {
      switch i{
      case 0:   fetchScore[0].rLowStrength = loStrengthVal[i];
      case 1:   fetchScore[0].lLowStrength  = loStrengthVal[i];
      default: print("out of bounds")
      }
      
    }
    
    
    do {
      try self.managedObjectContext.save()
    } catch {
      fatalError("Cannot create Score Object with playerID")
    }
  }
  
    func setDomFoot(id: String, score: NSString) {
      let fetchRequest = NSFetchRequest(entityName: "Score");
      fetchRequest.predicate = NSPredicate(format: "scoreID == %@", id);
      var fetchScore: [Score]
      
      do {
        fetchScore = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Score]
      } catch {
        fatalError("Failed to get Score")
      }
      fetchScore[0].domFoot = score;
      
      do {
        try self.managedObjectContext.save()
      } catch {
        fatalError("Cannot create Score Object with playerID")
      }
    }
  
  

    
    
    /********************************************************************************************
     * PLAYER SETTER FUNCTIONS
     ********************************************************************************************/
    
    func setIDNumber(id: String, studentID: String)
    {
        let fetchRequest = NSFetchRequest(entityName: "Player")
        fetchRequest.predicate = NSPredicate(format: "playerID == %@", id);
        var fetchPlayer: [Player]
        
        do {
            fetchPlayer = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Player]
        } catch {
            fatalError("Failed to get Player")
        }
        
        fetchPlayer[0].idNumber = studentID
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot save first name with playerID")
        }
    }
    
    func setFirstName(id: String, name: String)
    {
        let fetchRequest = NSFetchRequest(entityName: "Player")
        fetchRequest.predicate = NSPredicate(format: "playerID == %@", id);
        var fetchPlayer: [Player]
        
        do {
            fetchPlayer = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Player]
        } catch {
            fatalError("Failed to get Player")
        }
        
        fetchPlayer[0].firstName = name
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot save first name with playerID")
        }
    }
    
    func setLastName(id: String, name: String)
    {
        let fetchRequest = NSFetchRequest(entityName: "Player")
        fetchRequest.predicate = NSPredicate(format: "playerID == %@", id);
        var fetchPlayer: [Player]
        
        do {
            fetchPlayer = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Player]
        } catch {
            fatalError("Failed to get Player")
        }
        
        fetchPlayer[0].lastName = name
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot save first name with playerID")
        }
    }
    
    func setBirthday(id: String, date: NSDate)
    {
        let fetchRequest = NSFetchRequest(entityName: "Player")
        fetchRequest.predicate = NSPredicate(format: "playerID == %@", id);
        var fetchPlayer: [Player]
        
        do {
            fetchPlayer = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Player]
        } catch {
            fatalError("Failed to get Player")
        }
        
        fetchPlayer[0].birthday = date
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot save first name with playerID")
        }
    }
    
    func setGender(id: String, gender: String)
    {
        let fetchRequest = NSFetchRequest(entityName: "Player")
        fetchRequest.predicate = NSPredicate(format: "playerID == %@", id);
        var fetchPlayer: [Player]
        
        do {
            fetchPlayer = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Player]
        } catch {
            fatalError("Failed to get Player")
        }
        
        fetchPlayer[0].gender = gender
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot save first name with playerID")
        }
    }
    

    func setTeamName(id: String, name: String)
    {
        let fetchRequest = NSFetchRequest(entityName: "Player")
        fetchRequest.predicate = NSPredicate(format: "playerID == %@", id);
        var fetchPlayer: [Player]
        
        do {
            fetchPlayer = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Player]
        } catch {
            fatalError("Failed to get Player")
        }
        
        fetchPlayer[0].teamName = name
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot save first name with playerID")
        }
    }
    
    func setBaselineForPlayer(id: String, baseline: String)
    {
        let fetchRequest = NSFetchRequest(entityName: "Player")
        fetchRequest.predicate = NSPredicate(format: "playerID == %@", id);
        var fetchPlayer: [Player]
        
        do {
            fetchPlayer = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Player]
        } catch {
            fatalError("Failed to get Player")
        }
        
        fetchPlayer[0].baselineScore = baseline
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Cannot save first name with playerID")
        }
    }
    
    /*
    // create an Score Object and save it
    func insertNewScore() {
        NSEntityDescription.insertNewObjectForEntityForName("Score", inManagedObjectContext: managedObjectContext) as! Score
        
        my_score.score
        do {
            try self.managedObjectContext.save()
        } catch {
            // error handling
        }
    }
    */
    
    
    /*
    
    // Get the employee(s) with a specific name
    func employeeWithName(name: String) -> [Employee] {
        let fetchRequest = NSFetchRequest(entityName: "Employee");
        fetchRequest.predicate = NSPredicate(format: "firstName == %@", name);
        
        do {
            let fetchedEmployees = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Employee]
            for e in fetchedEmployees {
                NSLog(e.firstName! + " " + e.lastName! + " at " + e.location!)
            }
            return fetchedEmployees
        } catch {
            fatalError("Failed to fetch employees")
        }
        
        return []
    }
*/
    
    // Get the number of players
    func numberOfPlayersInDatabase() -> Int {
        let fetchRequest = NSFetchRequest(entityName: "Score");
        do {
            let fetchedPlayer = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Player]
            return fetchedPlayer.count
        } catch {
            fatalError("Failed to fetch players")
        }
        return 0;
    }
}