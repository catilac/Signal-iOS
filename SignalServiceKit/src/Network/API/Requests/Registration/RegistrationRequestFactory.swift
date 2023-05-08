//
// Copyright 2023 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

public enum RegistrationRequestFactory {

    // MARK: - Session API

    /// See `RegistrationServiceResponses.BeginSessionResponseCodes` for possible responses.
    public static func beginSessionRequest(
        e164: E164,
        pushToken: String?,
        mcc: String?,
        mnc: String?
    ) -> TSRequest {
        let urlPathComponents = URLPathComponents(
            ["v1", "verification", "session"]
        )
        var urlComponents = URLComponents()
        urlComponents.percentEncodedPath = urlPathComponents.percentEncoded
        let url = urlComponents.url!

        var parameters: [String: Any] = [
            "number": e164.stringValue
        ]
        if let pushToken {
            owsAssertDebug(!pushToken.isEmpty)
            parameters["pushToken"] = pushToken
            parameters["pushTokenType"] = "apn"
        }
        if let mcc {
            parameters["mcc"] = mcc
        }
        if let mnc {
            parameters["mnc"] = mnc
        }

        let result = TSRequest(url: url, method: "POST", parameters: parameters)
        result.shouldHaveAuthorizationHeaders = false
        return result
    }

    /// See `RegistrationServiceResponses.FetchSessionResponseCodes` for possible responses.
    public static func fetchSessionRequest(
        sessionId: String
    ) -> TSRequest {
        owsAssertDebug(sessionId.isEmpty.negated)

        let urlPathComponents = URLPathComponents(
            ["v1", "verification", "session", sessionId]
        )
        var urlComponents = URLComponents()
        urlComponents.percentEncodedPath = urlPathComponents.percentEncoded
        let url = urlComponents.url!

        let result = TSRequest(url: url, method: "GET", parameters: nil)
        result.shouldHaveAuthorizationHeaders = false
        redactSessionIdFromLogs(sessionId, in: result)
        return result
    }

    /// See `RegistrationServiceResponses.FulfillChallengeResponseCodes` for possible responses.
    /// TODO[Registration]: this can also take an APNS token to resend a push challenge. Push token challenges
    /// are  best-effort, but as an optimization we may want to do that.
    public static func fulfillChallengeRequest(
        sessionId: String,
        captchaToken: String?,
        pushChallengeToken: String?
    ) -> TSRequest {
        owsAssertDebug(sessionId.isEmpty.negated)
        owsAssertDebug(!captchaToken.isEmptyOrNil || !pushChallengeToken.isEmptyOrNil)

        let urlPathComponents = URLPathComponents(
            ["v1", "verification", "session", sessionId]
        )
        var urlComponents = URLComponents()
        urlComponents.percentEncodedPath = urlPathComponents.percentEncoded
        let url = urlComponents.url!

        var parameters: [String: Any] = [:]
        if let captchaToken {
            parameters["captcha"] = captchaToken
        }
        if let pushChallengeToken {
            parameters["pushChallenge"] = pushChallengeToken
        }

        let result = TSRequest(url: url, method: "PATCH", parameters: parameters)
        result.shouldHaveAuthorizationHeaders = false
        redactSessionIdFromLogs(sessionId, in: result)
        return result
    }

    public enum VerificationCodeTransport: String {
        case sms
        case voice
    }

    /// See `RegistrationServiceResponses.RequestVerificationCodeResponseCodes` for possible responses.
    ///
    /// - parameter languageCode: Language in which the client prefers to receive SMS or voice verification messages
    ///       If nil, english is used.
    /// - parameter countryCode: If provided, combined with language code.
    public static func requestVerificationCodeRequest(
        sessionId: String,
        languageCode: String?,
        countryCode: String?,
        transport: VerificationCodeTransport
    ) -> TSRequest {
        owsAssertDebug(sessionId.isEmpty.negated)

        let urlPathComponents = URLPathComponents(
            ["v1", "verification", "session", sessionId, "code"]
        )
        var urlComponents = URLComponents()
        urlComponents.percentEncodedPath = urlPathComponents.percentEncoded
        let url = urlComponents.url!

        let parameters: [String: Any] = [
            "transport": transport.rawValue,
            "client": "ios"
        ]

        var languageCodes = [String]()
        if let languageCode {
            if let countryCode {
                languageCodes.append("\(languageCode)-\(countryCode)")
            }
            languageCodes.append(languageCode)
        }
        if languageCodes.contains("en").negated {
            languageCodes.append("en")
        }

        let languageHeader: String = OWSHttpHeaders.formatAcceptLanguageHeader(languageCodes)

        let result = TSRequest(url: url, method: "POST", parameters: parameters)
        result.shouldHaveAuthorizationHeaders = false
        result.setValue(languageHeader, forHTTPHeaderField: OWSHttpHeaders.acceptLanguageHeaderKey)
        redactSessionIdFromLogs(sessionId, in: result)
        return result
    }

    /// See `RegistrationServiceResponses.SubmitVerificationCodeResponseCodes` for possible responses.
    public static func submitVerificationCodeRequest(
        sessionId: String,
        code: String
    ) -> TSRequest {
        owsAssertDebug(sessionId.isEmpty.negated)
        owsAssertDebug(code.isEmpty.negated)

        let urlPathComponents = URLPathComponents(
            ["v1", "verification", "session", sessionId, "code"]
        )
        var urlComponents = URLComponents()
        urlComponents.percentEncodedPath = urlPathComponents.percentEncoded
        let url = urlComponents.url!

        let parameters: [String: Any] = [
            "code": code
        ]

        let result = TSRequest(url: url, method: "PUT", parameters: parameters)
        result.shouldHaveAuthorizationHeaders = false
        redactSessionIdFromLogs(sessionId, in: result)
        return result
    }

    // MARK: - KBS Auth Check

    public static func kbsAuthCredentialCheckRequest(
        e164: E164,
        credentials: [KBSAuthCredential]
    ) -> TSRequest {
        owsAssertDebug(!credentials.isEmpty)

        let urlPathComponents = URLPathComponents(
            ["v1", "backup", "auth", "check"]
        )
        var urlComponents = URLComponents()
        urlComponents.percentEncodedPath = urlPathComponents.percentEncoded
        let url = urlComponents.url!

        let parameters: [String: Any] = [
            "number": e164.stringValue,
            "passwords": credentials.map {
                "\($0.username):\($0.credential.password)"
            }
        ]

        let result = TSRequest(url: url, method: "POST", parameters: parameters)
        result.shouldHaveAuthorizationHeaders = false
        return result
    }

    // MARK: - Account Creation/Change Number

    public enum VerificationMethod {
        /// The ID of an existing, validated RegistrationSession.
        case sessionId(String)
        /// Base64 encoded registration recovery password (derived from KBS master secret).
        case recoveryPassword(String)
    }

    /// Create an account, or re-register if one exists.
    ///
    /// - parameter verificationMethod: A way to verify phone number and account ownership.
    /// - parameter e164: The phone number being registered for.
    /// - parameter accountAttributes: Attributes for the account, same as those in
    ///   `updatePrimaryDeviceAttributesRequest`.
    /// - parameter skipDeviceTransfer: If true, indicates that the end user has elected
    ///   not to transfer data from another device even though a device transfer is technically possible
    ///   given the capabilities of the calling device and the device associated with the existing account (if any).
    ///   If false and if a device transfer is technically possible, the registration request will fail with an HTTP/409
    ///   response indicating that the client should prompt the user to transfer data from an existing device.
    public static func createAccountRequest(
        verificationMethod: VerificationMethod,
        e164: E164,
        authPassword: String,
        accountAttributes: AccountAttributes,
        skipDeviceTransfer: Bool
    ) -> TSRequest {
        let urlPathComponents = URLPathComponents(
            ["v1", "registration"]
        )
        var urlComponents = URLComponents()
        urlComponents.percentEncodedPath = urlPathComponents.percentEncoded
        let url = urlComponents.url!

        let accountAttributesData = try! JSONEncoder().encode(accountAttributes)
        let accountAttributesDict = try! JSONSerialization.jsonObject(with: accountAttributesData, options: .fragmentsAllowed) as! [String: Any]

        var parameters: [String: Any] = [
            "accountAttributes": accountAttributesDict,
            "skipDeviceTransfer": skipDeviceTransfer
        ]
        switch verificationMethod {
        case .sessionId(let sessionId):
            parameters["sessionId"] = sessionId
        case .recoveryPassword(let recoveryPassword):
            parameters["recoveryPassword"] = recoveryPassword
        }

        let result = TSRequest(url: url, method: "POST", parameters: parameters)
        result.shouldHaveAuthorizationHeaders = true
        result.addValue("OWI", forHTTPHeaderField: "X-Signal-Agent")
        // As odd as this is, it is to spec.
        result.authUsername = e164.stringValue
        result.authPassword = authPassword
        return result
    }

    /// Update the phone number on an account.
    ///
    /// - parameter verificationMethod: A way to verify phone number and account ownership.
    /// - parameter e164: The phone number to change to.
    /// - parameter reglockToken: If reglock is enabled, required to succeed. Derived from the
    ///   kbs master key.
    /// - parameter pniChangeNumberParameters: pni related params used to inform
    ///   linked device of the change number and rotated pni keys.
    public static func changeNumberRequest(
        verificationMethod: VerificationMethod,
        e164: E164,
        reglockToken: String?,
        pniChangeNumberParameters: ChangePhoneNumberPni.Parameters
    ) -> TSRequest {
        let urlPathComponents = URLPathComponents(
            ["v2", "accounts", "number"]
        )
        var urlComponents = URLComponents()
        urlComponents.percentEncodedPath = urlPathComponents.percentEncoded
        let url = urlComponents.url!

        var parameters: [String: Any] = [
            "number": e164.stringValue
        ]
        switch verificationMethod {
        case .sessionId(let sessionId):
            parameters["sessionId"] = sessionId
        case .recoveryPassword(let recoveryPassword):
            parameters["recoveryPassword"] = recoveryPassword
        }
        if let reglockToken {
            parameters["reglock"] = reglockToken
        }

        parameters["pniIdentityKey"] = pniChangeNumberParameters.pniIdentityKey.prependKeyType().base64EncodedString()
        parameters["devicePniSignedPrekeys"] = pniChangeNumberParameters.devicePniSignedPreKeys.mapValues {
            OWSRequestFactory.signedPreKeyRequestParameters($0)
        }
        parameters["deviceMessages"] = pniChangeNumberParameters.deviceMessages.map { $0.requestParameters() }
        parameters["pniRegistrationIds"] = pniChangeNumberParameters.pniRegistrationIds

        let result = TSRequest(url: url, method: "PUT", parameters: parameters)
        result.shouldHaveAuthorizationHeaders = true
        return result
    }

    public static func updatePrimaryDeviceAccountAttributesRequest(
        _ accountAttributes: AccountAttributes,
        auth: ChatServiceAuth
    ) -> TSRequest {
        let urlPathComponents = URLPathComponents(
            ["v1", "accounts", "attributes"]
        )
        var urlComponents = URLComponents()
        urlComponents.percentEncodedPath = urlPathComponents.percentEncoded
        let url = urlComponents.url!

        // The request expects the AccountAttributes to be the root object.
        // Serialize it to JSON then get the key value dict to do that.
        let data = try! JSONEncoder().encode(accountAttributes)
        let parameters = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as! [String: Any]

        let result = TSRequest(url: url, method: "PUT", parameters: parameters)
        result.shouldHaveAuthorizationHeaders = true
        result.setAuth(auth)
        return result
    }

    /// See `RegistrationServiceResponses.FetchSessionResponseCodes` for possible responses.
    public static func checkProxyConnectionRequest() -> TSRequest {
        // What we _want_ is an way to check that we get a response from the server. Because
        // this is used during registration, we don't have auth credentials yet so we need to do this
        // in an unauthenticated way.
        // In an ideal future, we could do this by establishing an unauthenticated websocket that
        // we use for registration purposes. We don't use websockets during reg right now.
        // Instead, we use a REST endpoint to get registration session metadata, which we feed a
        // bogus session id and expect to get a 4xx response. Getting a 4xx means we connected; that's
        // all we care about. (A 2xx too, is fine, though would be quite unusual)
        return fetchSessionRequest(sessionId: UUID().data.base64EncodedString())
    }

    // MARK: - Helpers

    private static func redactSessionIdFromLogs(_ sessionId: String, in request: TSRequest) {
        request.applyRedactionStrategy(.redactURLForSuccessResponses(
            replacementString: request.url?.absoluteString.replacingOccurrences(of: sessionId, with: "[REDACTED]") ?? "[REDACTED]"
        ))
    }
}
