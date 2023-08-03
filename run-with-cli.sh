# Set package versions as environment values from .versions file.
set -a
source .versions
set +a

# Remove old existing bundles.
rm -f ~/webpack-coralfish-app/wbncli/*wbn &&

# Build wbn package
cd ~/webpackage/js/bundle && rm -f ./wbn-$WBN_VERSION.tgz && \
npm i && npm run build && npm pack && 

# Build wbn-sign package
cd ~/webpackage/js/sign && rm -f ./wbn-sign-$WBN_SIGN_VERSION.tgz && \
npm i && npm run build && npm pack && 

# Build the user app and override the underlying wbn package with my own.
cd ~/webpack-coralfish-app && npm i && \
npm install --save ~/webpackage/js/bundle/wbn-$WBN_VERSION.tgz &&
npm install --save ~/webpackage/js/sign/wbn-sign-$WBN_SIGN_VERSION.tgz &&

# To bypass the password prompting for the passphrase
export WEB_BUNDLE_SIGNING_PASSPHRASE=helloworld

# Dump the Web bundle ID and save into an environment variable
export DUMP_WEB_BUNDLE_ID="$(wbn-dump-id -k file_enc.pem -s)"

# Dump the Web bundle ID and save into a file
# wbn-dump-id -k file_enc.pem -s > webbundleid.txt

# Generate web bundle
wbn --dir wbncli \
    --output ./wbncli/out.wbn \
    --formatVersion b2 \
    --headerOverride ./header-overrides.json \
    --baseURL $DUMP_WEB_BUNDLE_ID

## Sign the before-mentioned web bundle

# With unencrypted key
# wbn-sign -i ./wbncli/out.wbn -o ./wbncli/signed.swbn -k file.pem

# With encrypted key
wbn-sign -i ./wbncli/out.wbn -o ./wbncli/signed.swbn -k file_enc.pem
