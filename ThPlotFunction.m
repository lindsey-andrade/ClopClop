% Iteration 1 passed variables

for i = 287:305
    T1 = i;
    T3 = 280; % K
    q1 = 1; 
    q3 = 0; 
    fluid = 'ammonia';

    [Wnet_C, N, N_c] = iteration1(T1, T3, q1, q3, fluid); 

    % Iteration 2 passed variables 
    P1o = 101.3; %[kPa]
    %P2o = 1; %[kPa]
    fluid2 = 'water';

    [Wnet_O,N] = iteration2(T1,T3,P1o,q1,q3,fluid2);

    % Iteration 3 passed variables
    fluidHybrid = 'ammonia';

    [Wnet_H, NH] = iteration3(T1,T3,P1o,fluidHybrid);

    hold on;
    plot(T1,Wnet_C/10^6,'rx','MarkerSize',10)
    plot(T1,Wnet_O/10^6,'k*','MarkerSize',10)
    plot(T1,Wnet_H/10^6,'bo','MarkerSize',10)
end
plot([287 305],[16.582 16.582],'g','LineWidth',3)
legend('Closed System','Open System','Hybrid System')
title('Relative power output as $T_h$ varies (ammonia)','Interpreter','LaTeX','FontSize',18)
xlabel('$T_h$ [K]','Interpreter','LaTeX','FontSize',16)
ylabel('$\dot{W}$ [MW]','Interpreter','LaTeX','FontSize',16)

