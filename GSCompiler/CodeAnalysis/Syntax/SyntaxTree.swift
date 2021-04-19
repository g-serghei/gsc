//
// Created by Serghei Grigoruta on 17.04.2021.
//

class SyntaxTree {
    public var diagnostics: [String] = []
    public var root: ExpressionSyntax
    public var endOfFileToken: SyntaxToken

    init(diagnostics: [String], root: ExpressionSyntax, endOfFileToken: SyntaxToken) {
        self.diagnostics = diagnostics
        self.root = root
        self.endOfFileToken = endOfFileToken
    }

    static func parse(text: String) -> SyntaxTree {
        let parser = Parser(text: text)

        return parser.parse()
    }
}
