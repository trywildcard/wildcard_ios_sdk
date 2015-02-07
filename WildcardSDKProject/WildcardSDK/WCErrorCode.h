//
//  WCErrorCodes.h
//  WildcardSDKProject
//
//  Created by David Xiang on 2/5/15.
//
//

typedef NS_ENUM(NSInteger, WCErrorCode) {
    WCErrorCodeUnknown = -1,
    WCErrorCodeMalformedResponse = 0,
    WCErrorCodeUninitializedAPIKey = 1,
    WCErrorCodePermissionDenied = 2,
    WCErrorCodeBadRequest = 3,
    WCErrorCodeNotImplemented = 4,
    WCErrorCodeInternalServerError = 5,
    WCErrorCodeCardDeserializationError = 6,
    WCErrorCodeMalformedRequest = 7
};



