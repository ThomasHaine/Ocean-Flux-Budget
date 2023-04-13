function straits = InitializeStraits(DataParams,FluxParams)

% Define cross-sectional area of each strait here. See Tsubouchi et al.
% (2018) Fig 1 for these rough estimates.
% See also Tsubouchi et al. (2018) Table 3 and Figs. 2 and 4.
% Also define statistical properties of timeseries for each strait. THese
% are based on T_etal12 Table 3 and Hetal15 Fig. 4
% See also Wang et al. Figure 2 for hydrographic statistics.
% Compute mean speed from estimated volume flux and cross-sectional area.

% West Fram Strait (EGC). This includes sea ice from Tetal12 Table 3.
straitParams.area           = 3e8 ;         % Strait cross-sectional area [m^2]
straitParams.speed_mean     = (-0.4-0.05-5.4)*1e6/straitParams.area ;  % Speed average value [m/s]
straitParams.speed_std      = (2.72/(0.4+0.05+5.4))*straitParams.speed_mean ;      % Speed standard deviation [m/s]
straitParams.speed_Delta    = 0.0 ;         % Speed change over timeseries [m/s]

straitParams.temp_mean      = 1.0 ;         % Temperature average value [C]
straitParams.temp_std       = 0.2 ;         % Temperature standard deviation [C]
straitParams.temp_Delta     = 0.0 ;         % Temperature change over timeseries [C]

straitParams.salinity_mean  = 33.5 ;        % Salinity    average value [g/kg]
straitParams.salinity_std   = 0.15 ;        % Salinity    standard deviation [g/kg]
straitParams.salinity_Delta = 0.0 ;         % Salinity    change over timeseries [g/kg]

WestFramStrait = DefineStrait(DataParams,straitParams,"West Fram Strait (EGC)") ;

% East Fram Strait (WSC). This includes the "Middle" of the Fram Strait
% from Tetal12 Table 3.
straitParams.area           = 3e8 ;         % Strait cross-sectional area [m^2]

straitParams.speed_mean     = (3.8+0.3)*1e6/straitParams.area ; % Speed average value [m/s]
straitParams.speed_std      = ((3.0+1.3)/(3.8+0.3))*straitParams.speed_mean ;      % Speed standard deviation [m/s]
straitParams.speed_Delta    = 0.0 ;         % Speed change over timeseries [m/s]

straitParams.temp_mean      = 4.0 ;         % Temperature average value [C]
straitParams.temp_std       = 0.2 ;         % Temperature standard deviation [C]
straitParams.temp_Delta     = 1.0 ;         % Temperature change over timeseries [C]

straitParams.salinity_mean  = 35.0 ;        % Salinity    average value [g/kg]
straitParams.salinity_std   = 0.1 ;         % Salinity    standard deviation [g/kg]
straitParams.salinity_Delta = 0.0 ;         % Salinity    change over timeseries [g/kg]

EastFramStrait = DefineStrait(DataParams,straitParams,"East Fram Strait (WSC)") ;

% BSO
straitParams.area           = 3e8 ;         % Strait cross-sectional area [m^2]

straitParams.speed_mean     = 3.6e6/straitParams.area ; % Speed average value [m/s]
straitParams.speed_std      = (1.1/3.6)*straitParams.speed_mean ;      % Speed standard deviation [m/s]
straitParams.speed_Delta    = 0.0 ;         % Speed change over timeseries [m/s]

straitParams.temp_mean      = 5.5 ;         % Temperature average value [C]
straitParams.temp_std       = 0.2 ;         % Temperature standard deviation [C]
straitParams.temp_Delta     = 1.0 ;         % Temperature change over timeseries [C]

straitParams.salinity_mean  = 35.05 ;       % Salinity    average value [g/kg]
straitParams.salinity_std   = 0.05 ;        % Salinity    standard deviation [g/kg]
straitParams.salinity_Delta = 0.0 ;         % Salinity    change over timeseries [g/kg]

BSO = DefineStrait(DataParams,straitParams,"BSO") ;

% Davis Strait
straitParams.area           = 2e8 ;         % Strait cross-sectional area [m^2]

straitParams.speed_mean     = -3.1e6/straitParams.area ; % Speed average value [m/s]
straitParams.speed_std      = (0.7/3.1)*straitParams.speed_mean ;      % Speed standard deviation [m/s]
straitParams.speed_Delta    = 0.0 ;         % Speed change over timeseries [m/s]

straitParams.temp_mean      = 0.0 ;         % Temperature average value [C]
straitParams.temp_std       = 1.0 ;         % Temperature standard deviation [C]
straitParams.temp_Delta     = 1.0 ;         % Temperature change over timeseries [C]

straitParams.salinity_mean  = 32.5 ;        % Salinity    average value [g/kg]
straitParams.salinity_std   = 0.2 ;         % Salinity    standard deviation [g/kg]
straitParams.salinity_Delta = 0.0 ;         % Salinity    change over timeseries [g/kg]

DavisStrait = DefineStrait(DataParams,straitParams,"Davis Strait") ;

% Bering Strait
straitParams.area           = 3.8e6 ;       % Strait cross-sectional area [m^2]

straitParams.speed_mean     = 1.0e6/straitParams.area ;                 % Speed average value [m/s]
straitParams.speed_std      = (0.2/1.0)*straitParams.speed_mean ;       % Speed standard deviation [m/s]
straitParams.speed_Delta    = 0.3e6/straitParams.area  ;                % Speed change over timeseries [m/s]

straitParams.temp_mean      = 0.0 ;         % Temperature average value [C]
straitParams.temp_std       = 0.25 ;        % Temperature standard deviation [C]
straitParams.temp_Delta     = 1.0 ;         % Temperature change over timeseries [C]

straitParams.salinity_mean  = 32.4 ;        % Salinity    average value [g/kg]
straitParams.salinity_std   = 0.1 ;         % Salinity    standard deviation [g/kg]
straitParams.salinity_Delta = 0.0 ;         % Salinity    change over timeseries [g/kg]

BeringStrait = DefineStrait(DataParams,straitParams,"Bering Strait") ;

% R+P-E
% Assumes a mean speed of 0.6m/s and a total flux of 6000km^3/yr from H et al. (2015) Table 1.
straitParams.area           = 3.2e5 ;       % Strait cross-sectional area [m^2]

straitParams.speed_mean     = 0.180e6/straitParams.area ; % Speed average value [m/s]
straitParams.speed_std      = (0.009/0.18)*straitParams.speed_mean ;      % Speed standard deviation [m/s]
straitParams.speed_Delta    = 0.0 ;         % Speed change over timeseries [m/s]

straitParams.temp_mean      = 0.0 ;         % Temperature average value [C]
straitParams.temp_std       = 1.0 ;         % Temperature standard deviation [C]
straitParams.temp_Delta     = 0.0 ;         % Temperature change over timeseries [C]

straitParams.salinity_mean  = 0.0 ;         % Salinity    average value [g/kg]
straitParams.salinity_std   = 0.1 ;         % Salinity    standard deviation [g/kg]
straitParams.salinity_Delta = 0.0 ;         % Salinity    change over timeseries [g/kg]

RpPmEStrait = DefineStrait(DataParams,straitParams,"R + P - E") ;

straits.WestFramStrait = WestFramStrait ;
straits.EastFramStrait = EastFramStrait ;
straits.BSO            = BSO ;
straits.DavisStrait    = DavisStrait ;
straits.BeringStrait   = BeringStrait ;
straits.RpPmEStrait    = RpPmEStrait ;

straits = UpdateStraits(FluxParams, straits) ;
if(strcmp(DataParams.massBalance,'On'))
    straits = BalanceMass(straits) ;
end % if

end

%% Local functions

function strait = DefineStrait(DataParams,straitParams,name)
% times are at mid points and of duration timePeriods
timeEdges           = linspace(DataParams.start_date,DataParams.end_date,DataParams.N+1) ;
timePeriods         = diff(timeEdges) ;
timeMidpoints       = timeEdges(1:end-1) + timePeriods/2 ;       % Notice weird datetime arithmetic and syntax!

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

% Equilibrated start up
sample_start = c / (1 - phi) + randn(1) * std / sqrt(1 - phi^2) ;

% Compute
v = zeros(N,1) ;
x = sample_start ;                      % Starting value
fac = sqrt(std^2 * (1 - phi^2)) ;       % See: https://en.wikipedia.org/wiki/Autoregressive_model#Example:_An_AR(1)_process
if(N > 0)
    v(1) = x ;
    for ii=2:N
        x = c + x * phi + randn(1) * fac;
        v(ii) = x ;
    end % ii
end % if
end

function out = ComputeDensity(DataParams,strait)
out = gsw_rho(strait.salinity, strait.temperature,DataParams.p_ref) ;
end

function straits = BalanceMass(straits)
    massConverg = ComputeMassConverg(straits) ;
    straitNames = fieldnames(straits) ;
    for ss = 1:numel(straitNames)
        strait = straitNames{ss} ;
        straits.(strait).normal_speed = straits.(strait).normal_speed - (massConverg ./ numel(straitNames)) ./ (straits.(strait).density .* straits.(strait).parameters.area) ;
    end % ss
end

function massConverg = ComputeMassConverg(straits)
    flag = true ;
    straitNames = fieldnames(straits) ;
    for ss = 1:numel(straitNames)
        strait = straitNames{ss} ;
        tmp = straits.(strait).mass_flux ;
        if (flag || ~exist('massConverg','var'))
            massConverg = zeros(size(tmp)) ;
            flag = false ;
        end % if
        massConverg = massConverg + tmp ;
    end % ss
end