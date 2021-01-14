//
//  main.swift
//  TodoApp
//
//  Created by Eric Nguyen on 1/14/21.
//

import Foundation

let defaults = UserDefaults.standard
var todoList = [Any]()
struct DefaultsKeys {
    static let name = "name"
    static let todoList = "todoList"
}

func welcome() {
    if let name = defaults.string(forKey: DefaultsKeys.name) {
        print("Welcome back, \(name).")
    } else {
        print("Welcome to the ToDo App.")
        print("What is your name?", terminator: " ")
        if let name = readLine() {
            print("Hi, \(name)")
            defaults.set(name, forKey: DefaultsKeys.name)
        }
    }
    
    if let list = defaults.array(forKey: DefaultsKeys.todoList) {
        todoList = list
    } else {
        defaults.set(todoList, forKey: DefaultsKeys.todoList)
    }

    print("Type 'help' for a list of the available commands.")
}

func invalidCommand() {
    print("Invalid command. Type 'help' for more information.")
    run()
}

func run() {
    defer { defaults.set(todoList, forKey: DefaultsKeys.todoList) }
    print(">", terminator: " ")
    if let input = readLine() {
        let tokens = input.components(separatedBy: " ")
        switch tokens[0] {
        case "help":
            print("help \t\t\t\t\t\t\t List available commands")
            print("quit \t\t\t\t\t\t\t Quit the application")
            print("list \t\t\t\t\t\t\t List incomplete items in ToDo list")
//            print("list --all\t\t\t\t\t\t List all items in ToDo list")
//            print("list --complete \t\t\t\t List complete items in ToDo list")
            print("add [description] \t\t\t\t Add new ToDo item")
//            print("done [id] \t\t\t\t\t\t Mark a ToDo item as complete")
            print("save \t\t\t\t\t\t\t Save ToDo list")
            print("change name [new name] \t\t\t Change your name")
            print("change [id] [description] \t\t Change a ToDo item")
            print("done [id] \t\t\t\t\t\t\t Remove a ToDo item")
        case "quit": return
        case "list":
            if todoList.isEmpty {
                print("Your ToDo list is empty.")
            } else {
                print("Your ToDo List")
                for i in 0..<todoList.count {
                    print("\(i): \t\(todoList[i])")
                }
            }
        case "add":
            if tokens.count > 1 {
                let description = tokens.suffix(from: 1).joined(separator: " ")
                print("Added new item '\(description)'")
                todoList.append(description)
            }
        case "save":
            defaults.set(todoList, forKey: DefaultsKeys.todoList)
        case "change":
            if tokens.count > 2 {
                let arg3 = tokens.suffix(from: 2).joined(separator: " ")
                switch tokens[1] {
                case "name":
                    defaults.set(arg3, forKey: DefaultsKeys.name)
                    print("Hi there, \(defaults.string(forKey: DefaultsKeys.name)!).")
                default:
                    if let id = Int(tokens[1]) {
                        todoList[id] = arg3
                    } else {
                        invalidCommand()
                    }
                }
            } else {
                invalidCommand()
            }
        case "done":
            if tokens.count == 2 {
                if let id = Int(tokens[1]) {
                    todoList.remove(at: id)
                    print("Removed item \(id).")
                }
            }
        case "": run()
        default:
            invalidCommand()
        }
    } else {
        invalidCommand()
    }
    run()
}

welcome()
run()
