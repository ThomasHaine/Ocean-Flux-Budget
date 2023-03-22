function [straits, DataParams, FluxParams] = InitializeStraits(balanceFlag)

DataParams = DefineDataParameters(32) ;
FluxParams = DefineFluxParameters() ;

% Define cross-sectional area of each strait here. See Tsubouchi et al. (2018) Fig 1 for these rough estimates
% Also define statistical properties of timeseries for each strait. See Tsubouchi et al. (2018) Table 3 and Figs. 2 and 4.

% Fram Strait
straitParams = struct("speed_std",0.0004,"speed_Delta",0.0,"speed_mean",-0.0037, ...
    "temp_std",0.2,"temp_Delta",0.0,"temp_mean",1.0, ...
    "salinity_std",0.1,"salinity_Delta",0.0,"salinity_mean",34.0,"area",3e8) ;
FramStrait = DefineStrait(DataParams,straitParams,"Fram Strait") ;

% # Davis Strait
% straitParams = Dict(
%     "speed_std" => 0.0002u"m/s", "speed_Delta" => 0.0u"m/s", "speed_mean" => -0.01u"m/s",
%     "temp_std" => 1u"K", "temp_Delta" => 0.0u"K", "temp_mean" => 273.15u"K",
%     "salinity_std" => 1u"g/kg", "salinity_Delta" => 0.0u"g/kg", "salinity_mean" => 33.0u"g/kg",
%     "area" => 2e8u"m^2")
% DavisStrait = DefineStrait(DataParams,straitParams,"Davis Strait")
%
% # Bering Strait
% straitParams = Dict(
%     "speed_std" => 0.018u"m/s", "speed_Delta" => 0.0u"m/s", "speed_mean" => 0.18u"m/s",
%     "temp_std" => 2u"K", "temp_Delta" => 0.0u"K", "temp_mean" => 273.15u"K",
%     "salinity_std" => 0.5u"g/kg", "salinity_Delta" => 0.0u"g/kg", "salinity_mean" => 32.0u"g/kg",
%     "area" => 3.8e6u"m^2")
% BeringStrait = DefineStrait(DataParams,straitParams,"Bering Strait")
%
% # BSO
% straitParams = Dict(
%     "speed_std" => 0.0005u"m/s", "speed_Delta" => 0.0u"m/s", "speed_mean" => 0.0096u"m/s",
%     "temp_std" => 1u"K", "temp_Delta" => 0.0u"K", "temp_mean" => 277.0u"K",
%     "salinity_std" => 0.2u"g/kg", "salinity_Delta" => 0.0u"g/kg", "salinity_mean" => 34.8u"g/kg",
%     "area" => 2.4e8u"m^2")
% BSO = DefineStrait(DataParams,straitParams,"BSO")
%
% # R+P-E
% # Assumes a mean speed of 0.6m/s and a total flux of 6000km^3/yr from H et al. (2015) Table 1.
% straitParams = Dict(
%     "speed_std" => 0.05u"m/s", "speed_Delta" => 0.0u"m/s", "speed_mean" => 0.6u"m/s",
%     "temp_std" => 0.2u"K", "temp_Delta" => 0.0u"K", "temp_mean" => 273.15u"K",
%     "salinity_std" => 0.1u"g/kg", "salinity_Delta" => 0.0u"g/kg", "salinity_mean" => 0.0u"g/kg",
%     "area" => 3.2e5u"m^2")
% PmEmR = DefineStrait(DataParams,straitParams,"Runoff + precipitation - evapouration")
%
straits = struct( ...
    "Fram Strait",FramStrait, ...
    "Davis Strait",DavisStrait) ;
% # "Bering Strait" => BeringStrait,
% # "BSO" => BSO,
% # "Runoff + precipitation - evapouration" => PmEmR


% local straits = UpdateStraits(FluxParams, straits)
if (balanceFlag)
    %     straits = BalanceMass(straits)
    %     straits = UpdateStraits(FluxParams, straits)
end % if

end


%% Local functions

function tmp = DefineDataParameters(N)
% Define data parameters.
tmp.N     = N ;     % Number of entries in the timeseries
tmp.c     = 0.9 ;   % Nu
tmp.phi   = 0.8 ;
tmp.p_ref = 0.0 ;   % Reference pressure [N/m^2]
end

function tmp = DefineFluxParameters()
tmp.T_ref =  0.0 ;      % oC
tmp.S_ref = 34.8 ;      % g/kg
tmp.C_p   = gsw_cp0 ;   % J/kg/K
end

function strait = DefineStrait(DataParams,straitParams,name)
% times are at mid points and of duration timePeriods
N                = DataParams.N ;
% timePeriods      = fill(year(1), N) ;
% timeEdges        = DateTime(1990) + [Year(0); cumsum(timePeriods)] ;
% timePeriods      = diff(timeEdges) ;
% timeMidpoints    = fill(DateTime(2022, 12, 30, 14, 32, 0), N) ;
% timeMidpoints(1) = timeEdges(1) + timePeriods(1) / 2 ;
% for tt = 2:N
%     timeMidpoints(tt) = timeEdges(1) + sum(timePeriods(1:tt-1)) + timePeriods(tt) / 2 ;
% end % tt
timePeriods         = DataParams.N.*ones
timeMidPoints       = datetime(1990:1990+DataParams.N,1,15) ;

strait.name         = name ;
strait.normal_speed = DefineSpeed(DataParams,straitParams) ;
strait.temperature  = DefineTemperature(DataParams,straitParams) ;
strait.salinity     = DefineSalinity(DataParams,straitParams) ;
strait.time         = timeMidpoints ;
strait.time_periods = timePeriods ;
strait.parameters   = straitParams ;
strait.density      = ComputeDensity(DataParams,strait) ;

end
