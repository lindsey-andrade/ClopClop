% Iteration 1 passed variables

for i = 287:305
    T1 = i;
    T3 = 280; % K
    q1 = 1; 
    q3 = 0; 
    fluid = 'ammonia';

    [Wnet_m, N, N_c] = iteration1(T1, T3, q1, q3, fluid); 

    % Iteration 2 passed variables 
    P1o = 101.3; %[kPa]
    P2o = 1; %[kPa]
    fluid2 = 'water';

    [W_net,N] = iteration2(T1,T3,P1o,P2o,q1,q3,fluid2);

    % Iteration 3 passed variables
    fluidHybrid = 'ammonia';

    [Wnet_mH, NH] = iteration3(T1,T3,P1o,P2o,fluidHybrid);

    hold on;
    plot(T1,Wnet_m/10^3,'rx','MarkerSize',10)
    plot(T1,W_net/10^3,'k*','MarkerSize',10)
    plot(T1,Wnet_mH/10^3,'bo','MarkerSize',10)
end

legend('Closed System','Open System','Hybrid System')
title('Relative work output as T_h varies','FontSize',24)
xlabel('T_h [K]','FontSize',16)
ylabel('W/m [kJ/kg]','FontSize',16)

