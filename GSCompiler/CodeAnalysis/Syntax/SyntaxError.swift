//
// Created by Serghei Grigoruta on 17.04.2021.
//

enum SyntaxError: Error {
    case unexpectedBinaryOperator(kind: SyntaxKind)
    case unexpectedUnaryOperator(kind: SyntaxKind)
    case unexpectedNode(kind: SyntaxKind)
}
