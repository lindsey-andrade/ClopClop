%% OTEC Main Function Run Script
% Run this to put values into the iteration 1 function 

T1 = 303;
T3 = 280;
q1 = 1; 
q3 = 0; 
fluid = 'water';

[Wnet_m, N, N_c] = OTECmainFunction(T1, T3, q1, q3, fluid); 

disp('Net Work (J/kg)')
disp(Wnet_m)
disp('Thermal Efficiency')
disp(N)
disp('Carnot Efficiency')
disp(N_c)
