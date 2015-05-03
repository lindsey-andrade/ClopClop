%% THERMO OTEC PROJECT
% Lindsey Andrade, Sean Karagianes, Meg Lidrbauch
% Spring 2015
function OTECmainFunction()
close all
%% Iteration 1 - Closed System
% Assumptions: 
% At State 1, we assume that the working fluid is a saturated vapor. At
% State 3, we assume that the working fluid is a saturated liquid. The
% working fluid leaves both heat exchangers at the temperature of the other
% fluid in the exchanger. All of the components are modeled as control
% volumes at steady state. There are no internal irreversibilities in any
% of the cycle processes. The pump and turbine operate isentropically. No
% kinetic or potential energy effects. 

T1 = 303; % K
T3 = 280; % K
q1 = 1; 
q3 = 0; 
fluid = 'ammonia';

[Wnet_m, N, N_c] = iteration1(T1, T3, q1, q3, fluid); 

% disp('Iteration 1')
% disp('Working Fluid')
% disp(fluid)
% disp('Net Work (J/kg)')
% disp(Wnet_m)
% disp('Thermal Efficiency')
% disp(N)
% disp('Carnot Efficiency')
% disp(N_c)

P1 = 101.3; %[kPa]
P2 = 1; %[kPa]
fluid2 = 'water';

[W_net,N] = iteration2(T1,T3,P1,P2,q1,q3,fluid2);
disp('Iteration 2')
disp('Net Work (J/kg)')
disp(W_net)
disp('Thermal Efficiency')
disp(N)

% Results plot for Thursday 4/22/15
Thot_min = 298; Thot_max = 323; 
ThotRange = linspace(Thot_min, Thot_max, 100);
Wrange = zeros(1, length(ThotRange));

for i = 1:length(ThotRange)
    T_in = ThotRange(i);
    [Wnet_m, N, N_c] = iteration1(T_in, T3, q1, q3, fluid); 
    Wrange(i) = Wnet_m; 
end

[WaterWnet, WaterN, WaterN_c, WaterState]= iteration1(T1, T3, q1, q3, 'water'); 
[AmmoniaWnet, AmmoniaN, AmmoniaN_c, AmmoniaState]= iteration1(T1, T3, q1, q3, 'ammonia');
[R134aWnet, R134aN, R134aN_c, R134aState] = iteration1(T1, T3, q1, q3, 'R134a');
[R245faWnet, R245faN, R245faN_c, R245faState] = iteration1(T1, T3, q1, q3, 'R245fa');
[ButaneWnet, ButaneN, ButaneN_c, ButaneState] = iteration1(T1, T3, q1, q3, 'butane');
[PropaneWnet, PropaneN, PropaneN_c, PropaneState] = iteration1(T1, T3, q1, q3, 'propane');

assignin('base', 'WaterState', WaterState)
assignin('base', 'AmmoniaState', AmmoniaState)
assignin('base', 'R134aState', R134aState)
assignin('base', 'R245faState', R245faState)
assignin('base', 'ButaneState', ButaneState)
assignin('base', 'PropaneState', PropaneState)

Y = [WaterWnet, AmmoniaWnet, R134aWnet, R245faWnet, ButaneWnet, PropaneWnet];
X = ['Water', 'Ammonia', 'R134a', 'R245fa', 'Butane', 'Propane', 'Isobutane'];
figure; bar(Y)
set(gca,'Xtick',1:6,'XTickLabel',{'Water'; 'Ammonia'; 'R134a'; 'R245fa'; 'Butane'; 'Propane'})
xlabel('Working Fluid'); ylabel('Net Power (J/kg)')
title('Working Fluid Comparision')
figure; plot(ThotRange, Wrange, 'LineWidth', 2)
xlabel('T_{hot} (K)'); ylabel('Net Power (J/kg)')
title('Temperature and Power Relationship')

function [Wnet_m, N, N_c, State] = iteration1(T1,T3,q1,q3,fluidName)
    % T1 is temperature at State 1
    % T3 is temperature at State 3
    % q1 is quality at State 1 (value between 0 and 1)
    % q3 is quality at State 3 (value between 0 and 1)
    % fluidName is the input fluid (needs to be a string)
    
    % returns P1 in [kPA], H1 in [J/kg], and S1 in [J/kgK]
    [P1,H1,S1] = refpropm('PHS','T',T1,'Q',q1,fluidName); %sets state 1
    [P3,H3,S3] = refpropm('PHS','T',T3,'Q',q3,fluidName); %sets state 3
    [T2,Q2,H2] = refpropm('TQH','P',P3,'S',S1,fluidName); %sets state 2
    [T4,Q4,H4] = refpropm('TQH','P',P1,'S',S3,fluidName); %sets state 4
    
    P2 = P3; P4 = P1;
    S2 = S1; S4 = S3;
    
    % Output State Matrix
    
    %    | State1 | State2 | State3 | State4 |
    %  T |  (K)   |        |        |        |
    %  P | (kPa)  |        |        |        |
    %  Q |        |        |        |        |
    %  S |(J/kgK) |        |        |        |
    %  H |(J/kg)  |        |        |        |
    
    
    State = zeros(5,4);
    State(1,1) = T1; State(2,1) = P1; State(3,1) = q1; State(4,1) = S1; State(5,1) = H1; 
    State(1,2) = T2; State(2,2) = P2; State(3,2) = Q2; State(4,2) = S2; State(5,2) = H2; 
    State(1,3) = T3; State(2,3) = P3; State(3,3) = q3; State(4,3) = S3; State(5,3) = H3; 
    State(1,4) = T4; State(2,4) = P4; State(3,4) = Q4; State(4,4) = S4; State(5,4) = H4;
    
    %P1
    %P3
    Wt_m = H1-H2; %[J/kg]
    Wp_m = H3-H4; %[J/kg]
    Wnet_m = Wt_m + Wp_m; %[J/kg]
    
    Qin_m = H1-H4; %[J/kg]
    N = Wnet_m/Qin_m;
    N_c = 1-T3/T1;
    %with ammonia: 91,184 J/kg
    %with R134a: 14,416 J/kg
    %with R22: 14,609 J/kg
    %with water: 188,220 J/kg something wrong? Probably. Operates between 1
    %and 4 kPa, 7% efficiency
    %Carnot Efficiency of cycle is 7.59%
    
end
    function [Wnet_m, N, N_c] = iteration2(Tw,Tc,P1,P2,q2,q4,fluidName)
        %assume the working fluid is water throughout (Though state 1 is
        %really salt water)
        T1 = Tw;
        T4 = Tc;
        
        [H1,S1] = refpropm('HS','T',T1,'P',P1,fluidName); %sets state 1
        [T2,H2,S2] = refpropm('THS','P',P2,'Q',q2,fluidName); %sets state 2
        [P4,H4,S4] = refpropm('PHS','T',T4,'Q',q4,fluidName); %sets state 4 assuming T3 = T4
        [T3,H3] = refpropm('TH','P',P2,'S',S4,fluidName); %sets state 3
    
        % Calculate how much water gets vaporized
        x = weightFractionVaporized();
        y = x; 
        
        Wnet_m = H1-H2; %[J/kg]; W_net is just W_t since there is no system pump
        Qin_m = H1-H4; %[J/kg]
        N = Wnet_m/Qin_m;
        N_c = 1-T3/T1;
        
        function x = weightFractionVaporized()
            % Tup = Temperature of liquid into the evaporator
            % Pup = Pressure of liquid into the evaporator 
            % Pdown = Pressure of liquid/vapor out of the evaporator
            Tup = 303; %[K] We want to change this if warm water temp changes
            Pup = 101.3; %[kPa]
            Pdown = 1; %[kPa]
            fluid = 'water';
            Hul = refpropm('H', 'T', Tup, 'P', Pup, fluid);
            
            Hdl = refpropm('H', 'P', Pdown, 'Q', 0, fluid); 
            Hdv = refpropm('H', 'P', Pdown, 'Q', 1, fluid);
            
            x = (Hul - Hdl)/(Hdv - Hdl);
        end
        
    end

end
