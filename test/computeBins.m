function [data_binned, count] = computeBins(data, BinEdges, BinFor)
    % Function to compute the mean bin values of the input data based on 
    % a certain variable

    % ----- Inputs ------
    % 1. data           :   input data that are going to be return as bins 
    %                       based on BinFor 
    % 2. BinEdges       :   edges of the bins (intervals of 0.5m/s for PC, 
    %                       intervals of 1m/s for Loads)
    % 3. BinFor         :   data which the binning process will be done for 
    %                       (for WT applications BinFor = Wind Speed or TI)

    % ----- Outputs ------
    % 1. data_binned    :   bin-mean values of 'data' per 'BinFor' bin 
    % 2. count          :   number of points per bin



    % binning for 'BinFor' (typically some wind speed of interest)
    bin_idx         = discretize(BinFor, BinEdges, 'IncludedEdge', 'right');
    valid           = ~isnan(bin_idx);

    % compute mean-bin values of 'data' per 'BinFor' bin
    data_binned     = accumarray(bin_idx(valid), data(valid), [], @mean);
    count           = accumarray(bin_idx(valid), 1);

end