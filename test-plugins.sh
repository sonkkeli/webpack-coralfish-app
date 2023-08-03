# This script is used locally to run the tests of Webpack plugin.

# Set package versions as environment values from .versions file.
set -a
source .versions
set +a

# Remove old existing bundles.
rm -f ~/webpack-coralfish-app/static/*wbn &&

# Build underlying wbn package
cd ~/webpackage/js/bundle && rm -f *.tgz && npm i && npm run build && npm pack && 

# Build underlying wbn-sign package
cd ~/webpackage/js/sign && rm -f *.tgz && npm i && npm run build && npm pack && 

# Build the user app and override the underlying packages with my own.
cd ~/webbundle-plugins && npm i && npm run build && 
npm install --save ~/webpackage/js/bundle/wbn-$WBN_VERSION.tgz && 
npm install --save ~/webpackage/js/sign/wbn-sign-$WBN_SIGN_VERSION.tgz && 
npm run test