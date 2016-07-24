//
//  VERArticleCache.swift
//  Verus
//
//  Created by Anthony Williams on 7/23/16.
//  Copyright © 2016 Verus. All rights reserved.
//

import Foundation
import CoreData

class VERArticleCache {
    
    var managedContext: NSManagedObjectContext!
    let articleEntityName = "Article"
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    func getArticles() -> [NSDictionary]? {
        let articleFetch = NSFetchRequest(entityName: articleEntityName)
        articleFetch.resultType = .DictionaryResultType
        
        do {
            let results = try managedContext.executeFetchRequest(articleFetch)
            
            if let results = results as? [NSDictionary] {
                return results
            }
        } catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func saveArticle(data: NSDictionary) {
        let articleEntity = NSEntityDescription.entityForName(articleEntityName, inManagedObjectContext: managedContext)
        
        let article = Article(entity: articleEntity!, insertIntoManagedObjectContext: managedContext)
        article.title = "\(data["title"]!)"
        article.text = "\(data["text"]!)"
        article.keywords = "\(data["keywords"]!)"
        article.descriptiveWords = "\(data["descriptiveWords"]!)"
        article.rating = data["rating"] as? NSNumber
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error: \(error) " +
                "description \(error.localizedDescription)")
        }
    }
    
    func emptyCoreData() {
        let entity = "Article"
        let fetchRequest = NSFetchRequest(entityName: entity)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}