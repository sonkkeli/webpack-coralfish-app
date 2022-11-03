const WebBundlePlugin = require('webbundle-webpack-plugin');
const { WebBundleId, parsePemKey } = require('wbn-sign');
require('dotenv').config({ path: './.env' });

const path = require('path');

module.exports = {
  entry: './src/index.js',
  output: {
    filename: 'webpack-bundle.js',
    path: path.resolve(__dirname, 'static'),
  },
  plugins: [
    new WebBundlePlugin({
      baseURL: new WebBundleId(
        parsePemKey(process.env.ED25519KEY)
      ).serializeWithIsolatedWebAppOrigin(),
      static: { dir: path.resolve(__dirname, 'static') },
      output: 'webpack.wbn',
      integrityBlockSign: {
        key: process.env.ED25519KEY,
      },
    }),
  ],
};
