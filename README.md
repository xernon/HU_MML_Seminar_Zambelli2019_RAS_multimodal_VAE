# Zambelli2019_RAS_multimodal_VAE
Code and dataset for the RAS accepted paper "Multimodal representation models for prediction and control from partial information"


This repository contains the codebase and the dataset used to generate results for the paper.

Python 3.7
Tensorflow 1.15
Matplotlib

Structure:
train_final_completeloss seems to be the main file, functionality for changing modality numbers seems to be semi-implemented, remains a bit of parameter adjusting
functions to look at: create_network and network_param 
network_param keeps different network configurations (basically edit here) and the train...py is run with train...py *network id, no quotes*
if we make a different network architecture, we might need to change the dataset to not have the modality
and adjust the create_network function, the 5 modalities are hardcoded there, didnt find other hardcoded places
training the model takes a lot on my pc, might need to run for a day or so, maybe something remote running would be nice, or i try to use my laptop for it
