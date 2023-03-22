function [straits, DataParams, FluxParams] = InitializeStraits(balanceFlag)

DataParams = DefineDataParameters(32) ;
FluxParams = DefineFluxParameters() ;

% Define cross-sectional area of each strait here. See Tsubouchi et al. (2018) Fig 1 for these rough estimates
% Also define statistical properties of timeseries for each strait. See Tsubouchi et al. (2018) Table 3 and Figs. 2 and 4.

% Fram Strait
straitParams.speed_std      = 0.0004 ;      % Speed standard deviation [m/s]
straitParams.speed_Delta    = 0.0 ;         % Speed change over timeseries [m/s]
straitParams.speed_mean     = -0.0037 ;     % Speed average value [m/s]
straitParams.temp_std       = 0.2 ;         % Temperature standard deviation [C]
straitParams.temp_Delta     = 0.0 ;         % Temperature change over timeseries [C]
straitParams.temp_mean      = 1.0 ;         % Temperature average value [C]
straitParams.salinity_std   = 0.1 ;         % Salinity    standard deviation [g/kg]
straitParams.salinity_Delta = 0.0 ;         % Salinity    change over timeseries [g/kg]
straitParams.salinity_mean  = 34.0 ;        % Salinity    average value [g/kg]
straitParams.area           = 3e8 ;         % Strait cross-sectional area [m^2]
FramStrait = DefineStrait(DataParams,straitParams,"Fram Strait") ;

% Davis Strait
straitParams.speed_std      = 0.0002 ;      % Speed standard deviation [m/s]
straitParams.speed_Delta    = 0.0 ;         % Speed change over timeseries [m/s]
straitParams.speed_mean     = -0.01 ;       % Speed average value [m/s]
straitParams.temp_std       = 1.0 ;         % Temperature standard deviation [C]
straitParams.temp_Delta     = 0.0 ;         % Temperature change over timeseries [C]
straitParams.temp_mean      = 0.0 ;         % Temperature average value [C]
straitParams.salinity_std   = 1.0 ;         % Salinity    standard deviation [g/kg]
straitParams.salinity_Delta = 0.0 ;         % Salinity    change over timeseries [g/kg]
straitParams.salinity_mean  = 33.0 ;        % Salinity    average value [g/kg]
straitParams.area           = 2e8 ;         % Strait cross-sectional area [m^2]
DavisStrait = DefineStrait(DataParams,straitParams,"Davis Strait") ;

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
straits.FramStrait  = FramStrait ;
straits.DavisStrait = DavisStrait ;
% # "Bering Strait" => BeringStrait,
% # "BSO" => BSO,
% # "Runoff + precipitation - evapouration" => PmEmR


straits = UpdateStraits(FluxParams, straits) ;
if (balanceFlag)
    straits = BalanceMass(straits) ;
    straits = UpdateStraits(FluxParams, straits) ;
end % if

end


%% Local functions

function tmp = DefineDataParameters(N)
% Define data parameters.
tmp.N     = N ;     % Number of entries in the timeseries
tmp.c     = 0.9 ;   % Constant    parameter in AR(1) process
tmp.phi   = 0.8 ;   % Persistence parameter in AR(1) process
tmp.p_ref = 0.0 ;   % Reference pressure [N/m^2]
end

function tmp = DefineFluxParameters()
tmp.T_ref =  0.0 ;      % oC
tmp.S_ref = 34.8 ;      % g/kg
tmp.C_p   = gsw_cp0 ;   % J/kg/K
end

function strait = DefineStrait(DataParams,straitParams,name)
% times are at mid points and of duration timePeriods

timeEdges           = datetime(1990:1990+DataParams.N,1,1) ;
timePeriods         = diff(timeEdges) ;
timeMidpoints       = timeEdges(1) + timePeriods./2 ;

strait.name         = name ;
strait.normal_speed = DefineSpeed(DataParams,straitParams) ;
strait.temperature  = DefineTemperature(DataParams,straitParams) ;
strait.salinity     = DefineSalinity(DataParams,straitParams) ;
strait.time         = timeMidpoints ;
strait.time_periods = timePeriods ;
strait.parameters   = straitParams ;
strait.density      = ComputeDensity(DataParams,strait) ;

end

function speeds = DefineSpeed(DataParams,straitParams)
speeds = ar1(DataParams.N,DataParams.c,DataParams.phi,straitParams.speed_std) ;
speeds = speeds - mean(speeds) + straitParams.speed_mean ;
end

function temps = DefineTemperature(DataParams,straitParams)
temps = ar1(DataParams.N,DataParams.c,DataParams.phi,straitParams.temp_std) ;
temps = temps - mean(temps) + straitParams.temp_mean ;
temps = max(temps,-1.9) ;      % Clip temperatures so they're above freezing.
end

function salts = DefineSalinity(DataParams,straitParams)
salts = ar1(DataParams.N,DataParams.c,DataParams.phi,straitParams.salinity_std) ;
salts = salts - mean(salts) + straitParams.salinity_mean ;
salts = max(salts,0.0) ;              % Clip salinities so they're positive
end

function v = ar1(N,c,phi,std)
% AR(1) process.
v = zeros(N,1) ;
x = 0 ;         % Starting value
if(N > 0)
    v(1) = x ;
    for ii=2:N
        x = c + x * phi + randn(1) * std ;
        v(ii) = x ;
    end % ii
end % if
end

function out = ComputeDensity(DataParams,strait)
out = gsw_rho(strait.salinity, strait.temperature,DataParams.p_ref) ;
end

function straits = BalanceMass(straits)
    fprintf(1,"balancing...") ;
    massConverg = ComputeMassConverg(straits) ;
    straitNames = fieldnames(straits) ;
    for ss = 1:numel(straitNames)
        strait = straitNames{ss} ;
        straits.(strait).normal.speed = straits.(strait).normal.speed - (massConverg ./ numel(straitNames)) ./ (straits.(strait).density .* straits.(strait).parameters.area) ;
    end % ss
end

function massConverg = ComputeMassConverg(straits)
    flag = true ;
    straitNames = fieldnames(straits) ;
    for ss = 1:numel(straitNames)
        strait = straitNames{ss} ;
        tmp = straits.(strait).mass_flux ;
        if (flag || exist(massConverg,'var'))
            massConverg = similar(tmp) ;
            flag = false ;
        end % if
        massConverg = massConverg + tmp ;
    end % ss
end
