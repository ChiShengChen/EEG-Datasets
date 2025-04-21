#!/bin/bash

# Script: Download and prepare required EEG datasets
echo "Download EEGPT..."
wget --content-disposition "https://figshare.com/ndownloader/articles/25866970?folder_path=EEGPT&private_link=e37df4f8a907a866df4b"


echo "Creating dataset root directories..."
mkdir -p datasets/pretrain
mkdir -p datasets/downstream

# --- Pretraining Datasets ---
echo "--- Preparing pretraining datasets ---"

# 1. PhysioNetMI
echo "Preparing PhysioNetMI..."
mkdir -p datasets/pretrain/PhysionetMI/
echo "Downloading PhysioNetMI dataset from https://www.physionet.org/content/eegmmidb/1.0.0/."
wget -r -N -c -np https://physionet.org/files/eegmmidb/1.0.0/
echo "After downloading, please extract all .edf and .edf.event files and place them under 'datasets/pretrain/PhysionetMI/files/eegmmidb/1.0.0/' with the structure SXXX/SXXXRYY.edf."
# read -p "Press Enter to continue after completion..."

# 2. TSUBenchmark
# echo "Preparing TSUBenchmark..."
# mkdir -p datasets/pretrain/TSUBenchmark/
# echo "Please manually download the TSUBenchmark dataset from http://bci.med.tsinghua.edu.cn/."
# echo "After downloading, place all .mat files (Freq_Phase.mat, S1.mat, ..., S35.mat) under 'datasets/pretrain/TSUBenchmark/'."
# read -p "Press Enter to continue after completion..."


# Set base URLs
TSINGHUA_BASE_URL="https://bci.med.tsinghua.edu.cn/upload/yijun"
BBCI_BASE_URL="https://www.bbci.de/competition/iv/download"

# Define Tsinghua datasets and corresponding files
declare -A tsinghua_datasets
tsinghua_datasets=(
  ["Benchmark_Dataset"]="S1.mat.7z S2.mat.7z ... S35.mat.7z"
  ["BETA_Database"]="S1-S10.tar.gz S11-S20.tar.gz ... S61-S70.tar.gz"
  ["BETA_Database_wof"]="S1-S10.tar.gz S11-S20.tar.gz ... S61-S70.tar.gz"
  ["eldBETA_database"]="S1-S10.tar.gz S11-S20.tar.gz ... S91-S100.tar.gz"
  ["FBCCA_DW_dataset"]="S1-S10.mat.zip S11-S14.mat.zip"
  ["RSVP_BCIs"]="S1-S10.mat.zip S11-S20.mat.zip ... S61-S64.mat.zip"
  ["Cross_Session_Collaborative_BCIs"]="G1D1D2.zip G2D1D2.zip ... G7D1D2.zip"
  ["Wearable_SSVEP_BCI_Dataset"]="S001-S010.zip ... S091-S102.zip"
  ["160_Targets_SSVEP_BCI_Dataset"]="S1-S4.rar ... SS9-SS12.rar"
  ["Dual_Frequency_Phase_Modulation_SSVEP_BCI"]="S1-S4.zip ... S11-S12.zip"
  ["Autism_Detection_Dataset"]="AutismDetectionDataset.zip"
  ["Efficient_Dual_Frequency_SSVEP_BCI"]="Data_of_1_Target.7z Data_of_40_Targets_Offline.7z"
)

# Define BCI Competition IV datasets and corresponding files
declare -A bbci_datasets
bbci_datasets=(
  ["Data_Set_1"]="100Hz_Matlab.zip ... 1000Hz_eval_ASCII.zip"
  ["Data_Set_2a"]="GDF_2a.zip"
  ["Data_Set_2b"]="GDF_2b.zip"
  ["Data_Set_3"]="Matlab_3.zip"
  ["Data_Set_4"]="Matlab_4.zip"
)

# Create main directory
mkdir -p BCI_Datasets
cd BCI_Datasets

# Download Tsinghua datasets
for dataset in "${!tsinghua_datasets[@]}"; do
  echo "Processing Tsinghua dataset: $dataset"
  mkdir -p "$dataset"
  cd "$dataset"
  
  for file in ${tsinghua_datasets[$dataset]}; do
    echo "Downloading file: $file"
    wget "$TSINGHUA_BASE_URL/$file" -O "$file"
  done
  
  cd ..
done

# Download BCI Competition IV datasets
for dataset in "${!bbci_datasets[@]}"; do
  echo "Processing BCI Competition IV dataset: $dataset"
  mkdir -p "$dataset"
  cd "$dataset"
  
  for file in ${bbci_datasets[$dataset]}; do
    echo "Downloading file: $file"
    wget "$BBCI_BASE_URL/$file" -O "$file"
  done
  
  cd ..
done

echo "All datasets downloaded!"

# # 8. Kaggle BCI Challenge (ERN)
# echo "Preparing Kaggle ERN..."
# mkdir -p datasets/downstream/KaggleERN/train/
# mkdir -p datasets/downstream/KaggleERN/test/
# echo "Please manually download the Kaggle BCI Challenge dataset from https://www.kaggle.com/c/inria-bci-challenge/data."
# echo "After downloading, place 'TrainLabels.csv', 'true_labels.csv' under 'datasets/downstream/KaggleERN/'."
# echo "Place training CSV files under 'datasets/downstream/KaggleERN/train/'."
# echo "Place test CSV files under 'datasets/downstream/KaggleERN/test/'."
# read -p "Press Enter to continue after completion..."

# # 9. PhysioNet ERPBCI (P300)
# echo "Preparing PhysioNet P300..."
# mkdir -p datasets/downstream/erp-based-brain-computer-interface-recordings-1.0.0/files/
# echo "Please manually download the ERP-Based BCI Recordings dataset from https://physionet.org/content/erpbci/1.0.0/."
# echo "After downloading, place the 'files' directory (including s01, s02, ...) under 'datasets/downstream/erp-based-brain-computer-interface-recordings-1.0.0/'."
# read -p "Press Enter to continue..."
# echo "Running PhysioNet P300 preprocessing..."
# if [ -f "datasets/downstream/prepare_PhysioNetP300.py" ]; then
#     (cd datasets/downstream && python prepare_PhysioNetP300.py)
#     if [ $? -ne 0 ]; then echo "Error: PhysioNet P300 preprocessing failed."; exit 1; fi
# else
#     echo "Warning: 'datasets/downstream/prepare_PhysioNetP300.py' not found, skipping PhysioNet P300 preprocessing."
# fi

echo "Dataset preparation script completed."
echo "Please double-check that all datasets have been downloaded and placed in the correct locations."
echo "Some preprocessing steps may take a while."

exit 0
