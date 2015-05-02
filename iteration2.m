% T1 = 303; % K
% T3 = 280; % K
% q1 = 1; 
% q3 = 0; 
% P1 = 101.3; %[kPa]
% P2 = 1; %[kPa]
% fluid2 = 'water';

function [Wnet_m, N, N_c] = iteration2(Tw,Tc,P1,P2,q2,q4,fluidName)
        %assume the working fluid is water throughout (Though state 1 is
        %really salt water)
        T1 = Tw;
        T4 = Tc;
        
        [H1,S1] = refpropm('HS','T',T1,'P',P1,fluidName); %sets state 1
        [T2,H2,S2] = refpropm('THS','P',P2,'Q',q2,fluidName); %sets state 2
        [P4,H4,S4] = refpropm('PHS','T',T4,'Q',q4,fluidName); %sets state 4 assuming T3 = T4
        [T3,H3] = refpropm('TH','P',P2,'S',S4,fluidName); %sets state 3
        [H5] = refpropm('H','T',293,'P',4,'air.mix'); %sets begin state of air in vac chamb
        [H6] = refpropm('H','T',293,'P',P1,'air.mix'); %sets state after pump
    
        % Calculate how much water gets vaporized
        x = weightFractionVaporized();
        y = x; 
        
        Wnet_m = H2-H3; %[J/kg]; W_net is just W_t since there is no system pump
        Qin_m = H6-H5 %[J/kg]
        N = Wnet_m/Qin_m;
        N_c = 1-T3/T1;
        
        function x = weightFractionVaporized()
            % Tup = Temperature of liquid into the evaporator
            % Pup = Pressure of liquid into the evaporator 
            % Pdown = Pressure of liquid/vapor out of the evaporator
            Tup = T1; %[K] We want to change this if warm water temp changes
            Pup = P1; %[kPa]
            Pdown = 1; %[kPa]
            fluidx = 'water';
            Hul = refpropm('H', 'T', Tup, 'P', Pup, fluidx);
            
            Hdl = refpropm('H', 'P', Pdown, 'Q', 0, fluidx); 
            Hdv = refpropm('H', 'P', Pdown, 'Q', 1, fluidx);
            
            x = (Hul - Hdl)/(Hdv - Hdl);
        end
        
end