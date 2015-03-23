clear all
close all
clc

% add these folders to your MATLAB path so MATLAB knows to look for
% the codes here.
addpath('/Users/dmikessell/GIT/MITcorrelations/matlab');
addpath('/Users/dmikessell/GIT/MITcorrelations/matlab/external');

% load a test matrix
load('/Users/dmikessell/workspace/IRIS/JulianDayData/julDay_1152.mat');
% These data come into MATLAB as WAVEFORM objects. This way they
% contain all the META-information we need. If you have not done so
% already, go to this website and check out this code with svn:
% https://code.google.com/p/gismotools/source/checkout
% SVN is like GITHUB, but the old version. If you do not want to use
% SVN, you can simply download this toolbox and add it to your MATLAB
% path, after you save it somewhere on your machine. All of the codes
% are buuilt on this WAVEFORM object. Plus this toolbox offers some
% useful plotting and processing tools for passive seismic data.



%% setup the correlation output structure

outputDirectory = './output_test';

% make directory for output of the correlations
[success,message,messageID] = checkOutputDir(outputDirectory);
        
%% plot to see raw data

C = correlation(W);
plot(C);

%% remove any blank traces

blankIdx    = ( sum(double(W),1) == 0 ); % find blank traces
W(blankIdx) = []; % remove blank traces

%% frequency filter data

fmin = 0.1; % low-cutt of filter (Hz)
fmax = 1.0; % high-cut of filter (Hz)
btord = 3; % number of poles in Butterworth filter

Filt   = filterobject('B',[fmin,fmax],btord); % create a frequency filter for waveform
W_filt = filtfilt(Filt,W); % apply the filter to the data 

% plot to see what filter has done to data
C = correlation(W_filt);
figure;
plot(C);

%% remove spikes in data

% This routine divides the time series up in to window and checks for
% spike using an energy test. If the maximum energy in the time
% exceeds a ratio computed by std. deviation of the energy in the
% window, the window, and the precedding window, are set to zero.

windowMin = 60*4; % window lenght (min)
Nstd = 20; % threshold for determining whether or not a spike.

W_rsp = RemoveSpikesWaveform2(W,windowMin,Nstd);

% another option is to use the Earthquake catalogue or the despike.m
% routine used in Acoustic Doppler Velocimetry that I found buried in
% the gismotools package. I am sure that there are many clever
% algorithms out there for despiking data.

% plot to see what has happened because of removespikes
C = correlation(W_rsp);
figure;
plot(C);

%% Preprocess data

% In this section, we need to despike the data and determine whether
% or not we will 'whiten' the data. If we whiten, we need to choose
% the method for whitening.

FB = [0.1, 1];
W_whiten = WhitenWaveform(W,FB);

%% Crosscorrelate all combinations for data, output saved to outputDirectory

% We do this by first computing the frequency domain data that we need.

% Next we do a double loop over all possible stations implemented in
% parallel.

smoothMethod = 'taper'; % can be 'taper' or 'median'
Wn = 3;
K = 2*Wn-1;
windowMin = 60*4; % window length (min)
overlapPercent = 50;

C = runDayCorrelations(W,windowMin,overlapPercent,smoothMethod,Wn,K,outputDirectory);


%% Postprocess the correlations

% Here we stack the data using different  methods


