const admin = require("../../firebase_");

const updateRiderWallet = async (riderId, amount) => {
  return await admin
    .firestore()
    .collection("rider")
    .doc(riderId)
    .update({ wallet_balance: admin.firestore.FieldValue.increment(amount) });
};

module.exports = updateRiderWallet;
