const WebBundlePlugin = require('webbundle-webpack-plugin');
// const {
//   NodeCryptoSigningStrategy,
//   WebBundleId,
//   parsePemKey,
//   ISigningStrategy,
//   readPassphrase,
// } = require('wbn-sign');
// const fs = require('fs');
const crypto = require('crypto');
require('dotenv').config({ path: './.env' });
const path = require('path');

const toHexString = (bytes) => {
  return Array.from(bytes, (byte) => {
    return ('0' + (byte & 0xff).toString(16)).slice(-2);
  }).join('');
};

class CustomSigningStrategy {
  async sign(data) {
    let response = await fetch('https://silly-signer-service.glitch.me/sign/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: toHexString(data),
    });
    return Buffer.from(await response.text(), 'hex');
  }

  async getPublicKey() {
    let response = await fetch(
      'https://silly-signer-service.glitch.me/publickey/'
    );
    return crypto.createPublicKey({
      type: 'spki',
      format: 'der',
      key: await response.text(),
      encoding: 'hex',
    });
  }
}

module.exports = async () => {
  // const key = parsePemKey(process.env.ED25519KEY);
  // const key = parsePemKey(process.env.ENC_ED25519KEY, await readPassphrase());

  return {
    entry: './src/index.js',
    output: {
      filename: 'webpack-bundle.js',
      path: path.resolve(__dirname, 'static'),
    },
    plugins: [
      new WebBundlePlugin({
        // baseURL: new WebBundleId(key).serializeWithIsolatedWebAppOrigin(),
        static: { dir: path.resolve(__dirname, 'static') },
        output: 'webpack.swbn',
        // integrityBlockSign: {
        //   key,
        //   // isIwa: true,
        // },
        // integrityBlockSign: {
        //   strategy: new NodeCryptoSigningStrategy(key),
        // },
        integrityBlockSign: {
          strategy: new CustomSigningStrategy(),
        },
        headerOverride: {
          'cross-origin-embedder-policy': 'require-corp',
          'cross-origin-opener-policy': 'same-origin',
          'cross-origin-resource-policy': 'same-origin',
          'content-security-policy':
            "base-uri 'none'; default-src 'self'; object-src 'none'; frame-src 'self' https:; connect-src 'self' https:; script-src 'self' 'wasm-unsafe-eval'; img-src 'self' https: blob: data:; media-src 'self' https: blob: data:; font-src 'self' blob: data:; require-trusted-types-for 'script';",
        },
      }),
    ],
  };
};
