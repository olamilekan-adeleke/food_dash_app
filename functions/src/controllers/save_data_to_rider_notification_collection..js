const admin = require("./firebase_");

const saveDataToRiderNotification = async (riderId, docId, data) => {
  return await admin
    .firestore()
    .collection("rider")
    .doc(riderId)
    .collection("notifications")
    .doc(`${docId}`)
    .set(data);
};

module.exports = saveDataToRiderNotification;