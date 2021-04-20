//
// Created by Serghei Grigoruta on 21.04.2021.
//

class AssignmentExpressionSyntax: ExpressionSyntax {
    public var identifierToken: SyntaxToken
    public var equalsToken: SyntaxToken
    public var expression: ExpressionSyntax
    override var kind: SyntaxKind {
        .assignmentExpression
    }

    init(identifierToken: SyntaxToken, equalsToken: SyntaxToken, expression: ExpressionSyntax) {
        self.identifierToken = identifierToken
        self.equalsToken = equalsToken
        self.expression = expression
    }

    override func getChildren() -> [SyntaxNode] {
        [identifierToken, equalsToken, expression]
    }
}