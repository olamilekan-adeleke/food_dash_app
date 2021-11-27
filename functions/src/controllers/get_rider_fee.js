const admin = require("./firebase_");

const getRiderFee = async () => {
  return await admin.firestore().collection("constants").doc("rider_fee").get();
};

module.exports = getRiderFee;
