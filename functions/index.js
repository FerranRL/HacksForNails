/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// index.js en Firebase Functions
const functions = require("firebase-functions");
const express = require("express");
const multer = require("multer");
const openssl = require("openssl-nodejs");
const path = require("path");
const fs = require("fs");

const app = express();
const upload = multer({ storage: multer.memoryStorage() });

// Ruta para firmar el manifest.json
app.post("/sign", upload.single("manifest"), (req, res) => {
  // Ruta a los certificados (estos deben estar en el servidor de manera segura)
  const certPath = path.join(__dirname, "certificates", "certificado.p12"); // Certificado de pase
  const wwdrPath = path.join(__dirname, "certificates", "AppleWWDRCAG3.pem"); // Certificado WWDR
  
  // Archivo manifest recibido
  const manifestPath = path.join(__dirname, "manifest.json");
  fs.writeFileSync(manifestPath, req.file.buffer);

  // Ruta para guardar la firma
  const signaturePath = path.join(__dirname, "signature.sig");

  // Comando OpenSSL para firmar el manifest
  const command = [
    "smime",
    "-binary",
    "-sign",
    "-certfile",
    wwdrPath,
    "-signer",
    certPath,
    "-inkey",
    certPath,
    "-in",
    manifestPath,
    "-out",
    signaturePath,
    "-outform",
    "DER",
    "-passin",
    "pass:PASSWORD", // Sustituye PASSWORD con la contraseña de tu .p12
  ];

  // Ejecuta el comando OpenSSL
  openssl(command, (err, buffer) => {
    if (err) {
      console.error("Error al firmar:", err);
      res.status(500).send("Error al firmar el manifest");
      return;
    }

    // Devuelve la firma al cliente
    res.sendFile(signaturePath);
  });
});

// Exporta la función como un endpoint HTTP
exports.api = functions.https.onRequest(app);