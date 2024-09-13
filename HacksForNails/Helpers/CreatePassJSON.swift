//
//  CreatePassJSON.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 13/9/24.
//

import Foundation

func createPassJSON(stamps: Int, nextAppointment: String) -> Data? {
    let passData: [String: Any] = [
        "formatVersion": 1,
        "passTypeIdentifier": "com.paretsdesign.hacksfornails",
        "serialNumber": "1234567890",
        "teamIdentifier": "H86KV5J4UN",
        "barcode": [
          "message": "1234567890",
          "format": "PKBarcodeFormatQR",
          "messageEncoding": "iso-8859-1"
        ],
        "organizationName": "Beauty Hacks",
        "description": "Tarjeta Cliente",
        "logoText": "H A C K S",
        "foregroundColor": "rgb(255, 255, 255)",
        "backgroundColor": "rgb(0, 0, 0)",
        "generic": [
            "primaryFields": [
                [
                    "key": "stamps",
                    "label": "Sellos Acumulados",
                    "value": "\(stamps)"
                ]
            ],
            "secondaryFields": [
                [
                    "key": "nextAppointment",
                    "label": "Próxima Cita",
                    "value": nextAppointment
                ]
            ]
        ]
    ]
    
    // Convierte el diccionario en JSON data
    return try? JSONSerialization.data(withJSONObject: passData, options: [])
}

