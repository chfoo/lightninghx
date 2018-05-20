#!/bin/dash

cd ../

echo Working directory: $PWD
DIR=$PWD

NAME=lightninghx
VERSION=$(python3 -c "import json
with open('haxelib.json') as file:
    print(json.load(file)['version'])
")
TIMESTAMP=$(date --utc +%Y%m%d-%H%M%S)

GIT_ZIP_DIR=out/release/temp-$TIMESTAMP-zips/
PACKING_DIR=out/release/temp-$TIMESTAMP-pack/

mkdir -p $GIT_ZIP_DIR $PACKING_DIR
git archive HEAD -o $GIT_ZIP_DIR/$NAME-$VERSION-$TIMESTAMP.zip

cd lib/lmdb/
git archive HEAD  -o ../../$GIT_ZIP_DIR/$NAME-$VERSION-$TIMESTAMP.lmdb.zip
cd ../../

unzip $GIT_ZIP_DIR/$NAME-$VERSION-$TIMESTAMP.zip -d $PACKING_DIR
unzip $GIT_ZIP_DIR/$NAME-$VERSION-$TIMESTAMP.lmdb.zip -d $PACKING_DIR/lib/lmdb/

cd $PACKING_DIR
zip $DIR/out/release/$NAME-$VERSION-$TIMESTAMP.zip -r .
cd $DIR

rm $GIT_ZIP_DIR -r
rm $PACKING_DIR -r

echo Done.
