% Parameters

f0 = 77e9; % 77GHz
c = physconst('LightSpeed');
lambda = c/f0;
d = lambda/2; % spacing between elements
k = 2*pi/lambda; % wavenumber at free space wavelength

resolution = 0.02; % for calculating AF function
theta_i = [-50:resolution:50];

cfg = config(...
    f0,   ...
    c,    ...
    d,    ...
    resolution,  ...
    theta_i);  