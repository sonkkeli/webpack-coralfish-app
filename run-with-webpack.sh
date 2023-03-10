# This script is used locally to build eeeeeverything, with webpack.

export WEBPACK_VERSION=0.0.4
export WBN_VERSION=0.0.8
export WBN_SIGN_VERSION=0.0.1

# Remove old existing bundles.
rm -f ~/webpack-coralfish-app/static/*wbn &&

# Build underlying wbn package
cd ~/webpackage/js/bundle && rm -f ./wbn-$WBN_VERSION.tgz && npm i && npm run build && npm pack && 

# Build underlying wbn-sign package
cd ~/webpackage/js/sign && rm -f ./wbn-sign-$WBN_SIGN_VERSION.tgz && npm i && npm run build && npm pack && 

# Build underlying webbundle-webpack-plugin package
cd ~/webbundle-webpack-plugin && rm -f ./webbundle-webpack-plugin-$WEBPACK_VERSION.tgz && npm i && npm pack && 

# Build the user app and override the underlying packages with my own.
cd ~/webpack-coralfish-app && npm i && 
npm install --save ~/webpackage/js/bundle/wbn-$WBN_VERSION.tgz && 
npm install --save ~/webpackage/js/sign/wbn-sign-$WBN_SIGN_VERSION.tgz && 
npm install --save ~/webbundle-webpack-plugin/webbundle-webpack-plugin-$WEBPACK_VERSION.tgz && 
webpack