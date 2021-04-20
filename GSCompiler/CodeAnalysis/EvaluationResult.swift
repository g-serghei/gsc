//
// Created by Serghei Grigoruta on 20.04.2021.
//

class EvaluationResult {
    public var diagnostics: DiagnosticBag
    public var value: Any?

    init(diagnostics: DiagnosticBag, value: Any?) {
        self.diagnostics = diagnostics
        self.value = value
    }
}
