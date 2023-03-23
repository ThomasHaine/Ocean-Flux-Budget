function budgets = ComputeBudgets(straits)
budgets.mass   = accumulateBudget(straits,"mass_flux") ;
budgets.salt   = accumulateBudget(straits,"salt_flux") ;
budgets.volume = accumulateBudget(straits,"vol_flux") ;
budgets.heat   = accumulateBudget(straits,"heat_flux") ;
budgets.LFC    = accumulateBudget(straits,"LFC_flux") ;
end

%% Local functions
function budget = accumulateBudget(straits, keyName)
straitNames = fieldnames(straits) ;
budget.total = zeros(numel(straits.(straitNames{1}).time_periods),1) ;
for ss = 1:numel(straitNames)
strait = straitNames{ss} ;
    budget.(strait) = cumsum(seconds(straits.(strait).time_periods') .* straits.(strait).(keyName)) ;
    budget.total = budget.total + budget.(strait) ;
end % ss
end