import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    router.post(IfuRequest.self, at: "ifu") { req, ifuRequest -> IfuResponse in
        
        guard let appVariant = AppVariant(rawValue: ifuRequest.appVariant) else {
            throw Abort(.badRequest, reason: "Unknown appVariant (\(ifuRequest.appVariant)).")
        }
        
        guard let xblehiid = Data(base64Encoded: ifuRequest.xblehiid) else {
            throw Abort(.badRequest, reason: "Failed to decode base64 payload (xblehiid).")
        }
        
        return IfuResponse(path: "BIMS: \(xblehiid) \(appVariant) \(ifuRequest.modelName) languageCode: \(ifuRequest.languageCode); regionCode: \(ifuRequest.regionCode)")
    }
}

enum AppVariant: String {
    case oticon
    case bernafon
    case sonic
    case kind
    case oem
    case philips
}

struct IfuRequest: Content {
    let appVariant: String   // oticon, bernafon, sonic, kind, oem, philips
    
    let modelName: String    // Device Information Service Model Number String
    let xblehiid: String     // Base64 encoded
    
    let languageCode: String // ISO 639-1
    let regionCode: String   // ISO 3166-2
}

struct IfuResponse: Content {
    let path: String
}
