//
// Created by Serghei Grigoruta on 21.04.2021.
//

class NameExpressionSyntax: ExpressionSyntax {
    public var identifierToken: SyntaxToken
    override var kind: SyntaxKind {
        .nameExpression
    }

    init(identifierToken: SyntaxToken) {
        self.identifierToken = identifierToken
    }

    override func getChildren() -> [SyntaxNode] {
        [identifierToken]
    }
}