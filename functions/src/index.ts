import functions = require("firebase-functions");
// import {onSchedule} from "firebase-functions/v2/scheduler";
import express = require("express");
import cors = require("cors");
// import {initializeApp} from "firebase/app";
// import {log} from "firebase-functions/logger";
// import {getFirestore, collection, orderBy, query, doc, getDocs, deleteDoc,
//     DocumentData, Timestamp, serverTimestamp} from "firebase/firestore";

// Initialize Firebase
// const firebase = initializeApp(firebaseConfig);
// const storage = getStorage();
// const db = getFirestore(firebase);

const app = express();
const corsOptions = {
  origin: ["https://api.fire.com", "https://fire.com", "https://www.fire.com", "http://127.0.0.1:5001/fire-dev-c0fa6/us-central1/app"],
};
app.use(cors(corsOptions));

app.get("/", (req, res)=>{
  res.send("Welcome to the Fire Dev page!");
});

exports.app = functions.https.onRequest(app);

// exports.test2Cron = onSchedule("every 1 days", () =>{
//   log("test2Cron starts");
//   log("test2Cron ends");
// });
