function straits = InitializeStraits(DataParams,FluxParams)

% Define cross-sectional area of each strait here. See Tsubouchi et al.
% (2018) Fig 1 for these rough estimates.
% See also Tsubouchi et al. (2018) Table 3 and Figs. 2 and 4.
% Also define statistical properties of timeseries for each strait. THese
% are based on T_etal12 Table 3 and Hetal15 Fig. 4
% See also Wang et al. Figure 2 for hydrographic statistics.
% Compute mean speed from estimated volume flux and cross-sectional area.
% Also adjust Fram Strait values to give net FW convergence and
% accumulation.

% West Fram Strait (EGC). This includes sea ice from Tetal12 Table 3.
% Reduce variability compared to Tetal12 Table 3.
% Also the mean volume flux from Tetal12 Table 3 (-5.9Sv) seems too big.
straitParams.area           = 3e8 ;         % Strait cross-sectional area [m^2]
straitParams.speed_mean     = -4.0*1e6/straitParams.area ;       % Speed average value [m/s]
straitParams.speed_std      = 1.0*1e6/straitParams.area ;       % Speed standard deviation [m/s]
straitParams.speed_Delta    = 0.0 ;         % Speed change over timeseries [m/s]

straitParams.temp_mean      = -1.0 ;        % Temperature average value [C]
straitParams.temp_std       = 0.2 ;         % Temperature standard deviation [C]
straitParams.temp_Delta     = 0.0 ;         % Temperature change over timeseries [C]

straitParams.salinity_mean  = 34.0 ;        % Salinity    average value [g/kg]
straitParams.salinity_std   = 0.15 ;        % Salinity    standard deviation [g/kg]
straitParams.salinity_Delta = 0.0 ;         % Salinity    change over timeseries [g/kg]

WestFramStrait = DefineStrait(DataParams,straitParams,"West Fram Strait (EGC)") ;

% East Fram Strait (WSC). This includes the "Middle" of the Fram Strait
% from Tetal12 Table 3.
straitParams.area           = 3e8 ;         % Strait cross-sectional area [m^2]

straitParams.speed_mean     = (3.8+0.3)*1e6/straitParams.area ;     % Speed average value [m/s]
straitParams.speed_std      = 1.0*1e6/straitParams.area ;           % Speed standard deviation [m/s]
straitParams.speed_Delta    = 0.0 ;                                 % Speed change over timeseries [m/s]

straitParams.temp_mean      = 4.0 ;         % Temperature average value [C]
straitParams.temp_std       = 0.2 ;         % Temperature standard deviation [C]
straitParams.temp_Delta     = 1.0 ;         % Temperature change over timeseries [C]

straitParams.salinity_mean  = 35.0 ;        % Salinity    average value [g/kg]
straitParams.salinity_std   = 0.1 ;         % Salinity    standard deviation [g/kg]
straitParams.salinity_Delta = 0.0 ;         % Salinity    change over timeseries [g/kg]

EastFramStrait = DefineStrait(DataParams,straitParams,"East Fram Strait (WSC)") ;

% BSO
straitParams.area           = 3e8 ;         % Strait cross-sectional area [m^2]

straitParams.speed_mean     = 3.6e6/straitParams.area ;                  % Speed average value [m/s]
straitParams.speed_std      = (1.1/3.6)*straitParams.speed_mean ;        % Speed standard deviation [m/s]
straitParams.speed_Delta    = 0.0 ;                                      % Speed change over timeseries [m/s]

straitParams.temp_mean      = 5.5 ;         % Temperature average value [C]
straitParams.temp_std       = 0.2 ;         % Temperature standard deviation [C]
straitParams.temp_Delta     = 1.0 ;         % Temperature change over timeseries [C]

straitParams.salinity_mean  = 35.05 ;       % Salinity    average value [g/kg]
straitParams.salinity_std   = 0.05 ;        % Salinity    standard deviation [g/kg]
straitParams.salinity_Delta = 0.0 ;         % Salinity    change over timeseries [g/kg]

BSO = DefineStrait(DataParams,straitParams,"BSO") ;

% Davis Strait
% T_etal12 numbers disagree somewhat with W_etal23 numbers.
% Tune numbers to resemble W_etal23 and Hetal15 total LFC budget.
straitParams.area           = 2e8 ;         % Strait cross-sectional area [m^2]

straitParams.speed_mean     = -3.1e6/straitParams.area ;                 % Speed average value [m/s]
straitParams.speed_std      = (0.4/3.1)*straitParams.speed_mean ;        % Speed standard deviation [m/s]
straitParams.speed_Delta    = 0.0 ;                                      % Speed change over timeseries [m/s]

straitParams.temp_mean      = 0.3 ;         % Temperature average value [C]
straitParams.temp_std       = 0.3 ;         % Temperature standard deviation [C]
straitParams.temp_Delta     = 0.0 ;         % Temperature change over timeseries [C]

straitParams.salinity_mean  = 33.8 ;        % Salinity    average value [g/kg]
straitParams.salinity_std   = 0.2 ;         % Salinity    standard deviation [g/kg]
straitParams.salinity_Delta = 0.0 ;         % Salinity    change over timeseries [g/kg]

DavisStrait = DefineStrait(DataParams,straitParams,"Davis Strait") ;

% Bering Strait
straitParams.area           = 3.8e6 ;       % Strait cross-sectional area [m^2]

straitParams.speed_mean     = 1.0e6/straitParams.area ;                 % Speed average value [m/s]
straitParams.speed_std      = (0.2/1.0)*straitParams.speed_mean ;       % Speed standard deviation [m/s]
straitParams.speed_Delta    = 0.1e6/straitParams.area  ;                % Speed change over timeseries [m/s]

straitParams.temp_mean      = 0.25 ;        % Temperature average value [C]
straitParams.temp_std       = 0.25 ;        % Temperature standard deviation [C]
straitParams.temp_Delta     = 1.0 ;         % Temperature change over timeseries [C]

straitParams.salinity_mean  = 32.4 ;        % Salinity    average value [g/kg]
straitParams.salinity_std   = 0.1 ;         % Salinity    standard deviation [g/kg]
straitParams.salinity_Delta = 0.0 ;         % Salinity    change over timeseries [g/kg]

BeringStrait = DefineStrait(DataParams,straitParams,"Bering Strait") ;

% R+P-E
% Assumes a mean speed of 0.6m/s and a total flux of 6000km^3/yr from H et al. (2015) Table 1.
straitParams.area           = 3.2e5 ;       % Strait cross-sectional area [m^2]

straitParams.speed_mean     = 0.180e6/straitParams.area ;                % Speed average value [m/s]
straitParams.speed_std      = (0.009/0.18)*straitParams.speed_mean ;     % Speed standard deviation [m/s]
straitParams.speed_Delta    = 0.050e6/straitParams.area ;                % Speed change over timeseries [m/s]

straitParams.temp_mean      = 0.0 ;         % Temperature average value [C]
straitParams.temp_std       = 1.0 ;         % Temperature standard deviation [C]
straitParams.temp_Delta     = 0.0 ;         % Temperature change over timeseries [C]

straitParams.salinity_mean  = 0.0 ;         % Salinity    average value [g/kg]
straitParams.salinity_std   = 0.1 ;         % Salinity    standard deviation [g/kg]
straitParams.salinity_Delta = 0.0 ;         % Salinity    change over timeseries [g/kg]

RpPmEStrait = DefineStrait(DataParams,straitParams,"R + P - E") ;

% Air/sea heat flux
% Set speed, temperature, salinity to 0.
straitParams.area           = DataParams.CtrlVolArea ;       % Strait cross-sectional area [m^2]

straitParams.speed_mean     = 0.0 ;         % Speed average value [m/s]
straitParams.speed_std      = 0.0 ;         % Speed standard deviation [m/s]
straitParams.speed_Delta    = 0.0 ;         % Speed change over timeseries [m/s]

straitParams.temp_mean      = 0.0 ;         % Temperature average value [C]
straitParams.temp_std       = 0.0 ;         % Temperature standard deviation [C]
straitParams.temp_Delta     = 0.0 ;         % Temperature change over timeseries [C]

straitParams.salinity_mean  = 0.0 ;         % Salinity    average value [g/kg]
straitParams.salinity_std   = 0.0 ;         % Salinity    standard deviation [g/kg]
straitParams.salinity_Delta = 0.0 ;         % Salinity    change over timeseries [g/kg]

AirSeaStrait = DefineStrait(DataParams,straitParams,"Air/sea exchange") ;

% Assemble all gateway straits
straits.WestFramStrait = WestFramStrait ;
straits.EastFramStrait = EastFramStrait ;
straits.BSO            = BSO ;
straits.DavisStrait    = DavisStrait ;
straits.BeringStrait   = BeringStrait ;
straits.RpPmEStrait    = RpPmEStrait ;
straits.AirSeaStrait   = AirSeaStrait ;

straits = UpdateStraits(FluxParams,DataParams,straits) ;
if(strcmp(DataParams.massBalance,'On'))
    straits = BalanceMass(straits,'EastFramStrait') ;           % Hard code balance adjustment to WSC.
end % if

end