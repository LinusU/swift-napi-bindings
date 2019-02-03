import NAPIC
import Foundation

public typealias Callback = (napi_env, [napi_value], napi_value) throws -> ValueConvertible?

class CallbackData {
    let callback: Callback

    init(callback: @escaping Callback) {
        self.callback = callback
    }
}

@_cdecl("swift_napi_callback")
func swiftNAPICallback(_ env: napi_env!, _ cbinfo: napi_callback_info!) -> napi_value? {
    var this: napi_value?
    var argc: Int = 10

    let argvPointer = UnsafeMutableBufferPointer<napi_value?>.allocate(capacity: 10)
    let dataPointer = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: 1)

    napi_get_cb_info(env, cbinfo, &argc, argvPointer.baseAddress, &this, dataPointer)

    var argv = Array<napi_value?>(argvPointer)
    argv.removeLast(10 - argc)

    let data = Unmanaged<CallbackData>.fromOpaque(dataPointer.pointee!).takeUnretainedValue()

    do {
        return try data.callback(env, argv as! Array<napi_value>, this!)?.napiValue(env)
    } catch is NAPI.Error {
        return nil
    } catch {
        do {
            let status = napi_throw(env, try error.napiValue(env))
            guard status == napi_ok else { throw NAPI.Error(status) }
            return nil
        } catch is NAPI.Error {
            return nil
        } catch {
            fatalError("Failed to convert Swift Error into JS Error")
        }
    }
}

fileprivate func getUndefined(_ env: napi_env) throws -> napi_value {
    var result: napi_value?
    let status = napi_get_undefined(env, &result)
    guard status == napi_ok else { throw NAPI.Error(status) }
    return result!
}

fileprivate func getNull(_ env: napi_env) throws -> napi_value {
    var result: napi_value?
    let status = napi_get_null(env, &result)
    guard status == napi_ok else { throw NAPI.Error(status) }
    return result!
}

public enum Value: ValueConvertible {
    case `class`(Class)
    case function(Function)
    case object([String: Value])
    case array([Value])
    case string(String)
    case number(Double)
    case boolean(Bool)
    case null
    case undefined

    public init(_ env: napi_env, from: napi_value) throws {
        fatalError("Not implemented")
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        switch self {
            case .class(let `class`): return try `class`.napiValue(env)
            case .function(let function): return try function.napiValue(env)
            case .object(let object): return try object.napiValue(env)
            case .array(let array): return try array.napiValue(env)
            case .string(let string): return try string.napiValue(env)
            case .number(let number): return try number.napiValue(env)
            case .boolean(let boolean): return try boolean.napiValue(env)
            case .null: return try getNull(env)
            case .undefined: return try getUndefined(env)
        }
    }
}

extension Value: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let object = try? container.decode([String: Value].self) {
            self = .object(object)
        } else if let array = try? container.decode([Value].self) {
            self = .array(array)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let number = try? container.decode(Double.self) {
            self = .number(number)
        } else if let boolean = try? container.decode(Bool.self) {
            self = .boolean(boolean)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Failed to decode value"))
        }
    }
}
