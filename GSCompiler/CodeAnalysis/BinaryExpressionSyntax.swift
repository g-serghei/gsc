//
// Created by Serghei Grigoruta on 17.04.2021.
//

import Foundation

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
