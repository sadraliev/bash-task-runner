#!/bin/bash

#If command given run the command on VM, if its a local scirpt file, transfer the script to VM then excecute 
# ./action.sh --runs-on REMOTE_USER@REMOTE_IP --step "echo Hello World"
#scp $FILE $REMOTE_USER@$REMOTE_IP:/tmp 

#START
#steps=()
# while $# > 0
#   case $1
#       --runs_on) 
#           REMOTE_HOST="$2"
#           shift
#       --step) 
#           steps+=$2
#   esac
# for step in STEPS;
#   if the command is scripts
#   scp #scp $FILE $REMOTE_USER@$REMOTE_IP:/~
#   ssh root@ipadress script
#   else
#
#   ssh root@ipadress command
# END



REMOTE_USER="root"
REMOTE_IP="68.183.145.114"

STEPS=()
while [[ $# -gt 0 ]]; do 
    case "$1" in 
        --runs-on)
            REMOTE_HOST=$2
            echo $REMOTE_HOST
            shift 2
        ;;
        --step)
            STEPS+=("$2")
            shift 2
        ;;

    esac
done
echo "${STEPS[@]}"

for step in "${STEPS[@]}"; do 
    
    if [ -f $step ]; then
        echo "this is a file"
        scp $step $REMOTE_USER@$REMOTE_IP:/tmp
        ssh $REMOTE_USER@$REMOTE_IP "chmod +x /tmp/$(basename $step)"
        echo "sucesfully teleported file"
        #ssh -t $REMOTE_USER@$REMOTE_IP "bash /tmp/$(basename $step)"
        echo "ran the scipt"

    else 
        echo " its not a file"
        eval $step
        
    fi
done
