import NAPIC

fileprivate func createFunction(_ env: napi_env, named name: String, _ function: @escaping Callback) throws -> napi_value {
    var result: napi_value?
    let nameData = name.data(using: .utf8)!

    let data = CallbackData(callback: function)
    let dataPointer = Unmanaged.passRetained(data).toOpaque()

    let status = nameData.withUnsafeBytes { nameBytes in
        napi_create_function(env, nameBytes, nameData.count, swiftNAPICallback, dataPointer, &result)
    }

    guard status == napi_ok else { throw NAPI.Error(status) }

    return result!
}

fileprivate enum InternalFunction {
    case javascript(napi_value)
    case swift(String, Callback)
}

public class Function: ValueConvertible {
    fileprivate let value: InternalFunction

    public required init(_ env: napi_env, from: napi_value) throws {
        self.value = .javascript(from)
    }

    public init(named name: String, _ callback: @escaping Callback) {
        self.value = .swift(name, callback)
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch value {
            case .swift(let name, let callback): return try createFunction(env, named: name, callback)
            case .javascript(let value): return value
        }
    }
}

/* constructor overloads */
extension Function {
    /* (...) -> Void */

    public convenience init(named name: String, _ callback: @escaping () throws -> Void) {
        self.init(named: name, { (_, _, _) in try callback(); return Value.undefined })
    }

    public convenience init<A: ValueConvertible>(named name: String, _ callback: @escaping (A) throws -> Void) {
        self.init(named: name, { (env, argv, _) in try callback(A(env, from: argv[0])); return Value.undefined })
    }

    public convenience init<A: ValueConvertible, B: ValueConvertible>(named name: String, _ callback: @escaping (A, B) throws -> Void) {
        self.init(named: name, { (env, argv, _) in try callback(A(env, from: argv[0]), B(env, from: argv[1])); return Value.undefined })
    }

    /* (env, ...) -> Void */

    public convenience init(named name: String, _ callback: @escaping (napi_env) throws -> Void) {
        self.init(named: name, { (env, _, _) in try callback(env); return Value.undefined })
    }

    public convenience init<A: ValueConvertible>(named name: String, _ callback: @escaping (napi_env, A) throws -> Void) {
        self.init(named: name, { (env, argv, _) in try callback(env, A(env, from: argv[0])); return Value.undefined })
    }

    public convenience init<A: ValueConvertible, B: ValueConvertible>(named name: String, _ callback: @escaping (napi_env, A, B) throws -> Void) {
        self.init(named: name, { (env, argv, _) in try callback(env, A(env, from: argv[0]), B(env, from: argv[1])); return Value.undefined })
    }
}

/* call(...) */
extension Function {
    fileprivate func _call(_ env: napi_env, this: napi_value, args: [napi_value?]) throws -> Void {
        let handle = try self.napiValue(env)

        let status = args.withUnsafeBufferPointer { argsBytes in
            napi_call_function(env, this, handle, args.count, argsBytes.baseAddress, nil)
        }

        guard status == napi_ok else { throw NAPI.Error(status) }
    }

    fileprivate func _call<Result: ValueConvertible>(_ env: napi_env, this: napi_value, args: [napi_value?]) throws -> Result {
        let handle = try self.napiValue(env)

        var result: napi_value?
        let status = args.withUnsafeBufferPointer { argsBytes in
            napi_call_function(env, this, handle, args.count, argsBytes.baseAddress, &result)
        }

        guard status == napi_ok else { throw NAPI.Error(status) }

        return try Result(env, from: result!)
    }

    /* (...) -> Void */

    public func call(_ env: napi_env) throws -> Void {
        return try _call(env, this: Value.undefined.napiValue(env), args: [])
    }

    public func call<A: ValueConvertible>(_ env: napi_env, _ a: A) throws -> Void {
        return try _call(env, this: Value.undefined.napiValue(env), args: [a.napiValue(env)])
    }

    public func call<A: ValueConvertible, B: ValueConvertible>(_ env: napi_env, _ a: A, _ b: B) throws -> Void {
        return try _call(env, this: Value.undefined.napiValue(env), args: [a.napiValue(env), b.napiValue(env)])
    }

    /* (...) -> ValueConvertible */

    public func call<Result: ValueConvertible>(_ env: napi_env) throws -> Result {
        return try _call(env, this: Value.undefined.napiValue(env), args: [])
    }

    public func call<Result: ValueConvertible, A: ValueConvertible>(_ env: napi_env, _ a: A) throws -> Result {
        return try _call(env, this: Value.undefined.napiValue(env), args: [a.napiValue(env)])
    }

    public func call<Result: ValueConvertible, A: ValueConvertible, B: ValueConvertible>(_ env: napi_env, _ a: A, _ b: B) throws -> Result {
        return try _call(env, this: Value.undefined.napiValue(env), args: [a.napiValue(env), b.napiValue(env)])
    }
}
