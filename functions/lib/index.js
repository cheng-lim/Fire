"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const functions = require("firebase-functions");
// import {onSchedule} from "firebase-functions/v2/scheduler";
const express = require("express");
const cors = require("cors");
// import {initializeApp} from "firebase/app";
// import {log} from "firebase-functions/logger";
// import {getFirestore, collection, orderBy, query, doc, getDocs, deleteDoc,
//     DocumentData, Timestamp, serverTimestamp} from "firebase/firestore";
// const firebaseConfig = {
//   apiKey: "AIzaSyCNz3xEreW_oIeInhwGPXjnIu2RUc4I_lc",
//   authDomain: "fire-dev-c0fa6.firebaseapp.com",
//   projectId: "fire-dev-c0fa6",
//   storageBucket: "fire-dev-c0fa6.appspot.com",
//   messagingSenderId: "249852645281",
//   appId: "1:249852645281:web:8aaa026726fd29e32745e0",
//   measurementId: "G-C8FQSB5HVF"
// };
// Initialize Firebase
// const firebase = initializeApp(firebaseConfig);
// const storage = getStorage();
// const db = getFirestore(firebase);
const app = express();
const corsOptions = {
    origin: ["https://api.fire.com", "https://fire.com", "https://www.fire.com", "http://127.0.0.1:5001/fire-dev-c0fa6/us-central1/app"],
};
app.use(cors(corsOptions));
app.get("/", (req, res) => {
    res.send("Welcome to the Fire Dev page!");
});
exports.app = functions.https.onRequest(app);
// exports.test2Cron = onSchedule("every 1 days", () =>{
//   log("test2Cron starts");
//   log("test2Cron ends");
// });
//# sourceMappingURL=index.js.map