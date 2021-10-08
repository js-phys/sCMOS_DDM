function [ path, parameters ] = DDM_openfile( varargin )
%OPENSIFX Open a proprietary .sifx file from an Andor camera (sCMOS)
%
% The .sif or .sfix file format is a proprietary format of Andor cameras.
% The Andor Software Development Kit (SDK) has to be installed, otherwise the atsif_xxx functions are unknown.
 
close all;
clc;

if nargin==0
    [name,path,FilterIndex] = uigetfile({'*.sif;*.sifx','Andor files (*.sif, *.sifx)';},'Open file');
    if (FilterIndex ==0)
        return
    end
else
    [path, name, ending] = fileparts(varargin{1});
    name = strcat(name,ending);
end

%open sifx
signal=0;
rc=atsif_setfileaccessmode(0);
rc=atsif_readfromfile(fullfile(path,name));

if (rc == 22002)
  signal=0;
  [rc,present]=atsif_isdatasourcepresent(signal);
  
  if present %get max number of frames from video and set endframe
    [rc,no_frames]=atsif_getnumberframes(signal);

    %extract metadata, in particular remember fps for later use
    format long;
    [rc,cycle_time] = atsif_getpropertyvalue(signal, 'KineticCycleTime');
        cycle_time = str2double(cycle_time);
    [rc,fsize]=atsif_getframesize(signal);
    [rc,left,bottom,right,top,hBin,vBin]=atsif_getsubimageinfo(signal,0);
    width = ((right - left)+1)/hBin;
    height = ((top-bottom)+1)/vBin;
    
    parameters = {signal, fsize, width, height, cycle_time, no_frames};
  end
end

