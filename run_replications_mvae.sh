#!/bin/bash

mkdir replications_mvae
cd replications_mvae

for i in "4e" "5e" "3e" "2e" "1e"
do
    echo "run $i "
    mkdir run_$i
    cd run_$i
    ln -s ../../matlab ./

    python ../../train_final_completeloss.py 1 $i
    cd ../
    cp -a "/content/HU_MML_Seminar_Zambelli2019_RAS_multimodal_VAE/replications_mvae" "/content/drive/My Drive/mml/data"
done

