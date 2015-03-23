clear all
close all
clc

% add these folders to your MATLAB path so MATLAB knows to look for
% the codes here.
addpath('/Users/dmikesell/GIT/MITcorrelations/matlab/');
addpath('/Users/dmikesell/GIT/MITcorrelations/PreProcessingFunctions/');
% addpath('/Users/dmikessell/GIT/MITcorrelations/matlab/external');

% load a test matrix
load('/Volumes/data/IRIS_data/USArray/JulianDayData/julDay_14.mat');

index = 1; % trace to grab

%% remove any blank traces

blankIdx    = ( sum(double(W),1) == 0 ); % find blank traces
W(blankIdx) = []; % remove blank traces

C = correlation(W);
plot(C);


%%

raw = double(W(index));
Fraw = fft(raw);
FrawN = Fraw./max(abs(Fraw));

figure;
plot(fftshift(abs(FrawN)),'b'); 

%% use Dylan's wrapper for blanchmat

fmin = 0.1;
fmax = 1.0;

FB       = [fmin, fmax];
W_whiten = WhitenWaveform(W,FB);

C = correlation(W_whiten);
plot(C);

Wwd  = double(W_whiten(index));

%% use blanchmat

D = double(W(index));
dt = 1/get(W(index),'freq');
 
Dwd = BlanchMat(D,FB,dt);
 
trace = 1:10000;

figure;
plot(Dwd(trace),'b'); hold on;
plot(Wwd(trace),'r--');

%% look at spectrum

npts = numel(Dwd);
fs = get(W(1),'freq');
Fvec = (-npts/2:npts/2-1).*(fs/npts);

tvec = (0:npts-1)./fs;

data = double(W(index));

figure;
subplot(1,2,1)
plot(tvec,Dwd./max(abs(Dwd)),'k'); hold on
plot(tvec,data./max(abs(data)),'--','Color',[0.5 0.5 0.5]);
legend('Whitened','Raw'); legend boxoff;
xlabel('Time (s)'); axis('tight');
ylabel('Normalized Amplitude (a.u.)')
xlim([4900 5000]);

subplot(1,2,2)
% plot(fftshift(abs(FrawN)),'b'); 
plot(Fvec,log10(fftshift(abs(fft(Wwd)))),'k'); hold on;
% plot(fftshift(abs(fft(Dwd))),'ro');
plot(Fvec,log10(fftshift(abs(fft(double(W(index)))))./max(abs(fft(double(W(index)))))),'r','Color',[0.5 0.5 0.5]);
legend('Whitened','Raw'); legend boxoff;
xlim([0.9995 1.0005]); xlabel('Frequency (Hz)');
ylabel('Log_{10} Amplitude (a.u.)'); axis('tight');

%% compare








