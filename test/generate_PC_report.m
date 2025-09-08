% ----------------------------------------------------------------------- %
% FUNCTION FILE FOR POWER CURVE PLOTTER
% DTU WIND & ENERGY SYSTEMS
% TURBINE TESTS (TES) SECTION
% !!!! PLEASE DO NOT MODIFY !!!!
% ----------------------------------------------------------------------- %

% D o c u m e n t a t i o n      p e n d i n g

function DATA = generate_PC_report(stats10minPath, binsPath, outputDir, options, channelMap)
    colororder("gem")
    set(groot, 'defaultTextInterpreter', 'latex');
    set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
    set(groot, 'defaultLegendInterpreter', 'latex');

    % Load data
    DATA.stats10minData = readtable(stats10minPath);
    DATA.binsData       = readtable(binsPath, 'FileType', 'text');

    % Extract channels from stats10min
    Fs                  = channelMap.stats10min.SamplingFrequency;
    wspNorm_10min       = DATA.stats10minData.(strcat(channelMap.stats10min.NormWindSpeed, channelMap.stats10min.suffixAvg));
    wspRef_10min        = DATA.stats10minData.(strcat(channelMap.stats10min.WindSpeedRef, channelMap.stats10min.suffixAvg));
    wspCtrl_10min       = DATA.stats10minData.(strcat(channelMap.stats10min.WindSpeedCtrl, channelMap.stats10min.suffixAvg));
    power_10minMean     = DATA.stats10minData.(strcat(channelMap.stats10min.Power, channelMap.stats10min.suffixAvg));
    power_10minMax      = DATA.stats10minData.(strcat(channelMap.stats10min.Power, channelMap.stats10min.suffixMax));
    power_10minMin      = DATA.stats10minData.(strcat(channelMap.stats10min.Power, channelMap.stats10min.suffixMin));
    power_10minStd      = DATA.stats10minData.(strcat(channelMap.stats10min.Power, channelMap.stats10min.suffixStd));
    pres_10min          = DATA.stats10minData.(strcat(channelMap.stats10min.Pressure, channelMap.stats10min.suffixAvg));
    temp_10min          = DATA.stats10minData.(strcat(channelMap.stats10min.Temperature, channelMap.stats10min.suffixAvg));
    rh_10min            = DATA.stats10minData.(strcat(channelMap.stats10min.RelativeHumidity, channelMap.stats10min.suffixAvg));
    wd_10min            = DATA.stats10minData.(strcat(channelMap.stats10min.WindDirection, channelMap.stats10min.suffixAvg));
    availability        = DATA.stats10minData.(strcat(channelMap.stats10min.TurbAvailability, channelMap.stats10min.suffixAvg));
    % Extract channels from bins
    wspNorm_bin         = DATA.binsData.(channelMap.bins.NormWindSpeed);
    power_bin           = DATA.binsData.(channelMap.bins.Power);
    Cp_bin              = DATA.binsData.(channelMap.bins.Cp);
    

    %% Plot 1: Power Curve related plots
    if options.includePower
        figure;
        hold on;
        h1 = scatter(wspNorm_10min, power_10minMin, 10, 'filled');
        h2 = scatter(wspNorm_10min, power_10minMax, 10, 'filled');
        h3 = scatter(wspNorm_10min, power_10minMean,10, 'filled');
        h4 = scatter(wspNorm_10min, power_10minStd, 10, 'filled');
        
        xlabel('Normalised Wind Speed (m/s)'); ylabel('Power (kW)');
        title(['Measured Power Output Statistics Sampled at $F_s=$ ',num2str(Fs), ' Hz']);
        legend([h1 h2 h3 h4], {'Min', 'Max', 'Mean', 'Std'}, Location='best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot1_pc_Stats.png'));
        end
        
        % 10min mean, bin mean vs wind speed 
        figure;
        hold on;
        h1 = scatter(wspNorm_10min, power_10minMean, 10);
        h2 = plot(wspNorm_bin, power_bin, '-o');
        
        title('Measured Power Curve corrected to $\rho = 1.225$ kg/m$^3$');
        xlabel('Normalised Wind Speed (m/s)'); ylabel('Power (kW)');
        legend([h1 h2], {'10min mean', 'bin mean'}, Location='best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot1_pc_MeanBin.png'));
        end
        

        % bin mean vs wind speed 
        figure;
        hold on;
        h2 = plot(wspNorm_bin, power_bin, '-o');
        
        title('Measured Power Curve corrected to $\rho = 1.225$ kg/m$^3$');
        xlabel('Normalised Wind Speed (m/s)'); ylabel('Power (kW)');
        legend(h2, {'bin mean'}, Location='best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot1_pc_Bin.png'));
        end

        % Cp vs wind speed 
        figure;
        hold on;
        h1 = plot(wspNorm_bin, Cp_bin, '-o');

        title('$C_P$ at sea level air density $\rho = 1.225$ kg/m$^3$');
        xlabel('Normalised Wind Speed (m/s)'); ylabel('$C_P$ (-)');
        ylim([0, 0.6])
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot1_pc_Cp.png'));
        end
        
    end

    if options.includePowerUncertainty
        
        combined_unc = DATA.binsData.(channelMap.bins.CombinedUnc);

        figure;
        h1 = errorbar(wspNorm_bin,power_bin,combined_unc, '.');
        title('Measured Power Curve corrected to $\rho = 1.225$ kg/m$^3$');
        xlabel('Normalised Wind Speed (m/s)'); ylabel('Power (kW)');
        legend(h1, {'bin mean $\pm$ combined unc.'}, Location='best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot1_pc_combinedUnc.png'));
        end

    end

    if options.includeCupRatio

        figure;
        h1 = scatter(wspRef_10min, wspRef_10min./wspCtrl_10min, 10, 'filled');
        title('Wind Speed Ratio vs Wind Speed');
        xlabel('Wind Speed (m/s)');
        ylabel('$U_{primary} / U_{control}$ (-)');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot_WspRef_WspCtrl_vs_WindSpeed.png'));
        end

        figure;
        h1 = scatter(wd_10min, wspRef_10min./wspCtrl_10min, 10, 'filled');
        title('Wind Speed Ratio vs Wind Direction');
        xlabel('Wind Direction (deg)');
        ylabel('$U_{primary} / U_{control}$ (-)');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot_WspRef_WspCtrl_vs_WindDir.png'));
        end


    end

    %% Plot 2: Turbulence Intensity vs Wind Speed
    if options.includeTurbulence

        try 
            ti_10min            = DATA.stats10minData.(strcat(channelMap.stats10min.TurbulenceIntensity, channelMap.stats10min.suffixAvg));
            ti_bin              = DATA.binsData.(channelMap.bins.TurbulenceIntensity);

        catch
            disp('Turbulence Intensity not found. Computing TI channel...')
            wspRef_10min_std    = DATA.stats10minData.(strcat(channelMap.stats10min.WindSpeedRef, channelMap.stats10min.suffixStd));
            
            % Treatment of bins with <3 datapoints needed...UNDER CONSTRUCTION
            binEdges               = 0.75:0.5:25; % hardcoded for now
            ti_10min            = wspRef_10min_std ./ wspRef_10min * 100;
            [ti_bin, count]     = computeBins(ti_10min, binEdges, wspNorm_10min);

        end


        figure;
        hold on;
        h1 = scatter(wspRef_10min, ti_10min, 10, 'filled');
        h2 = plot(wspNorm_bin, ti_bin, '-o');
        title('Turbulence Intensity vs Wind Speed');
        xlabel('Wind Speed (m/s)'); ylabel('Turbulence Intensity ($\%$)');
        legend([h1 h2], {'10min mean', 'bin mean'}, Location='best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot2_TI_vs_WS.png'));
        end

    %% Plot 3: Turbulence Intensity vs Wind Direction
        figure;
        h1 = scatter(wd_10min, ti_10min, 10, 'filled');
        title('Turbulence Intensity vs Wind Direction');
        xlabel('Wind Direction (deg)'); ylabel('Turbulence Intensity ($\%$)');
        legend(h1, '10min mean', Location='best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot3_TI_vs_WD.png'));
        end
    end

    %% Plot 4: Shear Exponent vs Wind Speed
    if options.includeShear
        
        % Computing shear if not provided in the EASY output
        try
            shear_10min             = DATA.stats10minData.(strcat(channelMap.stats10min.ShearExponent, channelMap.stats10min.suffixAvg));
            shear_bin               = DATA.binsData.(channelMap.bins.ShearExponent);

        catch
            disp('Shear not found. Computing shear channel...')
            wspCupUpper_10min       = DATA.stats10minData.(strcat(channelMap.stats10min.ShearCupUpper, channelMap.stats10min.suffixAvg));
            wspCupLower_10min       = DATA.stats10minData.(strcat(channelMap.stats10min.ShearCupLower, channelMap.stats10min.suffixAvg));
            HeightCupUpper          = channelMap.stats10min.HeightCupUpper;
            HeightCupLower          = channelMap.stats10min.HeightCupLower;

            binEdges                   = 0.75:0.5:25; % hardcoded for now
            shear_10min             = log( wspCupUpper_10min./wspCupLower_10min ) ./ log( HeightCupUpper./HeightCupLower );
            % Treatment of bins with <3 datapoints needed...UNDER CONSTRUCTION
            [shear_bin,count]   = computeBins(shear_10min, binEdges, wspNorm_10min);
        end


        figure;
        hold on;
        h1 = scatter(wspRef_10min, shear_10min, 10, 'filled');
        h2 = plot(wspNorm_bin, shear_bin, 'o-');
        title('Shear Exponent vs Wind Speed');
        xlabel('Wind Speed (m/s)'); ylabel('Shear Exponent (-)');
        legend([h1 h2], {'10min mean', 'bin mean'}, Location='best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot4_Shear_vs_WS.png'));
        end

        %% Plot 5: Shear Exponent vs Wind Direction

        figure;
        h1 = scatter(wd_10min, shear_10min, 10, 'filled');
        title('Shear Exponent vs Wind Direction');
        xlabel('Wind Direction (deg)'); ylabel('Shear Exponent (-)');
        legend(h1, '10min mean', Location='best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot5_Shear_vs_WD.png'));
        end
    end

    %% Plot 6: Wind Veer vs Wind Speed
    if options.includeVeer

        % Computing wind veer if not provided in the EASY output 
        try
            veer_10min             = DATA.stats10minData.(strcat(channelMap.stats10min.WindVeer, channelMap.stats10min.suffixAvg));
            veer_bin               = DATA.binsData.(channelMap.bins.WindVeer);

        catch
            disp('Veer not found. Computing veer channel...')
            wdVaneUpper_10min       = DATA.stats10minData.(strcat(channelMap.stats10min.VeerVaneUpper, channelMap.stats10min.suffixAvg));
            wdVaneLower_10min       = DATA.stats10minData.(strcat(channelMap.stats10min.VeerVaneLower, channelMap.stats10min.suffixAvg));

            binEdges               = 0.75:0.5:25; % hardcoded for now
            veer_10min          = wdVaneUpper_10min - wdVaneLower_10min;
            % Treatment of bins with <3 datapoints...UNDER CONSTRUCTION
            [veer_bin,count]    = computeBins(veer_10min, binEdges, wspNorm_10min);
            
        end


        figure;
        hold on;
        h1 = scatter(wspRef_10min, veer_10min, 10, 'filled');
        h2 = plot(wspNorm_bin, veer_bin, '-o');
        title('Wind Veer vs Wind Speed');
        xlabel('Wind Speed (m/s)'); ylabel('Wind Veer (deg)');
        legend([h1 h2], {'10min mean', 'bin mean'}, Location='best');
        grid on;

        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot6_Veer_vs_WS.png'));
        end

        %% Plot 7: Wind Veer vs Wind Direction
        figure;
        h1 = scatter(wd_10min, veer_10min, 10,'filled');
        title('Wind Veer vs Wind Direction');
        xlabel('Wind Direction (deg)'); ylabel('Wind Veer (deg)');
        legend(h1, '10min mean', Location='best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot7_Veer_vs_WD.png'));
        end
    end


    if options.includeDensity

        % Computing air density if not provided in the EASY output
        try 
            density_10min   = DATA.stats10minData.(strcat(channelMap.stats10min.AirDensity, channelMap.stats10min.suffixAvg));
            density_bin     = DATA.binsData.(channelMap.bins.AirDensity);

        catch
            disp('Air density not found. Computing air density channel...')
            binEdges               = 0.75:0.5:25;
            density_10min   = ((((pres_10min .* exp(-9.80665 ./ (287.05 .* (temp_10min + 273.15)) .* 4.0) .* 100) ./ 287.05) - (((rh_10min ./ 100) .* 0.0000205 .* exp(0.0631846 .* (temp_10min + 273.15)) .* (1.0./287.05 - 1.0./461.5)))) ./ (temp_10min + 273.15));
            % Treatment of bins with <3 datapoints...UNDER CONSTRUCTION
            [density_bin,count]    = computeBins(density_10min, binEdges, wspNorm_10min);
        end


        figure;
        hold on;
        h1  = scatter(wspRef_10min, density_10min, 10, 'filled');
        h2  = plot(wspNorm_bin, density_bin, '-o');
        title('Air Density vs Wind Speed');
        xlabel('Wind Speed (m/s)'); ylabel('Air Density (kg/m$^3$)');
        legend([h1 h2], {'10min mean', 'bin mean'}, Location='best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot6_Density_vs_WS.png'));
        end

        
        figure;
        h1 = scatter(wd_10min, density_10min, 10,'filled');
        title('Air Density vs Wind Direction');
        xlabel('Wind Direction (deg)'); ylabel('Air Density (kg/m$^3$)');
        legend(h1, '10min mean', Location='best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot7_Density_vs_WD.png'));
        end
        
    end


    if options.includeAtmConditions
        
        %% Wind speed vs Wind direction
        figure;
        h1 = scatter(wd_10min, wspRef_10min, 10, 'filled');
        title('Wind Speed vs Wind Direction');
        xlabel('Wind Direction (deg)');
        ylabel('Wind Speed (m/s)');
        legend('10min mean', 'Location', 'best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot_WSP_vs_WD.png'));
        end
        

        %% Pressure vs Wind speed, Wind direction
        figure;
        h1 = scatter(wspRef_10min, pres_10min, 10, 'filled');
        title('Pressure vs Wind Speed');
        xlabel('Wind Speed (m/s)');
        ylabel('Absolute Pressure (hPa)');
        legend(h1, '10min mean', 'Location', 'best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot_Pressure_vs_WindSpeed.png'));
        end

        figure;
        h1 = scatter(wd_10min, pres_10min, 10, 'filled');
        title('Pressure vs Wind Direction');
        xlabel('Wind Direction (deg)');
        ylabel('Absolute Pressure (hPa)');
        legend(h1, '10min mean', 'Location', 'best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot_Pressure_vs_WD.png'));
        end
    
        %% Temperature vs Wind speed, Wind direction
        figure;
        h1 = scatter(wspRef_10min, temp_10min, 10, 'filled');
        title('Temperature vs Wind Speed');
        xlabel('Wind Speed (m/s)');
        ylabel('Absolute Temperature ($^\circ$C)');
        legend(h1, '10min mean', 'Location', 'best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot_Temperature_vs_WindSpeed.png'));
        end

        figure;
        h1 = scatter(wd_10min, temp_10min, 10, 'filled');
        title('Temperature vs Wind Direction');
        xlabel('Wind Direction (deg)');
        ylabel('Absolute Temperature ($^\circ$C)');
        legend(h1, '10min mean', 'Location', 'best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot_Temperature_vs_WD.png'));
        end


        %% Relative humidity vs Wind speed, Wind direction
        figure;
        h1 = scatter(wspRef_10min, rh_10min, 10, 'filled');
        title('Relative Humidity vs Wind Speed');
        xlabel('Wind Speed (m/s)');
        ylabel('Relative Humidity ($\%$)');
        legend(h1, '10min mean', 'Location', 'best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot_Humidity_vs_WindSpeed.png'));
        end

        figure;
        h1 = scatter(wd_10min, rh_10min, 10, 'filled');
        title('Relative Humidity vs Wind Direction');
        xlabel('Wind Direction (deg)');
        ylabel('Relative Humidity ($\%$)');
        legend(h1, '10min mean', 'Location', 'best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot_Humidity_vs_WD.png'));
        end

    end
    
    %% Turbine Availability during measurement period
    if options.includeTurbAvailability
        
        figure;
        h1 = scatter(1:length(availability), availability, 5);
        title('Turbine Availability During Measurement Period');
        xlabel('Sample No. (-)');
        ylabel('Turbine Availability (-)');
        legend(h1, '10min mean', 'Location', 'best');
        grid on;
        if options.savePlots
            saveas(gcf, fullfile(outputDir, 'plot_Availability.png'));
        end

    end



end


