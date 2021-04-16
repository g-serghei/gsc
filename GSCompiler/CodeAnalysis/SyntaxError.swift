//
// Created by Serghei Grigoruta on 17.04.2021.
//

import Foundation

enum SyntaxError: Error {
    case unexpectedBinaryOperator(kind: SyntaxKind)
    case unexpectedNode(kind: SyntaxKind)
}
