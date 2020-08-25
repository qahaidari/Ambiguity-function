%% Plotting the optimum configuration out of genetic optimization %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% taking an optimum configuration from a saved .mat file

% optimconfig = load('optim_config_mimoRP.mat');
% xT_steps = optimconfig.xT_steps;
% xT1=xT_steps(1); xT2=xT_steps(2); xT3=xT_steps(3); xT4=xT_steps(4); 
% xR_steps = optimconfig.xR_steps;
% xR1=xR_steps(1); xR2=xR_steps(2); xR3=xR_steps(3); xR4=xR_steps(4);
% xRP_steps = optimconfig.xRP_steps;
% xRP1=xRP_steps(1); xRP2=xRP_steps(2);

%% entering an optimum configuration manually
xT1 = 0; xT2 = 10; xT3 = 20; xT4 = 26; xT_steps = [xT1,xT2,xT3,xT4];
xR1 = 32; xR2 = 45; xR3 = 60; xR4 = 69; xR_steps = [xR1,xR2,xR3,xR4];
xRP1 = 100; xRP2 = 200; xRP_steps = [xRP1, xRP2]; 

%% calculating AF function and fitness value of the given configuration
params

xT_mm = [xT1*d xT2*d xT3*d xT4*d].'; % position vector of given MIMO Tx antenna configuration
xR_mm = [xR1*d xR2*d xR3*d xR4*d].'; % position vector of given MIMO Rx antenna configuration
xnetwork = [xT1*d 2*xRP1*d 2*xRP2*d].'; % position vector of network containing positions of sensor and doubled positions of 2 repeaters
                 
a_theta_i = (exp(1i*k*kron(sind(theta_i),xT_mm)));
b_theta_i = (exp(1i*k*kron(sind(theta_i),xR_mm)));
network_theta_i = (exp(1i*k*kron(sind(theta_i),xnetwork)));
y_theta_i = zeros(size(a_theta_i,1)*size(b_theta_i,1)*size(network_theta_i,1), size(a_theta_i,2));
for bb = 1:size(a_theta_i, 2)
    y_theta_i(:,bb) = kron( kron(a_theta_i(:,bb), b_theta_i(:,bb)) , network_theta_i(:,bb) );
end

y_theta_j = y_theta_i;
norm_yi = vecnorm(y_theta_i); % returns the norm of each column of y_theta_i
norm_yj = vecnorm(y_theta_j); % returns the norm of each column of y_theta_j
AF1 = abs( ( (y_theta_i)' * y_theta_j ) ); % now each column refers to one degree of y_theta_i and each row refers to one degree of y_theta_j
AF2 = ( (norm_yi)' * (norm_yj) );
AF = AF1 ./ AF2; % elementwise division gives us AF matrix

% extracting diagonal line of AF matrix
diag_vec_whole = diag(flipud(AF)).';

% Taking only half of diagonal line
center_index = floor( length(diag_vec_whole)/2 ) + 1;
diag_vec_half = diag_vec_whole(center_index:end); 

% waiting until min correlation happens after degree 0 and record its index
Atemp = diag_vec_half(1);
i = 2;
while diag_vec_half(i) < Atemp
    Atemp = diag_vec_half(i);
    i = i+1;
end

count = 1/resolution; % number of sweep points for degrees less than 1
[A,Aind] = max( diag_vec_half(i:ceil(count)) ); % max correlation outside the main lobe area and less than degree 1

% calculating AFR on the right side of degree position where A happens or after degree 1   
switch AFRight_method
    case {'afterA'}
        RightCount = 0;
        AFRight = diag_vec_half(Aind+2);
        while AFRight < AF_thres
            RightCount = RightCount + 1;
            AFRight = diag_vec_half(Aind+2+RightCount);
        end
    case {'after1'}
        RightCount = 0;
        AFRight = diag_vec_half(floor(count)+2);
        while AFRight < AF_thres
            RightCount = RightCount + 1;
            if (floor(count)+2+RightCount)>length(diag_vec_half)
                break
            end
            AFRight = diag_vec_half(floor(count)+2+RightCount);
        end
end

RightCriteria = RightCount * resolution; % in degrees
                
fitness = RightCriteria + alpha_factor*(1/(A)); % RightCriteria represents ambiguity free region and A represents maximum sidelobe level
                
%% Plotting diagonal line
figure(43000)
clf
subplot(2,2,1)
plot([0:resolution:50],diag_vec_half,'-')
title({'AF values over diagonal line';['Thres: ', num2str(AF_thres), ' | AFRight: ',num2str(RightCriteria)]; ['A: ',num2str(A), ' | Fitness: ',num2str(fitness), ' | Alpha: ', num2str(alpha_factor)]})
xlabel('degrees'); ylabel('AF values');
                
%% Plotting AF matrix
figure(42000)
clf
title({['Thres: ', num2str(AF_thres), ' | Fitness: ', num2str(fitness), ' | A: ', num2str(A)];['Alpha: ', num2str(alpha_factor)]})
hold on;
surf((-50:resolution:50), (-50:resolution:50), AF, 'EdgeColor', 'None');               
xlim([-50 50])
ylim([-50 50])
view(0,90)
                
%% drawing MIMO and RP elements positions
figure(44000)
%clf
stem(xT_steps,ones(length(xT_steps)),'v','r'); hold on;
stem(xR_steps,ones(length(xR_steps)),'v','b'); hold on;
stem(xRP_steps,ones(length(xRP_steps)),'v','g'); hold on;
title('Array')
xlim([-5 xRP2+5]) 
ylim([0 2])
%% drawing total network aperture
figure(45000)
%clf
MIMO_aper = [xT_steps(1)+xR_steps,xT_steps(2)+xR_steps,xT_steps(3)+xR_steps,xT_steps(4)+xR_steps]
RP1_aper = [MIMO_aper + 2*xRP1]
RP2_aper = [MIMO_aper + 2*xRP2]
stem(MIMO_aper,ones(length(MIMO_aper)),'v','r'); hold on;
stem(RP1_aper,ones(length(RP1_aper)),'v','b'); hold on;
stem(RP2_aper,ones(length(RP2_aper)),'v','g'); hold on;
title('Total aperture')
xlim([0 2*xRP2+MIMO_aper(end)+20]) 
ylim([0 2])