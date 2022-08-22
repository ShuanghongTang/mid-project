% file: VX_tstretch_int_pv.m
% from: DAFX matlab 1st edition
%
%===== this program performs time stretching using the phase
%===== vocoder approach, with an integer ratio, with:
%===== win: windows (analysis and synthesis)
%===== lfen is the length of the windows
%===== n1 and n2: steps (in samples) for the analysis and synthesis

clear

file_name = 'author.wav';
file_name_output = 'author_output.wav';

[x, FS] = audioread(file_name);

alpha = 2;  % alpha : time stretch factor (integer for this program)

% ----- parameters ---------
n1   = 16;
n2   = n1 * alpha;
N    = 512;
win  = hanningz(N);   % window
L    = length(x);

% ----- initializations -----
xmax = max(abs(x));
x = [zeros(N, 1); x; zeros(N-mod(L,n1),1)] / xmax;
y = zeros(N+ceil(length(x)*alpha),1);
block = zeros(N,1);

pin  = 0;
pout = 0;
pend = length(x) - N;

while pin < pend
    block = x(pin + (1:N)) .* win;
    
    f     = fft(fftshift(block));
    r     = abs(f);
    phi   = angle(f);
    ft    = r .* exp(1i * alpha * phi);
    block = fftshift(real(ifft(ft))) .* win;
    
    y(pout+(1:N)) = y(pout+(1:N)) + block;
    pin   = pin + n1;
    pout  = pout + n2;
end

%----- listening and saving the output -----
y = y(N+1:end)/max(abs(y));
soundsc(y, FS);
audiowrite(file_name_output, y, FS);
