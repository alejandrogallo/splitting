#!/bin/bash

################
#  PARAMETERS  #
################

TEMPLATE="template-script.sh"
BUILD_NAME="../build/create_splitting.sh";

SPLITTING_FILE="splitting.asy"
SPLITTING_TMP=".tmp.$SPLITTING_FILE"

LUMO_FILE="lumos.asy"
LUMO_TMP=".tmp.$LUMO_FILE"

ABCD_FILE="abcd.asy"
ABCD_TMP=".tmp.$ABCD_FILE"

RESOURCES_FILE="resources.asy"

######################
#  TEMPLATE DUMPING  #
######################
cat $TEMPLATE > $BUILD_NAME

#######################
#  RESOURCES DUMPING  #
#######################

echo 'cat > $OUTPUT_FOLDER/$RESOURCES_FILE <<EOF' >> $BUILD_NAME
cat $RESOURCES_FILE >> $BUILD_NAME
echo 'EOF' >> $BUILD_NAME


#######################
#  SPLITTING DUMPING  #
#######################

test -f $SPLITTING_TMP && rm $SPLITTING_TMP

#strip the real values and lables
sed '
s/\(string\) \(.*_TITLE\).*=.*\(".*"\)/\1 \2 = "$\2"/
s/\(real\) \(.*EXC.*_.*\)=\(.*\);/\1 \2=\$\2;/
s/\(string\) \(.*LABEL.*\)=\(.*\)/\1 \2 = "$\2";/' $SPLITTING_FILE >> $SPLITTING_TMP

echo 'cat > $OUTPUT_FOLDER/$SPLITTING_OUTPUT_NAME <<EOF' >> $BUILD_NAME
cat $SPLITTING_TMP >> $BUILD_NAME
echo 'EOF' >> $BUILD_NAME

rm $SPLITTING_TMP



##################
#  LUMO DUMPING  #
##################

test -f $LUMO_TMP && rm $LUMO_TMP

sed '
s/\(string\) \(LUMO_TITLE\).*=.*\(".*"\)/\1 \2 = "$\2"/
s/\(real\) \(ENERGIE_.B_.*\).*=\(.*\)/\1 \2 = \$\2;/
s/\(real\[\]\) \(.*EXC.*_.*\)=\(.*\);/\1 \2=\$\2;/'  $LUMO_FILE >> $LUMO_TMP

echo 'cat > $OUTPUT_FOLDER/$LUMO_OUTPUT_NAME <<EOF' >> $BUILD_NAME
cat $LUMO_TMP >> $BUILD_NAME
echo 'EOF' >> $BUILD_NAME

rm $LUMO_TMP


##################
#  ABCD DUMPING  #
##################

test -f $ABCD_TMP && rm $ABCD_TMP

sed '
s/\(string\) \(ABCD_TITLE\).*=.*\(".*"\)/\1 \2 = "$\2"/
s/\(real\) \(._ENERGIE\).*=\(.*\)/\1 \2 = \$\2;/'  $ABCD_FILE >> $ABCD_TMP

echo 'cat > $OUTPUT_FOLDER/$ABCD_OUTPUT_NAME <<EOF' >> $BUILD_NAME
cat $ABCD_TMP >> $BUILD_NAME
echo 'EOF' >> $BUILD_NAME

rm $ABCD_TMP
