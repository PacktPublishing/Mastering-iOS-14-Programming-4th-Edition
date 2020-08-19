//
//  NSPersistentContainer.swift
//  MustC
//
//  Created by Mario Eguiluz on 29/07/2020.
//  Copyright © 2020 DonnyWals. All rights reserved.
//

import Foundation
import CoreData

extension NSPersistentContainer {
  func saveContextIfNeeded() {
    if viewContext.hasChanges {
      do {
        try viewContext.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}
