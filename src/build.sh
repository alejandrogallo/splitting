#!/bin/bash

TEMPLATE="template-script.sh"
BUILD_NAME="../build/create_splitting.sh";
ASY_FILE="splitting.asy"
ASY_TMP=".tmp.$ASY_FILE"

test -f $ASY_TMP && rm $ASY_TMP

#strip the real values and lables
sed -e "s/\(real\) \(ENERGIE_.B_.*\).*=\(.*\)/\1 \2 = \$\2;/" -e "s/\(real\) \(.*EXC.*_.*\)=\(.*\);/\1 \2=\$\2;/" -e 's/\(string\) \(.*EXC.*_.*\) =\s\{0,1\}\(".*"\)/\1 \2 = "$\2"/' $ASY_FILE >> $ASY_TMP



cat $TEMPLATE >> $BUILD_NAME
echo 'cat > $OUTPUT_FOLDER/$OUTPUT_NAME <<EOF' >> $BUILD_NAME
cat $ASY_TMP >> $BUILD_NAME
echo 'EOF' >> $BUILD_NAME

rm $ASY_TMP
