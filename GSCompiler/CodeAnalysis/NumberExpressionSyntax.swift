//
// Created by Serghei Grigoruta on 17.04.2021.
//

import Foundation

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
