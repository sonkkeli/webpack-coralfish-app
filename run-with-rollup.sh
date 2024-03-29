#!/bin/bash

# This script is used locally to build eeeeeverything, with Rollup.

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

# Build underlying rollup-plugin-webbundle package
cd ~/webbundle-plugins && rm -f ./webbundle-plugins/rollup-plugin-webbundle-$ROLLUP_PLUGIN_VERSION.tgz && npm i && npm run pack && 

# Build the user app and override the underlying packages with my own.
cd ~/webpack-coralfish-app && npm i && 
npm install --save ~/webpackage/js/bundle/wbn-$WBN_VERSION.tgz && 
npm install --save ~/webpackage/js/sign/wbn-sign-$WBN_SIGN_VERSION.tgz && 
npm install --save ~/webbundle-plugins/rollup-plugin-webbundle-$ROLLUP_PLUGIN_VERSION.tgz && 
rollup -c
