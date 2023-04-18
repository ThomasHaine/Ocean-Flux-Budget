function budgets = ComputeBudgets(straits,DataParams)
budgets.mass   = accumulateBudget(straits,DataParams,"mass_flux") ;
budgets.salt   = accumulateBudget(straits,DataParams,"salt_flux") ;
budgets.volume = accumulateBudget(straits,DataParams,"vol_flux") ;
budgets.heat   = accumulateBudget(straits,DataParams,"heat_flux") ;
budgets.LFC    = accumulateBudget(straits,DataParams,"LFC_flux") ;
end

%% Local functions
function budget = accumulateBudget(straits,DataParams,keyName)
straitNames = fieldnames(straits) ;
budget.total = zeros(numel(DataParams.time_periods),1) ;
for ss = 1:numel(straitNames)
strait = straitNames{ss} ;
    budget.(strait) = cumsum(seconds(DataParams.time_periods') .* straits.(strait).(keyName)) ;
    budget.total = budget.total + budget.(strait) ;
end % ss
end