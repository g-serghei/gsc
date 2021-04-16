//
// Created by Serghei Grigoruta on 17.04.2021.
//

import Foundation

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
