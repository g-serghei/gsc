//
//  main.swift
//
//  Created by Serghei Grigoruta on 14.04.2021.

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

class Variables {
    private var variables = Dictionary<String, Any>()

    func has(name: String) -> Bool {
        variables[name] != nil
    }

    func set(name: String, value: Any) {
        variables[name] = value
    }

    func get(name: String) -> Any? {
        variables[name]
    }
}

class Main {
    static var showTree = true


    static func run() {
        let variables = Variables()

        while true {
            print(Colors.yellow, "input > ", separator: "", terminator: "")

            let line = readLine()!

            if line == "#showTree" {
                showTree.toggle()
                print(showTree ? "Showing parse tree" : "Hiding parse tree")
                continue
            }

            let syntaxTree = SyntaxTree.parse(text: line)
            let compilation = Compilation(syntax: syntaxTree)
            let result = compilation.evaluate(variables: variables)
            let diagnostics = result.diagnostics

            if showTree {
                prettyPrint(node: syntaxTree.root)
            }

            if diagnostics.isEmpty {
                guard let value = result.value else {
                    fatalError("Value is nil")
                }

                print(Colors.blue, value, separator: "")
            } else {
                for diagnostic in diagnostics {
                    print(Colors.red, diagnostic, separator: "")

                    let prefix = line.substring(to: diagnostic.span.start)
                    let error = line.substring(with: diagnostic.span.start..<diagnostic.span.start + diagnostic.span.length)
                    let suffix = line.substring(from: diagnostic.span.start + diagnostic.span.length)

                    print(Colors.reset, "    ", separator: "", terminator: "")
                    print(Colors.reset, prefix, separator: "", terminator: "")
                    print(Colors.red, error, separator: "", terminator: "")
                    print(Colors.reset, suffix, separator: "", terminator: "")
                    print()
                }

                print()
            }
        }
    }

    static func prettyPrint(node: SyntaxNode, indent: String = "", isLast: Bool = true) {
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
}

Main.run()