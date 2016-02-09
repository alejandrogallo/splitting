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


######################
#  TEMPLATE DUMPING  #
######################
cat $TEMPLATE >> $BUILD_NAME

#######################
#  SPLITTING DUMPING  #
#######################

test -f $SPLITTING_TMP && rm $SPLITTING_TMP

#strip the real values and lables
sed -e "s/\(real\) \(ENERGIE_.B_.*\).*=\(.*\)/\1 \2 = \$\2;/" -e "s/\(real\) \(.*EXC.*_.*\)=\(.*\);/\1 \2=\$\2;/" -e 's/\(string\) \(.*EXC.*_.*\) =\s\{0,1\}\(".*"\)/\1 \2 = "$\2"/' $SPLITTING_FILE >> $SPLITTING_TMP
echo 'cat > $OUTPUT_FOLDER/$SPLITTING_OUTPUT_NAME <<EOF' >> $BUILD_NAME
cat $SPLITTING_TMP >> $BUILD_NAME
echo 'EOF' >> $BUILD_NAME

rm $SPLITTING_TMP



##################
#  LUMO DUMPING  #
##################

test -f $LUMO_TMP && rm $LUMO_TMP


sed -e "s/\(real\) \(ENERGIE_.B_.*\).*=\(.*\)/\1 \2 = \$\2;/" -e "s/\(real\[\]\) \(.*EXC.*_.*\)=\(.*\);/\1 \2=\$\2;/"  $LUMO_FILE >> $LUMO_TMP
echo 'cat > $OUTPUT_FOLDER/$LUMO_OUTPUT_NAME <<EOF' >> $BUILD_NAME
cat $LUMO_TMP >> $BUILD_NAME
echo 'EOF' >> $BUILD_NAME


rm $LUMO_TMP
