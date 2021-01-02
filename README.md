# Signal Power Spectrum Density Plotter

## Description
A script used to compare the PSD of M-PAM binary signals with different pulse shapes.
This program was designed as part of the ENEL422 Communication Systems Assignment.

## Author
+ Matt Blake

## License
Added an [MIT License](LICENSE)

## Configuration
The behavior of this program (such as the input signal parameters) is controlled by changing the following constants:
```MATLAB
%% Define values of system 
Rb = 1*10^6; % The required maximum data rate (bps)
M = 4; % Order of PAM
R0 = 5; % Zeroth autocorrelation coefficient
Bt = [300000, 350000, 400000, 450000]; % Signal bandwidth
XrangeSquare = 15*10^5; % Square PSD will be plotted from (-XrangeSquare + 1) to +XrangeSquare (Hz)
XrangeNyquist = 6*10^5; % Square PSD will be plotted from (-XrangeNyquist + 1) to +XrangeNyquist (Hz)
channelBandlimit = 5*10^5; % Bandwidth limitations of channel (Hz)
Xstep = 100; % Resolution of PSD plot (Hz)
```

## Contact
If you encounter any issues or questions with the preprocessing, please contact 
Matt Blake by email at matt.blake.mb@gmail.com
