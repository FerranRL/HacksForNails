import SwiftUI
import UIKit
import CoreXLSX

struct ExcelUploaderView: UIViewControllerRepresentable {
    var onFilePicked: ([Dictionary<String, Any>]) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.spreadsheet])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        picker.shouldShowFileExtensions = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: ExcelUploaderView

        init(_ parent: ExcelUploaderView) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            guard url.startAccessingSecurityScopedResource() else {
                print("No se pudo acceder al recurso de forma segura.")
                return
            }
                        
            defer {
                // Asegúrate de detener el acceso cuando termines
                url.stopAccessingSecurityScopedResource()
            }
            
            do {
                let fileData = try Data(contentsOf: url)
                let spreadsheet = try XLSXFile(data: fileData)
                let sharedStrings = try spreadsheet.parseSharedStrings()// Cargar los shared strings
                
                var extractedData = [Dictionary<String, Any>]()
                
                for wbk in try spreadsheet.parseWorkbooks() {
                    for (_, path) in try spreadsheet.parseWorksheetPathsAndNames(workbook: wbk) {
                        let worksheet = try spreadsheet.parseWorksheet(at: path)
                        
                        // Iterar sobre las filas a partir de la segunda fila (índice 1)
                        for (index, row) in (worksheet.data?.rows ?? []).enumerated() {
                            // Comienza desde la fila 2 (índice 1)
                            guard index >= 1 else { continue }
                            
                            var item = [String: Any]()
                            
                            // Acceder a la columna B (índice 1) usando shared strings
                            if let cell = row.cells[safe: 1], let tratamientoValue = cell.stringValue(sharedStrings!) {
                                item["tratamiento"] = tratamientoValue
                            } else {
                                item["tratamiento"] = "Campo vacío" // Mensaje en caso de celda vacía
                            }
                            
                            // Leer y convertir el valor de la columna de precio
                            if let precioValue = row.cells[safe: 2]?.value,
                               let precio = Double(precioValue) {
                                item["precio"] = precio
                            } else {
                                item["precio"] = 0.0
                            }
                            
                            // Leer y convertir el valor de la columna de duración
                            if let duracionValue = row.cells[safe: 3]?.value,
                               let duracion = Int(duracionValue) {
                                item["duracion"] = duracion
                            } else {
                                item["duracion"] = 0
                            }
                            
                            // Leer la columna de descripción, manejar celdas vacías
                            item["descripcion"] = row.cells[safe: 4]?.value ?? ""
                            extractedData.append(item)
                        }
                    }
                }
                
                // Filtrar los documentos para eliminar aquellos con "Campo vacío" en el campo "tratamiento"
                let filteredData = extractedData.filter { item in
                    guard let tratamiento = item["tratamiento"] as? String else { return false }
                    return tratamiento != "Campo vacío"
                }
                
                parent.onFilePicked(filteredData)
                
            } catch {
                print("Error al leer el archivo Excel: \(error.localizedDescription)")
            }
        }
    }
}

// Extensión para acceder a elementos de forma segura en arreglos
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
