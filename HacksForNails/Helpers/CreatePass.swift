//
//  CreatePass.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 13/9/24.
//

import SwiftUI
import PassKit
import CryptoKit

func createAndAddWalletPass(stamps: Int, nextAppointment: String) {
    // 1. Crear pass.json dinámicamente
    guard let passJSON = createPassJSON(stamps: stamps, nextAppointment: nextAppointment) else {
        print("Error al crear pass.json")
        return
    }
    
    // 2. Cargar imágenes necesarias
    guard let iconData = loadImageData(imageName: "icon"),
          let logoData = loadImageData(imageName: "logo") else {
        print("Error al cargar imágenes")
        return
    }

    // 3. Crear el manifest con los hashes de los archivos
    let manifest = [
        "pass.json": sha1Hash(data: passJSON),
        "icon.png": sha1Hash(data: iconData),
        "logo.png": sha1Hash(data: logoData)
    ]
    
    guard let manifestData = try? JSONSerialization.data(withJSONObject: manifest, options: []) else {
        print("Error al crear manifest.json")
        return
    }
    
    // 4. Enviar manifest al servidor para firmar y obtener la signature
    signManifestOnServer(manifestData: manifestData) { signature in
        guard let signature = signature else {
            print("Error al firmar el manifest en el servidor")
            return
        }
        
        // 5. Crear y empaquetar el archivo .pkpass
        let passPackage = createPassPackage(passJSON: passJSON, manifestData: manifestData, signature: signature, images: ["icon.png": iconData, "logo.png": logoData])
        
        // 6. Presentar el pase en Wallet
        presentPassToWallet(passPackage: passPackage)
    }
}

func sha1Hash(data: Data) -> String {
    // Generar el hash SHA-1 para el manifest.json
    // Usado para firmar los datos y generar el archivo final
    return data.base64EncodedString() 
}

func signManifestOnServer(manifestData: Data, completion: @escaping (Data?) -> Void) {
    // Enviar el manifest al servidor para que firme y devuelva la firma
    // Implementa la llamada a tu servidor que firmará el manifest.json
    completion(nil) // Simulación, debe reemplazarse con la llamada real al servidor
}

func createPassPackage(passJSON: Data, manifestData: Data, signature: Data, images: [String: Data]) -> Data {
    // Empaquetar todos los archivos en un archivo .pkpass usando zip
    var passFiles: [String: Data] = [
        "pass.json": passJSON,
        "manifest.json": manifestData,
        "signature": signature
    ]
    
    for (fileName, data) in images {
        passFiles[fileName] = data
    }
    
    // Implementación de la creación del archivo .pkpass (usando zip o librerías de compresión)
    return Data() // Placeholder para la creación del archivo .pkpass
}

func presentPassToWallet(passPackage: Data) {
    do {
        let pass = try PKPass(data: passPackage)
        let addPassesViewController = PKAddPassesViewController(pass: pass)
        
        // Presentar el controlador de agregar pase
        if let addPassesViewController = addPassesViewController {
            UIApplication.shared.windows.first?.rootViewController?.present(addPassesViewController, animated: true, completion: nil)
        }
    } catch {
        print("Error al presentar el pase: \(error.localizedDescription)")
    }
}

func loadImageData(imageName: String) -> Data? {
    // Cargar imagen desde los recursos de la aplicación
    guard let image = UIImage(named: imageName), let imageData = image.pngData() else {
        return nil
    }
    return imageData
}

