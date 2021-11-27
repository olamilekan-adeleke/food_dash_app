const admin = require("./firebase_");

const incrementTotalOrderAmountCount = async amount => {
  const d = new Date();

  const day = d.getDate(); // Day		[dd]	(1 - 31)
  const month = d.getMonth() + 1; // Month	[mm]	(1 - 12)
  const year = d.getFullYear(); // Year		[yyyy]

  return await admin
    .firestore()
    .collection("constants")
    .doc("metrics")
    .collection(`${year.toString()}`)
    .doc(`${month.toString()}`)
    .collection("days")
    .doc(`${day.toString()}`)
    .set(
      {
        total_amount: admin.firestore.FieldValue.increment(amount),
      },
      { merge: true }
    );
};


module.exports = incrementTotalOrderAmountCount;