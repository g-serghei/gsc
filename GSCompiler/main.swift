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

enum SyntaxKind {
    case numberToken
    case whitespaceToken
    case plusToken
    case minusToken
    case startToken
    case slashToken
    case openParenthesisToken
    case closeParenthesisToken
    case badToken
    case endOfFileToken

    case numberExpression
    case binaryExpression
    case parenthesizedExpression
}

class SyntaxToken: SyntaxNode {
    public var kind: SyntaxKind;
    public var position: Int;
    public var text: String;
    public var value: Any?;

    init(kind: SyntaxKind, position: Int, text: String, value: Any?) {
        self.kind = kind
        self.position = position
        self.text = text
        self.value = value
    }

    func getChildren() -> [SyntaxNode] {
        []
    }
}

class Lexer {
    private var text: String
    private var position: Int
    public var diagnostics: [String] = []

    private var current: Character {
        get {
            if position >= text.count {
                return "\0"
            }

            return Array(text)[position]
        }
    }

    init(text: String) {
        self.text = text
        position = 0
    }

    private func next() {
        position += 1
    }

    func nextToken() -> SyntaxToken {
        if position >= text.count {
            return SyntaxToken(kind: .endOfFileToken, position: position, text: "\0", value: nil)
        }

        if current.isWhitespace {
            let start = position

            while current.isWhitespace {
                next()
            }

            let length = position - start
            let startIndex = text.index(text.startIndex, offsetBy: start)
            let endIndex = text.index(text.startIndex, offsetBy: start + length)
            let text = String(self.text[startIndex..<endIndex])

            return SyntaxToken(kind: .whitespaceToken, position: start, text: text, value: nil)
        }

        if current.isNumber {
            let start = position

            while current.isNumber {
                next()
            }

            let length = position - start
            let startIndex = text.index(text.startIndex, offsetBy: start)
            let endIndex = text.index(text.startIndex, offsetBy: start + length)
            let text = String(self.text[startIndex..<endIndex])

            guard let value = Int(text) else {
                diagnostics.append("The number '\(text)' is not a valid Int32")

                return SyntaxToken(kind: .numberToken, position: start, text: text, value: 0)
            }

            return SyntaxToken(kind: .numberToken, position: start, text: text, value: value as Any)
        }

        var kind: SyntaxKind = .badToken

        switch current {
        case "+":
            kind = .plusToken
        case "-":
            kind = .minusToken
        case "*":
            kind = .startToken
        case "/":
            kind = .slashToken
        case "(":
            kind = .openParenthesisToken
        case ")":
            kind = .closeParenthesisToken
        default:
            kind = .badToken
        }

        if kind == .badToken {
            diagnostics.append("Error: Bad character input: '\(current)'")
        }

        let token = SyntaxToken(kind: kind, position: position, text: String(current), value: nil);

        next()

        return token
    }
}

protocol SyntaxNode {
    var kind: SyntaxKind { get }

    func getChildren() -> [SyntaxNode]
}

extension SyntaxNode {
    func getChildren() -> [SyntaxNode] {
        []
    }
}

class SyntaxTree {
    public var diagnostics: [String]
    public var root: SyntaxNode
    public var endOfFileToken: SyntaxToken

    init(diagnostics: [String], root: SyntaxNode, endOfFileToken: SyntaxToken) {
        self.diagnostics = diagnostics
        self.root = root
        self.endOfFileToken = endOfFileToken
    }

    static func parse(text: String) -> SyntaxTree {
        let parser = Parser(text: text)

        return parser.parse()
    }
}

class NumberExpressionSyntax: SyntaxNode {
    public var numberToken: SyntaxToken

    var kind: SyntaxKind {
        get {
            .numberExpression
        }
    }

    init(numberToken: SyntaxToken) {
        self.numberToken = numberToken
    }

    func getChildren() -> [SyntaxNode] {
        [numberToken]
    }
}

class BinaryExpressionSyntax: SyntaxNode {
    public var left: SyntaxNode
    public var operatorToken: SyntaxToken
    public var right: SyntaxNode

    var kind: SyntaxKind {
        get {
            .binaryExpression
        }
    }

    init(left: SyntaxNode, operatorToken: SyntaxToken, right: SyntaxNode) {
        self.left = left
        self.operatorToken = operatorToken
        self.right = right
    }

    func getChildren() -> [SyntaxNode] {
        [left, operatorToken, right]
    }
}

class ParenthesizedExpressionToken: SyntaxNode {
    public var openParenthesisToken: SyntaxToken
    public var expression: SyntaxNode
    public var closeParenthesisToken: SyntaxToken

    var kind: SyntaxKind {
        get {
            .parenthesizedExpression
        }
    }

    init(openParenthesisToken: SyntaxToken, expression: SyntaxNode, closeParenthesisToken: SyntaxToken) {
        self.openParenthesisToken = openParenthesisToken
        self.expression = expression
        self.closeParenthesisToken = closeParenthesisToken
    }

    func getChildren() -> [SyntaxNode] {
        [openParenthesisToken, expression, closeParenthesisToken]
    }
}

class Parser {
    private(set) var tokens: [SyntaxToken] = []
    private var _position: Int
    public var diagnostics: [String] = []

    private var current: SyntaxToken {
        get {
            peek(offset: 0)
        }
    }

    init(text: String) {
        _position = 0
        let lexer = Lexer(text: text)
        var token: SyntaxToken

        repeat {
            token = lexer.nextToken()

            if token.kind != .whitespaceToken && token.kind != .badToken {
                tokens.append(token)
            }
        } while token.kind != .endOfFileToken


        diagnostics.append(contentsOf: lexer.diagnostics)
    }

    func peek(offset: Int) -> SyntaxToken {
        let index = _position + offset
        if index >= tokens.count {
            return tokens.last!
        }

        return tokens[index]
    }

    func nextToken() -> SyntaxToken {
        let cur = current
        _position += 1
        return cur
    }

    func match(kind: SyntaxKind) -> SyntaxToken {
        if current.kind == kind {
            return nextToken()
        }

        diagnostics.append("Error: Unexpected token: '\(current.kind)', expected: '\(kind)'")

        return SyntaxToken(kind: kind, position: current.position, text: "", value: nil)
    }

    func parseExpression() -> SyntaxNode {
        parseTerm()
    }

    func parse() -> SyntaxTree {
        let expression = parseTerm()
        let endOfFileToken = match(kind: .endOfFileToken)

        return SyntaxTree(diagnostics: diagnostics, root: expression, endOfFileToken: endOfFileToken)
    }

    func parseTerm() -> SyntaxNode {
        var left = parseFactor()

        let operationKinds: [SyntaxKind] = [.plusToken, .minusToken]

        while operationKinds.contains(current.kind) {
            let operatorToken = nextToken()
            let right = parseFactor()
            left = BinaryExpressionSyntax(left: left, operatorToken: operatorToken, right: right)
        }

        return left
    }

    func parseFactor() -> SyntaxNode {
        var left = parsePrimaryExpression()

        let operationKinds: [SyntaxKind] = [.startToken, .slashToken]

        while operationKinds.contains(current.kind) {
            let operatorToken = nextToken()
            let right = parsePrimaryExpression()
            left = BinaryExpressionSyntax(left: left, operatorToken: operatorToken, right: right)
        }

        return left
    }

    func parsePrimaryExpression() -> SyntaxNode {
        if current.kind == .openParenthesisToken {
            let left = nextToken()
            let expression = parseExpression()
            let right = match(kind: .closeParenthesisToken)

            return ParenthesizedExpressionToken(openParenthesisToken: left, expression: expression, closeParenthesisToken: right)
        }

        let numberToken = match(kind: .numberToken)

        return NumberExpressionSyntax(numberToken: numberToken)
    }


}

enum SyntaxError: Error {
    case unexpectedBinaryOperator(kind: SyntaxKind)
    case unexpectedNode(kind: SyntaxKind)
}

class Evaluator {
    private var root: SyntaxNode

    init(root: SyntaxNode) {
        self.root = root
    }

    func evaluate() -> Int {
        try! evaluateExpression(node: root)
    }

    func evaluateExpression(node: SyntaxNode) throws -> Int {
        if let n = node as? NumberExpressionSyntax {
            return n.numberToken.value as! Int
        }

        if let b = node as? BinaryExpressionSyntax {
            let left = try evaluateExpression(node: b.left)
            let right = try evaluateExpression(node: b.right)

            switch b.operatorToken.kind {
            case .plusToken:
                return left + right
            case .minusToken:
                return left - right
            case .startToken:
                return left * right
            case .slashToken:
                return left / right
            default:
                throw SyntaxError.unexpectedBinaryOperator(kind: b.operatorToken.kind)
            }
        }

        if let p = node as? ParenthesizedExpressionToken {
            return try evaluateExpression(node: p.expression)
        }

        throw SyntaxError.unexpectedNode(kind: node.kind)
    }
}
