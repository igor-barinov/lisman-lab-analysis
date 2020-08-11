function [ tau1, tau2, amp1, amp2, coefficients, gof, p ] = calcTaus( time_values, lifetime_changes, toggle, fitswitch,  startpoints)
% CALCTAUS - calculate both Tau time-constant values from the two-term
% exponential fit of lifetime data
%   [TAU1, TAU2, AMP1, AMP2, GOF, P] = CALCTAUS(TIME_VALUES, LIFETIME_CHANGES, TOGGLE)
%   
%   This function calculates two tau values from a double exponential fit
%   of data. TIME_VALUES should contain the x-axis values (time), and
%   LIFETIME_CHANGES should contain the y-axis values (lifetime change).
%   The input arguments may either contain the full time series or from the
%   peak onward; the function takes care of it either way. TOGGLE should be
%   an integer of value either 0 or 1, with the value determining which
%   component of the double exponential is called first or second. TAU1 is the tau
%   value calculated from the first term exponential function from the
%   double exponential fit. TAU2 is the tau value calculated from the
%   second term exponential function from the fit. AMP1 is the amplitude of
%   the first term exponential. AMP2 is the amplitude of the second term
%   exponential. GOF is a structure containing the goodness of fit values
%   from the fit. P is a p-value obtained from a correlation coefficients
%   test between the data and the fit.
global rasingfallingswitch
tau1=0;tau2=0;amp1=0;amp2=0;

% finds peak Y values (such as lifetime change) and trancated all data before that
  if rasingfallingswitch ==1 %2 - rasing exp: a*exp(b*x): 1- falling exp: a*(1-exp(b*x                         
     maximum_index = find(lifetime_changes == max(lifetime_changes)); %finds max of falling exp:
  else   
    maximum_index = find(lifetime_changes == min(lifetime_changes)); %finds max of raising exp
  end   
    time_values_short = time_values(maximum_index:end); % trancates data before min or max
    time_values_short = time_values_short - min(time_values_short);
    lifetime_changes_short = lifetime_changes(maximum_index:end);
% Fits data with singleexponential fit
     if fitswitch ==1 % 1-single exp: 
          if rasingfallingswitch ==1 %1- falling exp
              %s = fitoptions('Method','NonlinearLeastSquares','Lower',[-500 -500 -500],'Upper',[500 500 500], 'Startpoint', [-300 0 0]); 
              s = fitoptions('Method','NonlinearLeastSquares','Lower',[-500 -500 -500],'Upper',[500 500 500], 'Startpoint', startpoints); 
              %f = fittype('a*exp(b*x)+c', 'options', s);  
              f = fittype('a*exp(b*x)', 'options', s); 
              [curve, gof] = fit(time_values_short, lifetime_changes_short, f);
             %[curve, gof] = fit(time_values_short, lifetime_changes_short, 'exp1');
             coefficients = coeffvalues(curve);
             a = coefficients(1); b = coefficients(2);% c = coefficients(3);% d = coefficients(4);% e = coefficients(5);
             first_exp = a*(exp(b*time_values_short));  
             amp1 = first_exp(1)-first_exp(end);
          else    %2- rasing exp
             s = fitoptions('Method','NonlinearLeastSquares','Lower',[-500 -500],'Upper',[500 500], 'Startpoint', startpoints); 
             f = fittype('a*(1-exp(b*x))', 'options', s);
            [curve, gof] = fit(time_values_short, lifetime_changes_short, f);
           %[curve, gof] = fit(time_values_short, lifetime_changes_short, 'exp1');
            coefficients = coeffvalues(curve);
            a = coefficients(1); b = coefficients(2);% c = coefficients(3);% d = coefficients(4);% e = coefficients(5);       
           first_exp = a*(1-(exp(b*time_values_short)));  
           amp1 = first_exp(end)-first_exp(1); 
          end
          
     else   %2- double exp
         % Fits data with two exponential fit
         s = fitoptions('Method','NonlinearLeastSquares','Lower',[-500 -500 -500 -500],'Upper',[500 500 500 500], 'Startpoint', startpoints);
          if rasingfallingswitch ==1 %1- falling exp
            f = fittype('a*exp(b*x) + c*exp(d*x)', 'options', s);
            [curve, gof] = fit(time_values_short, lifetime_changes_short, f);
            %[curve, gof] = fit(time_values_short, lifetime_changes_short, 'exp2');
           coefficients = coeffvalues(curve);
           a = coefficients(1); b = coefficients(2); c = coefficients(3); d = coefficients(4);% e = coefficients(5);  
                if (toggle==0),
                 first_exp = a*(exp(b*time_values_short));
                 second_exp = c*(exp(d*time_values_short));
                else
                 second_exp = a*(exp(b*time_values_short));
                 first_exp = c*(exp(d*time_values_short));
               end
           amp1 = first_exp(1)-first_exp(end);
           amp2 = second_exp(1)-second_exp(end); 
           %amp2 = mean(lifetime_changes(end-8:end));
           
          else %1 - rasing exp:
%          s = fitoptions('Method','NonlinearLeastSquares','Lower',[-500 -500 -500 -500],'Upper',[500 500 500 500], 'Startpoint', startpoints);
           f = fittype('a*(1-exp(b*x)) + c*(1-exp(d*x))', 'options', s);    
          [curve, gof] = fit(time_values_short, lifetime_changes_short, f);
          %[curve, gof] = fit(time_values_short, lifetime_changes_short, 'exp2');
          coefficients = coeffvalues(curve);
          a = coefficients(1); b = coefficients(2); c = coefficients(3); d = coefficients(4);% e = coefficients(5); 
             if (toggle==0),
                first_exp = a*(1-(exp(b*time_values_short)));
                second_exp = c*(1-(exp(d*time_values_short)));
            else
                second_exp = a*(1-(exp(b*time_values_short)));
                first_exp = c*(1-(exp(d*time_values_short)));
            end
               amp1 = first_exp(end)-first_exp(1);
               amp2 = second_exp(end)-second_exp(1); 
         end
    end
% Plot data, double exponential fit, and both one-term exponential functions
delete(figure(100));
figure(100);
plot(time_values, lifetime_changes, 'k-', 'LineWidth', 3);
hold on;
plot(time_values_short+time_values(maximum_index), curve(time_values_short), 'Color', [0 0.6 0], 'LineStyle', '-', 'LineWidth', 4);
plot(time_values_short+time_values(maximum_index), first_exp, 'r--', 'LineWidth', 2);
    if fitswitch ==2
        plot(time_values_short+time_values(maximum_index), second_exp, 'b--', 'LineWidth', 2);
    end
%axis([-1 3 -0.02 0.14]);
xlabel('Time ', 'FontSize', 14);
%ylabel('Lifetime change (ns)', 'FontSize', 14);
ylabel('F ', 'FontSize', 14);
title('Exp Fit', 'FontSize', 16);
legend('Data', 'Double exponential fit', 'First exponential', 'Second exponential');

% Perform a correlation coefficients test to determine how similar data and
% fit are; p<0.05 indicates significant similarity
[~, p] = corrcoef(lifetime_changes_short, curve(time_values_short));
p = p(2);

% Calculate both taus
syms x;
  if rasingfallingswitch ==1 %2- falling exp
    timeadj = 60;  
  else  %1 - rasing exp: 
    timeadj = 1;
  end  
     if fitswitch ==1 %single exp -----------
        if rasingfallingswitch ==1 % falling single exp
           y_tau1 = exp(-1)*amp1;
           tau1_sym = timeadj*vpasolve(a*exp(b*x) == y_tau1, x);
           tau1 = double(tau1_sym);
        else    %raising single exp
          y_tau1 = (1-exp(-1))*amp1;
          tau1_sym = timeadj*vpasolve(a*(1-exp(b*x)) == y_tau1, x);
          tau1 = double(tau1_sym);
        end 
        
    else % double exp  ---------------  
      if (toggle==0), %toggle ==0
        if rasingfallingswitch ==1  %falling double exp
           y_tau1 = exp(-1)*amp1; 
           y_tau2 = exp(-1)*amp2; 
           tau1_sym = timeadj*vpasolve(a*exp(b*x) == y_tau1, x);
            try
               tau2_sym = timeadj*vpasolve(c*exp(d*x) == y_tau2, x);
            catch
               tau2_sym = 0;
            end
        
        else %raising double  
           y_tau1 = (1-exp(-1))*amp1;
           y_tau2 = (1-exp(-1))*amp2;
           %y_tau2 = (1-exp(-1))*lifetime_changes_short(1); 
           tau1_sym = timeadj*vpasolve(timeadj*a*(1-exp(b*x)) == y_tau1, x);
           try
            tau2_sym = timeadj*vpasolve(timeadj*c*(1-exp(d*x)) == y_tau2, x);
           catch
            tau2_sym = 0;
           end
       end
        
    else %toggle ==1
       if rasingfallingswitch ==1  %falling double exp 
           y_tau1 = exp(-1)*amp1; 
           y_tau2 = exp(-1)*amp2; 
           tau1_sym = timeadj*vpasolve(c*exp(d*x) == y_tau1, x);
           try
           tau2_sym = timeadj*vpasolve(a*exp(b*x) == y_tau2, x);
           catch
           tau2_sym = 0;
           end
           
       else %rasing double exp 
           y_tau1 = (1-exp(-1))*amp1;
           y_tau2 = (1-exp(-1))*amp2;
           tau1_sym = timeadj*vpasolve(c*(1-exp(d*x)) == y_tau1, x);
         try
            tau2_sym = timeadj*vpasolve(a*(1-exp(b*x)) == y_tau2, x);
         catch
            tau2_sym = 0;
         end 
       end   
     end
     tau2 = double(tau2_sym);
     tau1 = double(tau1_sym);
    end