const admin = require("../../firebase_");

const updateShopTotalNumberOfSales = async (docId, amount) => {
  const d = new Date();

  const day = d.getDate();
  const month = d.getMonth() + 1; // Since getMonth() returns month from 0-11 not 1-12
  const year = d.getFullYear();
  const _day = d.getDay();
  const weekOfMonth = Math.ceil((day - 1 - _day) / 7) + 1;

  return await admin
    .firestore()
    .collection("restaurants")
    .doc(docId)
    .collection("stat")
    .doc(year.toString())
    .collection("per_month_stat")
    .doc(month.toString())
    .set(
      {
        month_total_sales: admin.firestore.FieldValue.increment(1),
        [`week_${weekOfMonth}_total_sales`]:
          admin.firestore.FieldValue.increment(1),
        [`day_${day}_total_sales`]: admin.firestore.FieldValue.increment(1),

        // for amount sold
        month_total_amount: admin.firestore.FieldValue.increment(amount),
        [`week_${weekOfMonth}_total_amount`]:
          admin.firestore.FieldValue.increment(amount),
        [`day_${day}_total_amount`]:
          admin.firestore.FieldValue.increment(amount),
      },
      { merge: true }
    );
  // .update(data);
};

module.exports = updateShopTotalNumberOfSales;
