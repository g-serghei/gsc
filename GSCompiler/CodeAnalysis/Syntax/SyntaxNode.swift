//
// Created by Serghei Grigoruta on 17.04.2021.
//

protocol SyntaxNode {
    var kind: SyntaxKind { get }

    func getChildren() -> [SyntaxNode]
}

class ExpressionSyntax: SyntaxNode {
    var kind: SyntaxKind { .defaultKind }

    func getChildren() -> [SyntaxNode] {
        []
    }
}