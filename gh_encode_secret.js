const sodium = require('libsodium-wrappers')

// 参考https://docs.github.com/zh/rest/actions/secrets?apiVersion=2022-11-28#get-an-organization-secret
// 参考https://docs.github.com/zh/rest/guides/encrypting-secrets-for-the-rest-api?apiVersion=2022-11-28
// 需运行npm install libsodium-wrappers。然后运行node gh_encode_secret.js
const key = process.argv[2]
const secret = process.argv[3]

//Check if libsodium is ready and then proceed.
sodium.ready.then(() => {
  // Convert the secret and key to a Uint8Array.
  let binkey = sodium.from_base64(key, sodium.base64_variants.ORIGINAL)
  let binsec = sodium.from_string(secret)

  // Encrypt the secret using libsodium
  let encBytes = sodium.crypto_box_seal(binsec, binkey)

  // Convert the encrypted Uint8Array to Base64
  let output = sodium.to_base64(encBytes, sodium.base64_variants.ORIGINAL)

  // Print the output
  console.log(output)
});

