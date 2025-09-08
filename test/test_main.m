% ----------------------------------------------------------------------- %
% MAIN SCRIPT FOR POWER CURVE PLOTTER
% DTU WIND & ENERGY SYSTEMS
% TURBINE TESTS (TES) SECTION
% !!!! PLEASE DO NOT MODIFY !!!!
% ----------------------------------------------------------------------- %

% D o c u m e n t a t i o n      p e n d i n g

clc; clear; close all

script = 'Power Curve Plotter'; 
version = '0.1'; 
disp('**********************************')
disp('DTU Wind & Energy Systems')
disp('Turbine Tests Section')
disp(script)
disp(['Version: ', version,])
disp('**********************************')


% Load and run config file
disp('Loading config. file...')
fullConfigPath          = './test_config.m';
run(fullConfigPath);


if plotOptions.savePlots
    % Generate timestamped output directory
    timestamp = datestr(now, 'yyyy-mm-dd_HH-MM');
    outputDir = fullfile([outputDir 'PCplotter_' timestamp]);
    mkdir(outputDir);
end


RESULTS_test    = generate_PC_report(stats10minPath, binsPath, outputDir, plotOptions, channelMap);


disp(['All plots and results saved in: ' outputDir]);
