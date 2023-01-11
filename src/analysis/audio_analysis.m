clear all

%---------------------------------config---------------------------------------------
AMP_TYPE = "a";
SUPPLY_TYPE = "clean";
DATA_PATH = "./data/processed/";
data_strct = load(DATA_PATH +"amp_"+AMP_TYPE+"/"+SUPPLY_TYPE+".mat")

signal = data_strct.(SUPPLY_TYPE).aa.freq(1).vpp(1).trial(1).signal