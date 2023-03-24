const WebBundlePlugin = require('webbundle-webpack-plugin');
const { WebBundleId, parsePemKey, readPassphrase } = require('wbn-sign');
require('dotenv').config({ path: './.env' });

const path = require('path');

module.exports = async () => {
  // const key = parsePemKey(process.env.ED25519KEY);
  const key = parsePemKey(process.env.ENC_ED25519KEY, await readPassphrase());

  return {
    entry: './src/index.js',
    output: {
      filename: 'webpack-bundle.js',
      path: path.resolve(__dirname, 'static'),
    },
    plugins: [
      new WebBundlePlugin({
        baseURL: new WebBundleId(key).serializeWithIsolatedWebAppOrigin(),
        static: { dir: path.resolve(__dirname, 'static') },
        output: 'webpack.swbn',
        integrityBlockSign: { key },
        headerOverride: () => {
          return {
            'access-control-allow-headers':
              'Cross-Origin-Embedder-Policy, Cross-Origin-Opener-Policy, Cross-Origin-Resource-Policy',
            'cross-origin-opener-policy': 'same-origin;report-to="coop"',
            'cross-origin-embedder-policy': 'require-corp;report-to="coep"',
            'cross-origin-resource-policy': 'same-origin',
            helloworld: 'helloworld',
            // 'content-type': 'text/html'
          };
        },
      }),
    ],
  };
};
