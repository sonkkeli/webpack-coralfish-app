import webbundle from 'rollup-plugin-webbundle';
// import * as wbnSign from 'wbn-sign';
import crypto from 'crypto';
import dotenv from 'dotenv';
dotenv.config({ path: './.env' });

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

export default async () => {
  // const key = wbnSign.parsePemKey(process.env.ED25519KEY);

  // const key = wbnSign.parsePemKey(
  //   process.env.ENC_ED25519KEY,
  //   await wbnSign.readPassphrase()
  // );

  return {
    input: 'src/index.js',
    output: {
      dir: 'static',
      format: 'cjs',
    },
    plugins: [
      webbundle({
        // baseURL: new wbnSign.WebBundleId(
        //   key
        // ).serializeWithIsolatedWebAppOrigin(),
        static: { dir: 'static' },
        output: 'rollup.swbn',
        integrityBlockSign: { strategy: new CustomSigningStrategy() },
        headerOverride: {
          helloworld: 'hello',
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

/**
 * Sidenote: The file must be named with .mjs extension. Otherwise it will throw below error:
 * [!] Error: While loading the Rollup configuration from "rollup.config.js",
 * Node tried to require an ES module from a CommonJS file, which is not supported.
 * A common cause is if there is a package.json file with "type": "module" in the same folder.
 * You can try to fix this by changing the extension of your configuration file to
 * ".cjs" or ".mjs" depending on the content, which will prevent Rollup from trying to
 * preprocess the file but rather hand it to Node directly.
 *
 * Also node v.12 doesnt support modules, so 13+ only works.
 */
