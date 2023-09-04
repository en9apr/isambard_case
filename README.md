# Enter the non-commented commands into the terminal:

## Creates local variable
export OPENFOAM_VN=v2306

## Unloads cray module
module unload PrgEnv-cray    

# Loads gnu module
module load PrgEnv-gnu      

# cd to correct installation location    
cd $HOME/OpenFOAM

# or if $HOME/OpenFOAM does not exist:
mkdir -p $HOME/OpenFOAM
cd $HOME/OpenFOAM

# downloads OpenFOAM, decompresses and changes directory - nothing is done with ThirdParty
wget https://dl.openfoam.com/source/$OPENFOAM_VN/OpenFOAM-$OPENFOAM_VN.tgz              
tar -zxvf OpenFOAM-$OPENFOAM_VN.tgz  
wget https://dl.openfoam.com/source/$OPENFOAM_VN/ThirdParty-$OPENFOAM_VN.tgz
tar -zxvf ThirdParty-$OPENFOAM_VN.tgz  
                                                   
cd OpenFOAM-$OPENFOAM_VN/                                                                

# This creates a new file pref.sh
cat > ./etc/prefs.sh << EOF                  
export WM_COMPILER_TYPE=system
export WM_COMPILER=Gcc
export WM_MPLIB=CRAY-MPICH
EOF

# replaces mpi with mpich
sed -i 's/-lmpi/-lmpich/g' ./wmake/rules/General/mplibMPICH

# sources bashrc
source ./etc/bashrc

# shortcut
foam

# check if installation possible
foamSystemCheck

# builds OpenFOAM (takes about 30 minutes on the login node)
./Allwmake -j -s -q -l

# Check locations
foamInstallationTest

# Put this is in $HOME/.bashrc (activate with of2306 if running from terminal):
alias of2306='module unload PrgEnv-cray; module load PrgEnv-gnu; export OPENFOAM_DIR=$HOME/OpenFOAM/OpenFOAM-v2306; export PATH=$PATH:$OPENFOAM_DIR/bin/; source $OPENFOAM_DIR/etc/bashrc; export PS1="(LOCAL OF:\$WM_PROJECT_VERSION) $PS1"'

# Reload the .bashrc or logout and login again
source $HOME/.bashrc

# Activate installation (showing the version) - only needed if running from terminal
of2306

# Create a user folder (with your username) and change to the folder
mkdir -p $HOME/OpenFOAM/ex-aroberts-v2306/run
run

# Download example
git clone https://github.com/en9apr/isambard_case
cd isambard_case

# Adjust isambard.sh for your own username
OPENFOAM_DIR=/home/ex-aroberts/OpenFOAM/OpenFOAM-v2306

# Submit to queue
qsub isambard.sh


