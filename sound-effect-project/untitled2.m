% 
% Overdrive example simple call of DAFX symclip function

close all;
clear all;

filename='acoustic.wav';

% read the sample waveform
[x,Fs] = audioread(filename);

% Call fuzzexp
gain = 11;
mix = 1; % Hear only fuzz

y = fuzzexp(x,gain,mix);


% write output
audiowrite(y,Fs,'out_fuzz.wav');

figure(1);
hold on
plot(y,'r');
plot(x,'b');
title('Fuzz Signal');

