function budgets = ComputeBudgets(straits)

budgets.mass   = accumulateBudget(straits, "mass_flux") ;
budgets.salt   = accumulateBudget(straits, "salt_flux") ;
budgets.volume = accumulateBudget(straits, "vol_flux") ;
budgets.heat   = accumulateBudget(straits, "heat_flux") ;
budgets.LFC    = accumulateBudget(straits, "LFC_flux") ;

end

%% Local functions

function budget = accumulateBudget(straits, keyName)

straitNames = fieldnames(straits) ;
for ss = 1:numel(straitNames)
strait = straitNames{ss} ;
    budget.(strait) = cumsum(straits.(strait).time_periods' .* straits.(strait).(keyName)) ;
end % ss

end