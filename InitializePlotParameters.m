function tmp = InitializePlotParameters()
% Define app plot parameters.
tmp.extremaFlag          = 'Off' ;
tmp.trendFlag            = 'Off' ;
tmp.FixaxesFlag          = 'Off' ;
tmp.BudgetComponentsFlag = 'Off' ;

% For colors see: https://www.mathworks.com/help/matlab/creating_plots/specify-plot-colors.html
tmp.WestFramStrait.color = [0.0000 0.4470 0.7410] ;
tmp.EastFramStrait.color = [0.4660 0.6740 0.1880] ;
tmp.BSO.color            = [0.3010 0.7450 0.9330] ;
tmp.DavisStrait.color    = [0.8500 0.3250 0.0980] ;
tmp.BeringStrait.color   = [0.9290 0.6940 0.1250] ;
tmp.RpPmEStrait.color    = [0.4940 0.1840 0.5560] ;
tmp.AirSeaHeatFlux.color = [0.6350 0.0780 0.1840] ;

% Plot sizes
tmp.height               = 125 ;
tmp.width                = 270 ;
end