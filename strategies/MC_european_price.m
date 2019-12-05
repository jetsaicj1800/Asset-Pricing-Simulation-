function [callMC_European_Price_multi_step, putMC_European_Price_multi_step,paths] = MC_european_price(S0, K, T, r, mu, sigma, numSteps, numPaths)
    
    paths = zeros(numSteps+1,numPaths);
    dT = T/numSteps; 
    paths(1,:) = S0;
    
    %calculating future prices for each path
    for iPath = 1:numPaths
        for iStep = 1:numSteps
            paths(iStep+1,iPath) = paths(iStep,iPath) * exp((mu-0.5*sigma^2)*dT+sigma*sqrt(dT)*normrnd(0,1));
        end
    end
    
    %perform call/put option decision and discount the price back to time 0
    for iPath = 1:numPaths
        call(iPath) = max (paths(numSteps+1,iPath)-K,0)* exp(-r*T);
        put(iPath) = max (K-paths(numSteps+1,iPath),0)* exp(-r*T);
    end
    
    callMC_European_Price_multi_step = mean(call);
    putMC_European_Price_multi_step = mean(put);

end



