const WebBundlePlugin = require('webbundle-webpack-plugin');
const { WebBundleId, parsePemKey, readPassphrase } = require('wbn-sign');
require('dotenv').config({ path: './.env' });

const path = require('path');

module.exports = () => {
  const key = parsePemKey(process.env.ENC_ED25519KEY, readPassphrase());

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
      }),
    ],
  };
};
