function straits = UpdateStraits(FluxParams, straits)
straitNames = fieldnames(straits) ;
for ss = 1:numel(straitNames)
    strait = straitNames{ss} ;
    [vol_flux,mass_flux,salt_flux,heat_flux,LFC_flux] = ComputeFluxes(straits.(strait),FluxParams) ;
    straits.(strait).vol_flux  =  vol_flux ;
    straits.(strait).mass_flux = mass_flux ;
    straits.(strait).salt_flux = salt_flux ;
    straits.(strait).heat_flux = heat_flux ;
    straits.(strait).LFC_flux  =  LFC_flux ;
end % ss
end

%% Local functions
function [vol_flux,mass_flux,salt_flux,heat_flux,LFC_flux] = ComputeFluxes(strait, FluxParams)
vol_flux  =  strait.parameters.area .* strait.normal_speed ;
mass_flux =                   strait.density .* vol_flux ;
heat_flux = FluxParams.C_p .* strait.density .* vol_flux .* (strait.temperature - FluxParams.T_ref) ;
LFC_flux  =                                     vol_flux .* (strait.salinity    - FluxParams.S_ref) ;
salt_flux =                   strait.density .* vol_flux .*  strait.salinity ;
end