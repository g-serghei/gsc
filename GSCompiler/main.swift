//
//  main.swift
//
//  Created by Serghei Grigoruta on 14.04.2021.

import Foundation

var showTree = false

while true {
    let line = readLine()!

    if line == "#showTree" {
        showTree.toggle()
        print(showTree ? "Showing parse tree" : "Hiding parse tree")
        continue
    }

    let syntaxTree = SyntaxTree.parse(text: line)

    if showTree {
        prettyPrint(node: syntaxTree.root)
    }

    if syntaxTree.diagnostics.isEmpty {
        let e = Evaluator(root: syntaxTree.root)
        let result = e.evaluate()

        print(Colors.blue, result, separator: "")
    } else {
        for error in syntaxTree.diagnostics {
            print(Colors.red, error, separator: "")
        }
    }
}

struct Colors {
    static let reset = "\u{001B}[0;0m"
    static let black = "\u{001B}[0;30m"
    static let red = "\u{001B}[0;31m"
    static let green = "\u{001B}[0;32m"
    static let yellow = "\u{001B}[0;33m"
    static let blue = "\u{001B}[0;34m"
    static let magenta = "\u{001B}[0;35m"
    static let cyan = "\u{001B}[0;36m"
    static let white = "\u{001B}[0;37m"
}

func prettyPrint(node: SyntaxNode, indent: String = "", isLast: Bool = true) {
    let marker = isLast ? "└── " : "├── "

    print(Colors.yellow, indent, marker, node.kind, separator: "", terminator: "")

    if node is SyntaxToken {
        let token = node as! SyntaxToken

        if let value = token.value {
            print(Colors.yellow, " ", value, separator: "", terminator: "")
        }
    }

    print()

    let indentSum = indent + (isLast ? "    " : "│   ")
    let endIndex = node.getChildren().endIndex

    for (index, child) in node.getChildren().enumerated() {
        prettyPrint(node: child, indent: indentSum, isLast: index == endIndex - 1)
    }
}






