#!/bin/bash

#########
#  CLI  #
#########

__SCRIPT_VERSION="0.0.1"; __SCRIPT_NAME=$( basename $0 ); __DESCRIPTION="Create asy plots.";
function usage_head() { echo "Usage :  $__SCRIPT_NAME [-h|-help] [-v|-version]"; }
function usage ()
{
cat <<EOF
$(usage_head)

    $__DESCRIPTION

    Options:
    -h|help       Display this message
    -v|version    Display script version"
    -o|output     Output folder


    This program is maintained by Alejandro Gallo.
EOF
}    # ----------  end of function usage  ----------

while getopts "hvo:" opt
do
  case $opt in

  h|help     )  usage; exit 0   ;;

  v|version  )  echo "$__SCRIPT_NAME -- Version $__SCRIPT_VERSION"; exit 0   ;;

  o|output  )   OUTPUT_FOLDER=$OPTARG ;;

  * )  echo -e "\n  Option does not exist : $OPTARG\n"
      usage_head; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

#####################
#  File parameters  #
#####################

SCRIPT_DIR=$(realpath $0 | xargs dirname)
NUMBER=$(basename $SCRIPT_DIR)
EXCITED_FOLDER=C
UNEXCITED_FOLDER=A
PRISTINE_BANDGAP_OUTCAR="../pristine/$NUMBER/A/OUTCAR"
[[ -z $OUTPUT_FOLDER ]] && OUTPUT_FOLDER="splitting_plot_$UNEXCITED_FOLDER-$EXCITED_FOLDER"

SPLITTING_OUTPUT_NAME=splitting.asy
LUMO_OUTPUT_NAME=lumos.asy
ABCD_OUTPUT_NAME=abcd.asy

#################
#  GET BANDGAP  #
#################

test -e $BANDGAP_OUTCAR || (echo -e "\033[0;91m$BANDGAP_OUTCAR file does not exist....\033[0m"; exit 1)

echo -e " \033[44mFetching pristine band gap information...\033[0m"
ENERGIE_VB_PRISTINE=$(smye -g $PRISTINE_BANDGAP_OUTCAR | grep VB | cut -d " " -f 2)
ENERGIE_LB_PRISTINE=$(smye -g $PRISTINE_BANDGAP_OUTCAR | grep LB | cut -d " " -f 2)
echo -e "Valence band: \t $ENERGIE_VB_PRISTINE"
echo -e "Conduction band: \t $ENERGIE_LB_PRISTINE"

EXCITED_OUTCAR=$EXCITED_FOLDER/OUTCAR
echo -e " \033[44mFetching excited band gap information...\033[0m"
ENERGIE_VB_EXCITED=$(smye -g $EXCITED_OUTCAR | grep VB | cut -d " " -f 2)
echo -e "Valence band: \t $ENERGIE_VB_EXCITED"

UNEXCITED_OUTCAR=$UNEXCITED_FOLDER/OUTCAR
echo -e " \033[44mFetching excited band gap information...\033[0m"
ENERGIE_VB_UNEXCITED=$(smye -g $UNEXCITED_OUTCAR | grep VB | cut -d " " -f 2)
echo -e "Valence band: \t $ENERGIE_VB_UNEXCITED"

#######################################################################
#                              SPLITTING                              #
#######################################################################

SPLITTING_TITLE="$NUMBER"

UNEXCITED_TITLE=$UNEXCITED_FOLDER

UNEXCITED_VALUE_x=$(d2E -u MHz -f $UNEXCITED_OUTCAR | grep -E "^x" | cut -d ">" -f 2);
UNEXCITED_VALUE_y=$(d2E -u MHz -f $UNEXCITED_OUTCAR | grep -E "^y" | cut -d ">" -f 2);
UNEXCITED_VALUE_z=$(d2E -u MHz -f $UNEXCITED_OUTCAR | grep -E "^z" | cut -d ">" -f 2);

UNEXCITED_LABEL_x="\$x\$";
UNEXCITED_LABEL_y="\$y\$";
UNEXCITED_LABEL_z="\$z\$";

EXCITED_TITLE=$EXCITED_FOLDER

EXCITED_VALUE_x=$(d2E -u MHz -f $EXCITED_OUTCAR | grep -E "^x" | cut -d ">" -f 2);
EXCITED_VALUE_y=$(d2E -u MHz -f $EXCITED_OUTCAR | grep -E "^y" | cut -d ">" -f 2);
EXCITED_VALUE_z=$(d2E -u MHz -f $EXCITED_OUTCAR | grep -E "^z" | cut -d ">" -f 2);

EXCITED_LABEL_x="\$x\$";
EXCITED_LABEL_y="\$y\$";
EXCITED_LABEL_z="\$z\$";


#######################################################################
#                                LUMOS                                #
#######################################################################

LUMO_TITLE="$UNEXCITED_FOLDER - $EXCITED_FOLDER for $NUMBER cell"

EXCITED_SPINS={$(smye $EXCITED_OUTCAR  -a 4 1 | cut -d " " -f1 | tr "\n" "," | sed -e "s/,$//" )}
EXCITED_ENERGIES={$(smye $EXCITED_OUTCAR  -a 4 1 | cut -d " " -f2 | tr "\n" "," | sed -e "s/,$//" )}
EXCITED_OCCUPATION={$(smye $EXCITED_OUTCAR  -a 4 1 | cut -d " " -f3 | tr "\n" "," | sed -e "s/,$//" )}
EXCITED_BANDS={$(smye $EXCITED_OUTCAR  -a 4 1 | cut -d " " -f4 | tr "\n" "," | sed -e "s/,$//" )}

UNEXCITED_SPINS={$(smye $UNEXCITED_OUTCAR  -a 4 1 | cut -d " " -f1 | tr "\n" "," | sed -e "s/,$//" )}
UNEXCITED_ENERGIES={$(smye $UNEXCITED_OUTCAR  -a 4 1 | cut -d " " -f2 | tr "\n" "," | sed -e "s/,$//" )}
UNEXCITED_OCCUPATION={$(smye $UNEXCITED_OUTCAR  -a 4 1 | cut -d " " -f3 | tr "\n" "," | sed -e "s/,$//" )}
UNEXCITED_BANDS={$(smye $UNEXCITED_OUTCAR  -a 4 1 | cut -d " " -f4 | tr "\n" "," | sed -e "s/,$//" )}


#######################################################################
#                                ABCD                                 #
#######################################################################

ABCD_TITLE="A-B-C-D $NUMBER";
A_ENERGIE=$(grep "free  energ" A/OUTCAR | tail -1 | cut -d "=" -f2 | tr -d "eV ");
B_ENERGIE=$(grep "free  energ" B/OUTCAR | tail -1 | cut -d "=" -f2 | tr -d "eV ");
C_ENERGIE=$(grep "free  energ" C/OUTCAR | tail -1 | cut -d "=" -f2 | tr -d "eV ");
D_ENERGIE=$(grep "free  energ" D/OUTCAR | tail -1 | cut -d "=" -f2 | tr -d "eV ");




#######################################################################
#                               SCRIPTS                               #
#######################################################################


test -d $OUTPUT_FOLDER || mkdir $OUTPUT_FOLDER

cat > $OUTPUT_FOLDER/Makefile <<EOF
all:
	@echo
	@echo "\t\t COMPILING $SPLITTING_OUTPUT_NAME"
	@echo
	-asy -f pdf $SPLITTING_OUTPUT_NAME
	@echo
	@echo "\t\t COMPILING $LUMO_OUTPUT_NAME"
	@echo
	-asy -f pdf $LUMO_OUTPUT_NAME
	@echo
	@echo "\t\t COMPILING $ABCD_OUTPUT_NAME"
	@echo
	-asy -f pdf $ABCD_OUTPUT_NAME
EOF
