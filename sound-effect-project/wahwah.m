% wah_wah.m   state variable band pass
% written by Ronan O'Malley
% October 2nd 2005
% 
% BP filter with narrow pass band, Fc oscillates up and down the spectrum
% Difference equation taken from DAFX chapter 2
%
% Changing this from a BP to a BS (notch instead of a bandpass) converts this effect to a phaser
%
% yl(n) = F1*yb(n) + yl(n-1)
% yb(n) = F1*yh(n) + yb(n-1)
% yh(n) = x(n) - yl(n-1) - Q1*yb(n-1)
%
% vary Fc from 500 to 5000 Hz
% 44100 samples per sec

clear all;
close all;

infile = 'acoustic.wav';

% read in wav sample
[x, Fs] = audioread(infile);
N = length(x);

%%%%%%% EFFECT COEFFICIENTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% damping factor
% lower the damping factor the smaller the pass band
damp = 0.05;

% min and max centre cutoff frequency of variable bandpass filter
minf=500;
maxf=3000;

% wah frequency, how many Hz per second are cycled through
Fw = 2000; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% change in centre frequency per sample (Hz)
%delta=0.1;
delta = Fw/Fs;
%0.1 => at 44100 samples per second should mean  4.41kHz Fc shift per sec



% create triangle wave of centre frequency values
Fc=minf:delta:maxf;
while(length(Fc) < length(x) )
    Fc= [ Fc (maxf:-delta:minf) ];
    Fc= [ Fc (minf:delta:maxf) ];
end

% trim tri wave to size of input
Fc = Fc(1:length(x));
plot(Fc);

% difference equation coefficients
F1 = 2*sin((pi*Fc(1))/Fs);  % must be recalculated each time Fc changes
Q1 = 2*damp;                % this dictates size of the pass bands


yh=zeros(size(x));          % create emptly out vectors
yb=zeros(size(x));
yl=zeros(size(x));

% first sample, to avoid referencing of negative signals
yh(1) = x(1);
yb(1) = F1*yh(1);
yl(1) = F1*yb(1);




% apply difference equation to the sample
for n=2:length(x),
    
    yh(n) = x(n) - yl(n-1) - Q1*yb(n-1);
    yb(n) = F1*yh(n) + yb(n-1);
    yl(n) = F1*yb(n) + yl(n-1);
    
    
    F1 = 2*sin((pi*Fc(n))/Fs);
end

%normalise

maxyb = max(abs(yb));
yb = yb/maxyb;

% write output wav files
audiowrite('output_matlab.wav', yb, Fs);
% wavwrite(yb, Fs, N, 'out_wah.wav');

figure(1)
hold on
plot(x,'r');
plot(yb,'b');
title('Wah-wah and original Signal');
