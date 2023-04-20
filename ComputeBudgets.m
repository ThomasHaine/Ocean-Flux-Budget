function budgets = ComputeBudgets(components,DataParams)
budgets.mass   = accumulateBudget(components,DataParams,"mass_flux") ;
budgets.salt   = accumulateBudget(components,DataParams,"salt_flux") ;
budgets.volume = accumulateBudget(components,DataParams,"vol_flux") ;
budgets.LFC    = accumulateBudget(components,DataParams,"LFC_flux") ;
budgets.heat   = accumulateBudget(components,DataParams,"heat_flux") ;

% Add air/sea non-advective heat fluxes:
budgets.heat.AirSeaHeatFlux = components.AirSeaHeatFlux.heat_flux ;
budgets.heat.total          = budgets.heat.total + budgets.heat.AirSeaHeatFlux ;
end

%% Local functions
function budget = accumulateBudget(components,DataParams,keyName)
componentNames = fieldnames(components) ;
budget.total = zeros(numel(DataParams.time_periods),1) ;
for ss = 1:numel(componentNames)
    if(strcmp(components.(componentNames{ss}).type,'advective'))     % Only include advective components.
        component = componentNames{ss} ;
        budget.(component) = cumsum(seconds(DataParams.time_periods') .* components.(component).(keyName)) ;
        budget.total = budget.total + budget.(component) ;
    end % if
end % ss
end