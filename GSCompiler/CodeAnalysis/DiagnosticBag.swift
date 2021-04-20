//
// Created by Serghei Grigoruta on 20.04.2021.
//

class DiagnosticBag: Sequence {
    private var diagnostics: [Diagnostic] = []

    public var isEmpty: Bool {
        diagnostics.isEmpty
    }

    func makeIterator() -> IndexingIterator<[Diagnostic]> {
        diagnostics.makeIterator()
    }

    func append(contentsOf: DiagnosticBag) {
        diagnostics.append(contentsOf: contentsOf.diagnostics)
    }

    private func report(span: TextSpan, message: String) {
        let diagnostic = Diagnostic(span: span, message: message)

        diagnostics.append(diagnostic)
    }

    func reportInvalidNumber(span: TextSpan, text: String, type: DataType) {
        let message = "The number '\(text)' is not a valid '\(type)'"

        report(span: span, message: message)
    }


    func reportBadCharacter(position: Int, character: Character) {
        let span = TextSpan(start: position, length: 1)
        let message = "Bad character input: '\(character)'"

        report(span: span, message: message)
    }

    func reportUnexpectedToken(span: TextSpan, actualKind: SyntaxKind, expectedKind: SyntaxKind) {
        let message = "Unexpected token: '\(actualKind)', expected: '\(expectedKind)'"

        report(span: span, message: message)
    }

    func reportUndefinedUnaryOperator(span: TextSpan, text: String, type: DataType) {
        let message = "Unary operator '\(text)' is not defined for type '\(type)'"

        report(span: span, message: message)
    }

    func reportUndefinedBinaryOperator(span: TextSpan, text: String, leftType: DataType, rightType: DataType) {
        let message = "Binary operator '\(text)' is not defined for types '\(leftType)' and '\(rightType)'"

        report(span: span, message: message)
    }

    func reportUndefinedName(span: TextSpan, name: String) {
        let message = "Variable '\(name)' doesn't exist"

        report(span: span, message: message)
    }
}