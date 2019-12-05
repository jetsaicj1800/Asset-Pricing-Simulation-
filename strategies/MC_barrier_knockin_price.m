function [callMC_Barrier_Knockin_Price_multi_step, putMC_Barrier_Knockin_Price_multi_step] = ...
    MC_barrier_knockin_price(S0, Sb, K, T, r, mu, sigma, numSteps, numPaths)

    paths = zeros(numSteps+1,numPaths);
    dT = T/numSteps; 
    paths(1,:) = S0;
    
    %calculating future prices for each path
    for iPath = 1:numPaths
        for iStep = 1:numSteps
            paths(iStep+1,iPath) = paths(iStep,iPath) * exp((mu-0.5*sigma^2)*dT+sigma*sqrt(dT)*normrnd(0,1));
        end
    end
    
    
    %perform barrier call/put option decision and discount the price back to time 0
    for iPath = 1:numPaths
        %check if the barrier is crossed
        check_Sb = sum(paths(:,iPath)>=Sb);
        
        if(check_Sb>0)
            call(iPath) = max (paths(numSteps+1,iPath)-K,0) * exp(-r*T);
            put(iPath) = max (K-paths(numSteps+1,iPath),0)* exp(-r*T);
        else
            call(iPath) = 0;
            put(iPath) = 0;
        end
        
    end
    
    callMC_Barrier_Knockin_Price_multi_step = mean(call);
    putMC_Barrier_Knockin_Price_multi_step = mean(put);


end
