#!/bin/bash

NUMBER=128
EXCITED_FOLDER=C
UNEXCITED_FOLDER=A
PRISTINE_BANDGAP_OUTCAR="../pristine/$NUMBER/A/OUTCAR"
OUTPUT_FOLDER="splitting_plot_$UNEXCITED_FOLDER-$EXCITED_FOLDER"

SPLITTING_OUTPUT_NAME=splitting.asy
LUMO_OUTPUT_NAME=lumos.asy
ABCD_OUTPUT_NAME=abcd.asy

#################
#  GET BANDGAP  #
#################

test -e $BANDGAP_OUTCAR || (echo -e "\033[0;91m$BANDGAP_OUTCAR file does not exist....\033[0m"; exit 1)

echo -e " \033[44mFetching pristine band gap information...\033[0m"
ENERGIE_VB_PRISTINE=$(show-me-your-electrons -g $PRISTINE_BANDGAP_OUTCAR | grep VB | cut -d " " -f 2)
ENERGIE_LB_PRISTINE=$(show-me-your-electrons -g $PRISTINE_BANDGAP_OUTCAR | grep LB | cut -d " " -f 2)
echo -e "Valence band: \t $ENERGIE_VB_PRISTINE"
echo -e "Conduction band: \t $ENERGIE_LB_PRISTINE"

EXCITED_OUTCAR=$EXCITED_FOLDER/OUTCAR
echo -e " \033[44mFetching excited band gap information...\033[0m"
ENERGIE_VB_EXCITED=$(show-me-your-electrons -g $EXCITED_OUTCAR | grep VB | cut -d " " -f 2)
echo -e "Valence band: \t $ENERGIE_VB_EXCITED"

UNEXCITED_OUTCAR=$UNEXCITED_FOLDER/OUTCAR
echo -e " \033[44mFetching excited band gap information...\033[0m"
ENERGIE_VB_UNEXCITED=$(show-me-your-electrons -g $UNEXCITED_OUTCAR | grep VB | cut -d " " -f 2)
echo -e "Valence band: \t $ENERGIE_VB_UNEXCITED"

#######################################################################
#                              SPLITTING                              #
#######################################################################

UNEXCITED_VALUE_x=$(d2E -u eV -f $UNEXCITED_OUTCAR | grep -E "^x" | cut -d ">" -f 2);
UNEXCITED_VALUE_y=$(d2E -u eV -f $UNEXCITED_OUTCAR | grep -E "^y" | cut -d ">" -f 2);
UNEXCITED_VALUE_z=$(d2E -u eV -f $UNEXCITED_OUTCAR | grep -E "^z" | cut -d ">" -f 2);

UNEXCITED_LABEL_x="\$x\$";
UNEXCITED_LABEL_y="\$y\$";
UNEXCITED_LABEL_z="\$z\$";

EXCITED_VALUE_x=$(d2E -u eV -f $EXCITED_OUTCAR | grep -E "^x" | cut -d ">" -f 2);
EXCITED_VALUE_y=$(d2E -u eV -f $EXCITED_OUTCAR | grep -E "^y" | cut -d ">" -f 2);
EXCITED_VALUE_z=$(d2E -u eV -f $EXCITED_OUTCAR | grep -E "^z" | cut -d ">" -f 2);

EXCITED_LABEL_x="\$x\$";
EXCITED_LABEL_y="\$y\$";
EXCITED_LABEL_z="\$z\$";


#######################################################################
#                                LUMOS                                #
#######################################################################

LUMO_TITLE="$UNEXCITED_FOLDER - $EXCITED_FOLDER for $NUMBER cell"

EXCITED_SPINS={$(show-me-your-electrons -n 4 $EXCITED_OUTCAR | cut -d " " -f1 | tr "\n" "," | sed -e "s/,$//" )}
EXCITED_ENERGIES={$(show-me-your-electrons -n 4 $EXCITED_OUTCAR | cut -d " " -f2 | tr "\n" "," | sed -e "s/,$//" )}

UNEXCITED_SPINS={$(show-me-your-electrons -n 4 $UNEXCITED_OUTCAR | cut -d " " -f1 | tr "\n" "," | sed -e "s/,$//" )}
UNEXCITED_ENERGIES={$(show-me-your-electrons -n 4 $UNEXCITED_OUTCAR | cut -d " " -f2 | tr "\n" "," | sed -e "s/,$//" )}


#######################################################################
#                                ABCD                                 #
#######################################################################

ABCD_TITLE="A-B-C-D $NUMBER";
A_ENERGIE=$(grep "free  energ" A/OUTCAR | cut -d "=" -f2 | tr -d "eV ");
B_ENERGIE=$(grep "free  energ" B/OUTCAR | cut -d "=" -f2 | tr -d "eV ");
C_ENERGIE=$(grep "free  energ" C/OUTCAR | cut -d "=" -f2 | tr -d "eV ");
D_ENERGIE=$(grep "free  energ" D/OUTCAR | cut -d "=" -f2 | tr -d "eV ");




#######################################################################
#                               SCRIPTS                               #
#######################################################################


test -d $OUTPUT_FOLDER || mkdir $OUTPUT_FOLDER

cat > $OUTPUT_FOLDER/Makefile <<EOF
all:
	asy -f pdf $SPLITTING_OUTPUT_NAME
	asy -f pdf $LUMO_OUTPUT_NAME
	asy -f pdf $ABCD_OUTPUT_NAME
EOF

