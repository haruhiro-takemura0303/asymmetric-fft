clc
clear all;
close all;

i=1;
data= readmatrix('cos_1000_48k.xlsx','Sheet',num2str(i));

time=data(:,1);
amp=data(:,2);