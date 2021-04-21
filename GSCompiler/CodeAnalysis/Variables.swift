//
// Created by Serghei Grigoruta on 21.04.2021.
//

class Variables {
    private var variables = Dictionary<VariableSymbol, Any>()

    func has(symbol: VariableSymbol) -> Bool {
        variables[symbol] != nil
    }

    func has(name: String) -> Bool {
        let symbol = variables.keys.first { variableSymbol in variableSymbol.name == name }

        return symbol != nil
    }

    func remove(forKey: VariableSymbol) {
        variables.removeValue(forKey: forKey)
    }

    func set(symbol: VariableSymbol, value: Any?) {
        variables[symbol] = value
    }

    func getBy(symbol: VariableSymbol) -> Any? {
        variables[symbol]
    }

    func getKeyBy(name: String) -> VariableSymbol? {
        variables.keys.first { variableSymbol in variableSymbol.name == name }
    }
}
