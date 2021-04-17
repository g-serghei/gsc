//
// Created by Serghei Grigoruta on 17.04.2021.
//

import Foundation

class UnaryExpressionSyntax: SyntaxNode {
    public var operatorToken: SyntaxToken
    public var operand: SyntaxNode

    var kind: SyntaxKind {
        get {
            .unaryExpression
        }
    }

    init(operatorToken: SyntaxToken, operand: SyntaxNode) {
        self.operatorToken = operatorToken
        self.operand = operand
    }

    func getChildren() -> [SyntaxNode] {
        [operatorToken, operand]
    }
}
