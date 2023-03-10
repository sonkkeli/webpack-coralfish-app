#!/bin/bash

# This script is used locally to build eeeeeverything, with rollup.

export ROLLUP_VERSION=0.0.4
export WBN_VERSION=0.0.8
export WBN_SIGN_VERSION=0.0.1

# Remove old existing bundles.
rm -f ~/webpack-coralfish-app/static/*wbn &&

# Build underlying wbn package
cd ~/webpackage/js/bundle && rm -f ./wbn-$WBN_VERSION.tgz && npm i && npm run build && npm pack && 

# Build underlying wbn-sign package
cd ~/webpackage/js/sign && rm -f ./wbn-sign-$WBN_SIGN_VERSION.tgz && npm i && npm run build && npm pack && 

# Build underlying rollup-plugin-webbundle package
cd ~/rollup-plugin-webbundle && rm -f ./rollup-plugin-webbundle-$ROLLUP_VERSION.tgz && npm i && npm pack && 

# Build the user app and override the underlying packages with my own.
cd ~/webpack-coralfish-app && npm i && 
npm install --save ~/webpackage/js/bundle/wbn-$WBN_VERSION.tgz && 
npm install --save ~/webpackage/js/sign/wbn-sign-$WBN_SIGN_VERSION.tgz && 
npm install --save ~/rollup-plugin-webbundle/rollup-plugin-webbundle-$ROLLUP_VERSION.tgz && 
rollup -c
