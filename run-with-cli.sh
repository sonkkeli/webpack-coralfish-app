
export WBN_VERSION=0.0.9
export WBN_SIGN_VERSION=0.1.0

# Remove old existing bundles.
rm -f ~/webpack-coralfish-app/wbncli/*wbn &&

# Build underlying wbn package
cd ~/webpackage/js/bundle && rm -f ./wbn-$WBN_VERSION.tgz && \
npm i && npm run build && npm pack && 

# Build the user app and override the underlying wbn package with my own.
cd ~/webpack-coralfish-app && npm i && \
npm install --save ~/webpackage/js/bundle/wbn-$WBN_VERSION.tgz &&

# Run the CLI
wbn --dir wbncli \
    --output ./wbncli/out.wbn  \
    --formatVersion b2 \
    --baseURL https://example.com/ \
    --primaryURL https://example.com/ \
    --headerOverride ./header-overrides.json

# Sign the before-mentioned bundle.
cd ~/webpackage/js/sign && rm -f ./wbn-sign-$WBN_SIGN_VERSION.tgz && \
npm i && npm run build && npm pack && 

# Build the user app and override the underlying wbn package with my own.
cd ~/webpack-coralfish-app && npm i && \
npm install --save ~/webpackage/js/sign/wbn-sign-$WBN_SIGN_VERSION.tgz &&

# Run the CLI with unencrypted key
# wbn-sign -i ./wbncli/out.wbn -o ./wbncli/signed.swbn \
# -k ~/coralfish-dev-access/sign_keys/ed25519/private_key.pem

# To bypass the password prompting for the passphrase
# export WEB_BUNDLE_SIGNING_PASSPHRASE=helloworld

# Run the CLI with encrypted key
wbn-sign -i ./wbncli/out.wbn -o ./wbncli/signed.swbn \
-k file_enc.pem

# delete WEB_BUNDLE_SIGNING_PASSPHRASE