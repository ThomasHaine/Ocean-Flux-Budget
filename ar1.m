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