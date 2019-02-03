import NAPIC
import Foundation

fileprivate enum InternalPropertyDescriptor {
    case method(String, Callback, napi_property_attributes)
    case value(String, ValueConvertible, napi_property_attributes)
}

public struct PropertyDescriptor {
    fileprivate let value: InternalPropertyDescriptor

    fileprivate init(_ value: InternalPropertyDescriptor) {
        self.value = value
    }

    func value(_ env: napi_env) throws -> napi_property_descriptor {
        switch self.value {
            case .method(let name, let callback, let attributes):
                let _name = try name.napiValue(env)
                let data = CallbackData(callback: callback)
                let dataPointer = Unmanaged.passRetained(data).toOpaque()
                return napi_property_descriptor(utf8name: nil, name: _name, method: swiftNAPICallback, getter: nil, setter: nil, value: nil, attributes: attributes, data: dataPointer)
            case .value(let name, let value, let attributes):
                let _name = try name.napiValue(env)
                let _value = try value.napiValue(env)
                return napi_property_descriptor(utf8name: nil, name: _name, method: nil, getter: nil, setter: nil, value: _value, attributes: attributes, data: nil)
        }
    }

    public static func value(_ name: String, _ value: ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return .init(.value(name, value, attributes))
    }

    public static func `class`<This: AnyObject>(_ name: String, _ constructor: @escaping () throws -> This, _ properties: [PropertyDescriptor], attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return .init(.value(name, Class(named: name, { (env, argv, this) in let native = try constructor(); try Wrap<This>.wrap(env, jsObject: this, nativeObject: native); return nil }, properties), attributes))
    }

    /* (...) -> Void */

    public static func function(_ name: String, _ callback: @escaping () throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return .init(.method(name, { (_, _, _) in try callback(); return Value.undefined }, attributes))
    }

    public static func function<A: ValueConvertible>(_ name: String, _ callback: @escaping (A) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return .init(.method(name, { (env, argv, _) in try callback(A(env, from: argv[0])); return Value.undefined }, attributes))
    }

    public static func function<A: ValueConvertible, B: ValueConvertible>(_ name: String, _ callback: @escaping (A, B) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return .init(.method(name, { (env, argv, _) in try callback(A(env, from: argv[0]), B(env, from: argv[1])); return Value.undefined }, attributes))
    }

    /* (...) -> ValueConvertible */

    public static func function(_ name: String, _ callback: @escaping () throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return .init(.method(name, { (_, _, _) in return try callback() }, attributes))
    }

    public static func function<A: ValueConvertible>(_ name: String, _ callback: @escaping (A) throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return .init(.method(name, { (env, argv, _) in return try callback(A(env, from: argv[0])) }, attributes))
    }

    public static func function<A: ValueConvertible, B: ValueConvertible>(_ name: String, _ callback: @escaping (A, B) throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return .init(.method(name, { (env, argv, _) in return try callback(A(env, from: argv[0]), B(env, from: argv[1])) }, attributes))
    }

    /* (this, ...) -> Void */

    public static func method<This: AnyObject>(_ name: String, _ callback: @escaping (This) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return .init(.method(name, { (env, _, this) in try callback(Wrap<This>.unwrap(env, jsObject: this)); return Value.undefined }, attributes))
    }

    public static func method<This: AnyObject, A: ValueConvertible>(_ name: String, _ callback: @escaping (This, A) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return .init(.method(name, { (env, argv, this) in try callback(Wrap<This>.unwrap(env, jsObject: this), A(env, from: argv[0])); return Value.undefined }, attributes))
    }

    public static func method<This: AnyObject, A: ValueConvertible, B: ValueConvertible>(_ name: String, _ callback: @escaping (This, A, B) throws -> Void, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return .init(.method(name, { (env, argv, this) in try callback(Wrap<This>.unwrap(env, jsObject: this), A(env, from: argv[0]), B(env, from: argv[1])); return Value.undefined }, attributes))
    }

    /* (this, ...) -> ValueConvertible */

    public static func method<This: AnyObject>(_ name: String, _ callback: @escaping (This) throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return .init(.method(name, { (env, _, this) in return try callback(Wrap<This>.unwrap(env, jsObject: this)) }, attributes))
    }

    public static func method<This: AnyObject, A: ValueConvertible>(_ name: String, _ callback: @escaping (This, A) throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return .init(.method(name, { (env, argv, this) in return try callback(Wrap<This>.unwrap(env, jsObject: this), A(env, from: argv[0])) }, attributes))
    }

    public static func method<This: AnyObject, A: ValueConvertible, B: ValueConvertible>(_ name: String, _ callback: @escaping (This, A, B) throws -> ValueConvertible, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return .init(.method(name, { (env, argv, this) in return try callback(Wrap<This>.unwrap(env, jsObject: this), A(env, from: argv[0]), B(env, from: argv[1])) }, attributes))
    }
}
