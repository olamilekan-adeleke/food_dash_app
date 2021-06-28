const faker = require("faker");
const admin = require("firebase-admin");
const serviceAccount = require('../src/key.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const firestoreDatabse = admin.firestore();

function log(message) {
    console.log(`FakeDataPoPulator | ${message}`);
}

async function generateFakeData() {
    log('generate fake data');

    await generateMerchant();

    log('generate fake data');
}


async function createMerchantDocument(merchant) {
    let documentRefeence = await firestoreDatabse.collection('food').add(merchant);
    return documentRefeence.id;
}

async function generateMerchant() {
    log('generating mutiple merchants...');

    for (let index = 0; index < 30; index++) {
        let merchant = {
            'name': faker.commerce.productName(),
            'image': faker.image.imageUrl(640, 640, 'food'),
            'categories': [
                faker.commerce.department(),
                faker.commerce.department(),
            ],
            'rating': faker.datatype.float(2),
            'number_of_ratings': faker.datatype.number(200),
        };

        log(`generating ${index} merchants...`);

        let merchantId = await createMerchantDocument(merchant);
        await generateMerchantProduct(merchantId);

    }
}

async function generateMerchantProduct(merchantId) {
    log(`generating mutiple product for ${merchantId}...`);

    for (let index = 0; index < 30; index++) {
        let product = {
            'name': faker.commerce.productName(),
            'description': faker.lorem.paragraph(2),
            'image': faker.image.imageUrl(640, 640, 'food'),
            'category': faker.commerce.department(),
            'price': faker.datatype.number(8999),

        };

        log(`generating ${index} product...`);

        await createMerchantProduct(merchantId, product);



    }
}


async function createMerchantProduct(merchantId, product) {
    await firestoreDatabse.collection('food').doc(merchantId)
        .collection('products').add(product);
}

generateFakeData();