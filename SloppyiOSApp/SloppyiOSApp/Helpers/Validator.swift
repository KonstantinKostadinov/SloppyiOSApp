//
//  Validator.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 7.08.21.
//

import Foundation

struct ValidationError: Error {
    var message: String

    init(_ message: String) {
        self.message = message
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
}

enum ValidatorType {
    case email
    case password
    case username
    case requiredField(field: String)
}

enum VaildatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .email: return EmailValidator()
        case .password: return PasswordValidator()
        case .username: return UserNameValidator()
        case .requiredField(let fieldName): return RequiredFieldValidator(fieldName)
        }
    }
}

struct RequiredFieldValidator: ValidatorConvertible {
    private let fieldName: String

    init(_ field: String) {
        fieldName = field
    }

    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else {
            throw ValidationError("Required field " + fieldName)
        }
        return value
    }
}

struct UserNameValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count >= 3 else {
            throw ValidationError("Username must contain more than three characters")
        }
        guard value.count < 18 else {
            throw ValidationError("Username shoudn't contain more than 18 characters")
        }

        do {
            if try NSRegularExpression(pattern: "^[a-z]{1,18}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Invalid username, username should not contain whitespaces, numbers or special characters")
            }
        } catch {
            throw ValidationError("Invalid username, username should not contain whitespaces, or special characters")
        }
        return value
    }
}

struct PasswordValidator: ValidatorConvertible {

    var errorMessage = "Invalid password"
    var requiredErrorMessage = "Password is Required"
    //Minimum 8 characters at least 1 Alphabet and 1 Number and optional special character:
    var regexValidation = "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,32}$"

    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError(self.requiredErrorMessage)}
        guard value.count >= 8 else { throw ValidationError(self.errorMessage) }

        do {
            if  try NSRegularExpression(pattern: self.regexValidation,  options: .anchorsMatchLines).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError(self.errorMessage)
            }
        } catch {
            throw ValidationError(self.errorMessage)
        }
        return value
    }
}

struct EmailValidator: ValidatorConvertible {
    let errorMessage = "Invalid e-mail Address"
    let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"

    func validated(_ value: String) throws -> String {
        do {
            if try NSRegularExpression(pattern: self.emailRegex, options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError(self.errorMessage)
            }
        } catch {
            throw ValidationError(self.errorMessage)
        }
        return value
    }
}
