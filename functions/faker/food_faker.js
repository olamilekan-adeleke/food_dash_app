/* eslint-disable valid-jsdoc */

const faker = require("faker");
const admin = require("firebase-admin");
const serviceAccount = require("../src/key.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const firestoreDatabse = admin.firestore();

function log(message) {
  console.log(`FakeDataPoPulator | ${message}`);
}

async function generateFakeData() {
  log("generate fake data");

  await generateMerchant();

  log("generate fake data");
}

async function createMerchantDocument(merchant) {
  const documentRefeence = await firestoreDatabse
    .collection("restaurants")
    .add(merchant);
  return documentRefeence.id;
}

async function generateMerchant() {
  log("generating mutiple merchants...");

  for (let index = 0; index < 30; index++) {
    const merchantName = faker.commerce.productName();

    const merchant = {
      name: merchantName,
      image: faker.image.imageUrl(640, 640, "food"),
      categories: [faker.commerce.department(), faker.commerce.department()],
      rating: faker.datatype.float(2),
      number_of_ratings: faker.datatype.number(200),
    };

    log(`generating ${index} merchants...`);

    const merchantId = await createMerchantDocument(merchant);
    await generateMerchantProduct(merchantId, merchantName);
  }
}

async function generateMerchantProduct(merchantId, marchantName) {
  log(`generating mutiple product for ${merchantId}...`);

  for (let index = 0; index < 30; index++) {
    const product = {
      name: faker.commerce.productName(),
      description: faker.lorem.paragraph(2),
      image: faker.image.imageUrl(640, 640, "food"),
      category: faker.commerce.department(),
      price: faker.datatype.number(8999),
      fast_food_name: marchantName,
        fast_food_id: merchantId,
      likes_count: 1,
    };

    log(`generating ${index} product...`);

    await createMerchantProduct( product);
  }
}

async function createMerchantProduct( product) {
  await firestoreDatabse
    .collection("food_items")
    .add(product);
}

generateFakeData();
