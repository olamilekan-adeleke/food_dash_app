const updateShopWallet = async  (docId, data) =>{
  return await admin
    .firestore()
    .collection("restaurants")
    .doc(docId)
    .update(data);
}


module.exports = updateShopWallet;