export WBN_FILENAME_IN=testfile.wbn
export WBN_FILENAME_OUT=testfile.swbn
export BASE_URL=isolated-app://4tkrnsmftl4ggvvdkfth3piainqragus2qbhf7rlz2a3wo3rh4wqaaic/

rm -f ~/webpack-coralfish-app/wbn-golang/*wbn && \

cd ~/webpackage/go/bundle/cmd/gen-bundle && 
go build && ./gen-bundle -dir ~/webpack-coralfish-app/static -baseURL $BASE_URL -o ~/webpack-coralfish-app/wbn-golang/$WBN_FILENAME_IN && cd ~/webpackage/go/bundle/cmd/sign-bundle && 
go build && ./sign-bundle integrity-block -privateKey ~/webpack-coralfish-app/file_enc.pem -i ~/webpack-coralfish-app/wbn-golang/$WBN_FILENAME_IN -o ~/webpack-coralfish-app/wbn-golang/$WBN_FILENAME_OUT

# To run tests:
# cd ~/webpackage/go/bundle && go test ./...  