# This script is used locally to build eeeeeverything, with webpack.

# Set package versions as environment values from .versions file.
set -a
source .versions
set +a

# Remove old existing bundles.
rm -f ~/webpack-coralfish-app/static/*wbn &&

# Build underlying wbn package
cd ~/webpackage/js/bundle && rm -f ./wbn-$WBN_VERSION.tgz && npm i && npm run build && npm pack && 

# Build underlying wbn-sign package
cd ~/webpackage/js/sign && rm -f ./wbn-sign-$WBN_SIGN_VERSION.tgz && npm i && npm run build && npm pack && 

# Build underlying webbundle-webpack-plugin package
cd ~/webbundle-plugins && rm -f ./webbundle-plugins/webbundle-webpack-plugin-$WEBPACK_PLUGIN_VERSION.tgz && npm i && npm run pack && 

# Build the user app and override the underlying packages with my own.
cd ~/webpack-coralfish-app && npm i && 
npm install --save ~/webpackage/js/bundle/wbn-$WBN_VERSION.tgz && 
npm install --save ~/webpackage/js/sign/wbn-sign-$WBN_SIGN_VERSION.tgz && 
npm install --save ~/webbundle-plugins/webbundle-webpack-plugin-$WEBPACK_PLUGIN_VERSION.tgz && 
webpack