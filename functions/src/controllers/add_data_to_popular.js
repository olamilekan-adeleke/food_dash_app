const admin = require("../../firebase_");

const addDataToPopular = async (docId, data) => {
  return await admin
    .firestore()
    .collection("food_items")
    .doc(docId)
    .update(data);
};


module.exports = addDataToPopular;