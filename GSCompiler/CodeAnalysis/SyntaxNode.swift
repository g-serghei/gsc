//
// Created by Serghei Grigoruta on 17.04.2021.
//

import Foundation

protocol SyntaxNode {
    var kind: SyntaxKind { get }

    func getChildren() -> [SyntaxNode]
}

extension SyntaxNode {
    func getChildren() -> [SyntaxNode] {
        []
    }
}
