import NAPIC

public struct Undefined: ValueConvertible {
    public static let `default` = Undefined()

    private init() {}
    public init(_ env: napi_env, from: napi_value) throws {}

    public func napiValue(_ env: napi_env) throws -> napi_value {
        var result: napi_value?

        let status = napi_get_undefined(env, &result)
        guard status == napi_ok else { throw NAPI.Error(status) }

        return result!
    }
}

extension Undefined: CustomStringConvertible {
    public var description: String {
        return "undefined"
    }
}

extension Undefined: Equatable {
    public static func ==(_: Undefined, _: Undefined) -> Bool {
        return true
    }
}
