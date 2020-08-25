%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculating and plotting the AF of a given antenna configuration %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% positions of antenna elements and repeaters of a given radar-repeater configuration
xT1 = 0; xT2 = 10; xT3 = 20; xT4 = 26; xT_steps = [xT1,xT2,xT3,xT4]; % positions of transmit elements in steps of lambda/2 from origin
xR1 = 32; xR2 = 45; xR3 = 60; xR4 = 69; xR_steps = [xR1,xR2,xR3,xR4]; % positions of receive elements in steps of lambda/2 from origin
xRP1 = 100; xRP2 = 200; xRP_steps = [xRP1, xRP2]; % positions of repeater elements in steps of lambda/2 from origin

%% calculating AF function of the given configuration
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
                                
%% Plotting AF matrix
figure(42000)
clf
title('AF plot')
hold on;
surf((-50:resolution:50), (-50:resolution:50), AF, 'EdgeColor', 'None');               
xlim([-50 50])
ylim([-50 50])
view(0,90)
                
%% drawing MIMO and RP elements physical positions
figure(43000)
stem(xT_steps,ones(length(xT_steps)),'v','r'); hold on;
stem(xR_steps,ones(length(xR_steps)),'v','b'); hold on;
stem(xRP_steps,ones(length(xRP_steps)),'v','g'); hold on;
title('Array')
xlim([-5 xRP2+5]) 
ylim([0 2])
%% drawing total network virtual aperture
figure(44000)
MIMO_aper = [xT_steps(1)+xR_steps,xT_steps(2)+xR_steps,xT_steps(3)+xR_steps,xT_steps(4)+xR_steps] % virtual aperture of radar sensor
RP1_aper = [MIMO_aper + 2*xRP1] % virtual aperture of repeater 1
RP2_aper = [MIMO_aper + 2*xRP2] % virtual aperture of repeater 2
stem(MIMO_aper,ones(length(MIMO_aper)),'v','r'); hold on;
stem(RP1_aper,ones(length(RP1_aper)),'v','b'); hold on;
stem(RP2_aper,ones(length(RP2_aper)),'v','g'); hold on;
title('Total virtual aperture')
xlim([0 2*xRP2+MIMO_aper(end)+20]) 
ylim([0 2])