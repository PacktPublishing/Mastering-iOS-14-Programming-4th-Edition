//
//  Datasource.swift
//  todo_start
//
//  Created by Mario Eguiluz on 16/02/2021.
//

import Foundation

// MARK: - Datasource

let fileName = "my-todo-list"
let fullPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)

struct Datasource {
  func load() -> [Category] {
    do {
      let data = try Data(contentsOf: fullPath)
      if let categories = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Category] {
        return categories
      }
    } catch {
      print("ERROR: \(error.localizedDescription)")
    }
    return defaultCategories()
  }

  func save(categories: [Category]) {
    do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: categories, requiringSecureCoding: false)
        try data.write(to: fullPath)
    } catch {
        print("ERROR: \(error.localizedDescription)")
    }
  }

  func getDocumentsDirectory() -> URL {
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return paths[0]
  }

  func defaultCategories() -> [Category] {
    let work = Category(title: "Work", entries: [
      Entry(text: "Call boss", done: false, priority: .high),
      Entry(text: "Send email to investors", done: false, priority: .high),
      Entry(text: "Prepare team meeting", done: false, priority: .medium)
    ])
    let grocery = Category(title: "Grocery", entries: [
      Entry(text: "Buy olive oil", done: false, priority: .medium),
      Entry(text: "Buy drinks", done: false, priority: .low)
    ])
    let home = Category(title: "Home", entries: [Entry(text: "Clean carpet", done: true, priority: .low)])
    return [work, grocery, home]
  }
}

// MARK: - Category

struct Category {
  let title: String
  let entries: [Entry]
}

// MARK: - Entry

struct Entry {
  let text: String
  let done: Bool
  let priority: Priority
}

enum Priority: Int {
  case low
  case medium
  case high

  static func name(for value: Int) -> String {
    switch value {
    case 0:
      return "Low"
    case 1:
      return "Medium"
    case 2:
      return "High"
    default:
      return "Unknown"
    }
  }
}
