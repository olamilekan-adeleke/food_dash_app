const admin = require("./firebase_");

const incrementTotalOrderCount = async () => {
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
        total_order: admin.firestore.FieldValue.increment(1),
      },
      { merge: true }
    );
};


module.exports = incrementTotalOrderCount;