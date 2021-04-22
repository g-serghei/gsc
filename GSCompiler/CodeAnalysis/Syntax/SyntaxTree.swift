//
// Created by Serghei Grigoruta on 17.04.2021.
//

class SyntaxTree {
    public var diagnostics: DiagnosticBag = DiagnosticBag()
    public var root: ExpressionSyntax
    public var endOfFileToken: SyntaxToken

    init(diagnostics: DiagnosticBag, root: ExpressionSyntax, endOfFileToken: SyntaxToken) {
        self.diagnostics = diagnostics
        self.root = root
        self.endOfFileToken = endOfFileToken
    }

    static func parse(text: String) -> SyntaxTree {
        let parser = Parser(text: text)

        return parser.parse()
    }

    static func parseToken(text: String) -> [SyntaxToken] {
        let lexer = Lexer(text: text)
        var tokens: [SyntaxToken] = []

        while true {
            let token = lexer.lex()

            if token.kind == .endOfFileToken {
                break
            }

            tokens.append(token)
        }

        return tokens
    }
}
