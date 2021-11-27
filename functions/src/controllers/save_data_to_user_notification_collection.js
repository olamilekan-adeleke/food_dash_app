const admin = require("./firebase_");

const saveDataToUserNotification = async (userId, docId, data) => {
  return await admin
    .firestore()
    .collection("users")
    .doc(userId)
    .collection("notifications")
    .doc(`${docId}`)
    .set(data);
};

module.exports = saveDataToUserNotification;