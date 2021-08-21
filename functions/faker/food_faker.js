// /* eslint-disable valid-jsdoc */

// const faker = require("faker");
// const admin = require("firebase-admin");
// const uuid = require("uuid");
// const serviceAccount = require("../src/key.json");

// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
// });

// const firestoreDatabse = admin.firestore();

// function log(message) {
//   console.log(`FakeDataPoPulator | ${message}`);
// }

// async function generateFakeData() {
//   log("generate fake data");

//   await generateMerchant();

//   log("generate fake data");
// }

// async function createMerchantDocument(merchant) {
//   const documentRefeence = await firestoreDatabse
//     .collection("restaurants")
//     .doc(merchant.id)
//     .set(merchant);
//   return documentRefeence.id;
// }

// async function generateMerchant() {
//   log("generating mutiple merchants...");

//   for (let index = 0; index < 30; index++) {
//     const merchantName = faker.commerce.productName();
//     const merchantId = uuid.v4();

//     const merchant = {
//       id: merchantId,
//       name: merchantName,
//       image: faker.image.imageUrl(640, 640, "food"),
//       categories: [faker.commerce.department(), faker.commerce.department()],
//       rating: faker.datatype.float(2),
//       number_of_ratings: faker.datatype.number(200),
//     };

//     log(`generating ${index} merchants...`);

//     await createMerchantDocument(merchant);
//     await generateMerchantProduct(merchantId, merchantName);
//   }
// }

// async function generateMerchantProduct(merchantId, marchantName) {
//   log(`generating mutiple product for ${merchantId}...`);

//   for (let index = 0; index < 30; index++) {
//     const productName = faker.commerce.productName();
//     const productId = uuid.v4();

//     let searchKey = [];
//     let currentSearchKey = "";

//     productName.split("").forEach((element) => {
//       currentSearchKey += element.toLowerCase();
//       searchKey.push(currentSearchKey);
//     });

//     const product = {
//       name: productName,
//       id: productId,
//       search_key: searchKey,
//       description: faker.lorem.paragraph(2),
//       image: faker.image.imageUrl(640, 640, "food"),
//       category: faker.commerce.department(),
//       price: faker.datatype.number(8999),
//       fast_food_name: marchantName,
//       fast_food_id: merchantId,
//       likes_count: 1,
//     };

//     log(`generating ${index} product...`);

//     await createMerchantProduct(product);
//   }
// }

// async function createMerchantProduct(product) {
//   await firestoreDatabse.collection("food_items").doc(product.id).set(product);
// }

// // generateFakeData();
