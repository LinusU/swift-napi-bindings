import NAPIC

public enum Error: Swift.Error {
    case invalidArg
    case objectExpected
    case stringExpected
    case nameExpected
    case functionExpected
    case numberExpected
    case booleanExpected
    case arrayExpected
    case genericFailure
    case pendingException
    case cancelled
    case escapeCalledTwice
    case handleScopeMismatch
    case callbackScopeMismatch
    case queueFull
    case closing
    case bigintExpected

    case unknown(UInt32)

    public init(_ napiStatus: napi_status) {
        switch napiStatus.rawValue {
        case 1: self = .invalidArg
        case 2: self = .objectExpected
        case 3: self = .stringExpected
        case 4: self = .nameExpected
        case 5: self = .functionExpected
        case 6: self = .numberExpected
        case 7: self = .booleanExpected
        case 8: self = .arrayExpected
        case 9: self = .genericFailure
        case 10: self = .pendingException
        case 11: self = .cancelled
        case 12: self = .escapeCalledTwice
        case 13: self = .handleScopeMismatch
        case 14: self = .callbackScopeMismatch
        case 15: self = .queueFull
        case 16: self = .closing
        case 17: self = .bigintExpected
        default: self = .unknown(napiStatus.rawValue)
        }
    }
}

extension Error {
    func napi_throw(_ env: napi_env) -> napi_status {
        switch self {
        case .objectExpected: return napi_throw_type_error(env, nil, "Expected object")
        case .stringExpected: return napi_throw_type_error(env, nil, "Expected string")
        case .nameExpected: return napi_throw_type_error(env, nil, "Expected Symbol or string")
        case .functionExpected: return napi_throw_type_error(env, nil, "Expected function")
        case .numberExpected: return napi_throw_type_error(env, nil, "Expected number")
        case .booleanExpected: return napi_throw_type_error(env, nil, "Expected boolean")
        case .arrayExpected: return napi_throw_type_error(env, nil, "Expected array")
        case .bigintExpected: return napi_throw_type_error(env, nil, "Expected BigInt")
        default: return napi_throw_error(env, nil, self.localizedDescription)
        }
    }
}
