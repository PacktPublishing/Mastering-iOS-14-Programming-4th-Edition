//
//  NSManagedObjectContext .swift
//  MustC
//
//  Created by Mario Eguiluz on 29/07/2020.
//  Copyright © 2020 DonnyWals. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
  func persist(block: @escaping () -> Void) {
    perform {

      block()

      do {
        try self.save()
      } catch {
        self.rollback()
      }
    }
  }
}
