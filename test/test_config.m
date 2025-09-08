% ----------------------------------------------------------------------- %
% CONFIGURE FILE FOR POWER CURVE PLOTTER
% DTU WIND & ENERGY SYSTEMS
% TURBINE TESTS (TES) SECTION
% ----------------------------------------------------------------------- %

% D o c u m e n t a t i o n      p e n d i n g

%% Turbine specs
TURBINE.Name                                = 'DummyWind';
TURBINE.RatedPower                          = 5000         ;% in kW
TURBINE.CutIn                               = 3;
TURBINE.CutOut                              = 25;
TURBINE.Site                                = 'My backyard';

%% File paths
stats10minPath                              = '../data/sample_data_filtered.csv';
binsPath                                    = '../data/sample_UNC.dat';
outputDir                                   = '../results/';

%% Plotting options
plotOptions.savePlots                       = true;
plotOptions.includePower                    = true;
plotOptions.includePowerUncertainty         = true;
plotOptions.includeCupRatio                 = true; % Wsp_ref/Wsp_control vs wsp_corr and wdir
plotOptions.includeTurbulence               = true;
plotOptions.includeShear                    = true;
plotOptions.includeVeer                     = true;
plotOptions.includeDensity                  = true;
plotOptions.includeAtmConditions            = true;
plotOptions.includeTurbAvailability         = true;

%% Suffixes for stats10min channels (EASY output) %
channelMap.stats10min.suffixAvg             = 'Mean';
channelMap.stats10min.suffixMin             = 'Min';
channelMap.stats10min.suffixMax             = 'Max';
channelMap.stats10min.suffixStd             = 'Stdv';

%% Channel name mapping for stats10min (.csv) without suffixes  %
channelMap.stats10min.SamplingFrequency     = 35; % in Hz
channelMap.stats10min.NormWindSpeed         = 'Wspcorr_150_28m_M4';
channelMap.stats10min.WindSpeedRef          = 'Wsp_S_154_28m_M4';
channelMap.stats10min.WindSpeedCtrl         = 'Wsp_150_28m_M4';
channelMap.stats10min.WindDirection         = 'Wdir_150_28m_M4';
channelMap.stats10min.Pressure              = 'pres_150_28m_M4';
channelMap.stats10min.Temperature           = 'Tabs_150_28m_M4';
channelMap.stats10min.RelativeHumidity      = 'RH_150_28m_M4';
channelMap.stats10min.Power                 = 'PowMod';
channelMap.stats10min.TurbAvailability      = 'RUN';
channelMap.stats10min.ShearExponent         = 'shear';
channelMap.stats10min.WindVeer              = 'veer';
channelMap.stats10min.AirDensity            = 'rho_150_28_M4';
channelMap.stats10min.TurbulenceIntensity   = 'TI_S_154_28m_M4';


%% Only applicable for shear calculation (otherwise comment out or leave empty)
channelMap.stats10min.ShearCupUpper         = 'Wsp_S_154_28m_M4'; 
channelMap.stats10min.ShearCupLower         = 'Wsp_73_28m_M4';
channelMap.stats10min.HeightCupUpper        = 140.0; % in meters
channelMap.stats10min.HeightCupLower        = 70.0;  % in meters
% Only applicable for veer calculation(otherwise comment out or leave empty)
channelMap.stats10min.VeerVaneUpper         = 'Wdir_150_28m_M4';
channelMap.stats10min.VeerVaneLower         = 'Wdir_73_28m_M4';



%% Channel mapping for bins (from UNC.dat or bins.dat) %
channelMap.bins.NormWindSpeed               = 'WspCorr';
channelMap.bins.Power                       = 'PowModMean';
channelMap.bins.Cp                          = 'Cp';
channelMap.bins.TurbulenceIntensity         = 'Turbulence';
channelMap.bins.ShearExponent               = 'shear';
channelMap.bins.WindVeer                    = 'veer';
channelMap.bins.AirDensity                  = 'rho_150_28_M4';
channelMap.bins.CombinedUnc                 = 'Combined_Unc_';

