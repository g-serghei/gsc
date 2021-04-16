//
// Created by Serghei Grigoruta on 17.04.2021.
//

import Foundation

class SyntaxToken: SyntaxNode {
    public var kind: SyntaxKind;
    public var position: Int;
    public var text: String;
    public var value: Any?;

    init(kind: SyntaxKind, position: Int, text: String, value: Any?) {
        self.kind = kind
        self.position = position
        self.text = text
        self.value = value
    }

    func getChildren() -> [SyntaxNode] {
        []
    }
}
