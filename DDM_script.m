% Provide parameters
pxsz = (0.05E-3/160.) %image pixel size in m/px
limit_t=300; %limit on iterations for determining the power spectrum D(q,t)-D(q,t+deltaT)(inner loop)
%timesteps=round(linspace(1,15,9)); %time steps (deltaT) to be computed (outer loop)
%timesteps=unique(round(exp(0:0.1:log(500))));
timesteps=1:5:999;

%% DON'T CHANGE ANYTHING FROM HERE

% filein = 'E:\path\to\Spooled files.sifx'

format long;
clc;
close all;

%% program code
    [ path, parameters] = DDM_openfile(filein);
    %parameters = {signal, fsize, width, height, cycle_time, no_frames}
if any(timesteps>parameters{6})
    ME = MException('MyComponent:noSuchVariable', 'timesteps vector wrong, exceed max number of frames');
    throw(ME);
end
    doplot = round(linspace(ceil(size(timesteps,2))*0.1,size(timesteps,2)*0.9,4));
    ISF = figure, cnt=0;
    
    metad = header(0);
    msg = sprintf('File Info for: %s\n%i frames with %ix%i\n',filein, parameters{6}, parameters{3}, parameters{4});
    msg2 = sprintf('%s %s\n', metad{6}, metad{4}, metad{7:8}, metad{9:10}, metad{19:20});
    mb = msgbox(char(msg,msg2), 'DDM calculation started', 'help');
    
    
    %if the image is not a square crop it
    if parameters{3}~=parameters{4}
            smallerdim=min(parameters{3}, parameters{4});  %length of smaller dimension
    end                                
    
    
    DDM = []; %initialize ddm output var
    wb = waitbar(0,sprintf('Start processing ... '), 'Name','Progress'); %show waitbar
    avgframes=parameters{6}-timesteps;  %use maximum iteartions for inner loop (max frames-timestep)
   
    
for delta=1:size(timesteps,2)      %iteration over deltaT
    dt=timesteps(delta)*parameters{5};  %dt is the real time step in ms, depending on fps(parameters{5}=cycle_time)
    waitbar((delta/size(timesteps,2)),wb,sprintf('Processing loop %i of %i (\\Deltat= %.2d s)', delta, size(timesteps,2), dt));
    
    sumPS =0; %initialize summedPowerSpectrum variable
    divisor=avgframes(delta); %to normalize the avgPS later
    
    for k=0:avgframes(delta)
        %limit inner iteration
        if k>limit_t
            divisor=k-1; %take correct normalization divisor into account
        	break
        end
        %get frames and claculate difference image
        Di_r = DDM_grabframe(k+delta,parameters{1:4})-DDM_grabframe(k,parameters{1:4}) ;       
        %calculate power spectrum for difference image
        if parameters{3}~=parameters{4} % check whether width==height
            Fd_q = abs(fftshift(fft2(Di_r(1:smallerdim, 1:smallerdim))));
        else
            Fd_q = abs(fftshift(fft2(Di_r)));
        end
        %fft not normalized by size
        %sum up power spectra for different t but same \delta t
        sumPS = sumPS+Fd_q.^2; 
    end
    


    %normalize PSD
    avgPS = sumPS./divisor;
    %exclude artifical values near center (with q~0)
    [avgEXCNT, ~] = DDM_excnt(avgPS,1);
    %calculate radial average over q
    [PS, q] = DDM_radialavg(avgEXCNT, floor(parameters{3}/2));
    %save Power spectrum and step
    DDM(:, delta)=PS;
% Each column in DDM represents as a function of q at a fixed time step dt;
% each row represents D(q,dt) as a function of time step dt at a fixed q. 
    
    %plot image strcuture function D(q,dt)
    if ismember(delta,doplot)
        cnt=cnt+1;
        figure(ISF), subplot(2,2,cnt), imshow(mat2gray(avgEXCNT)), title(sprintf('\\Deltat = %.2d s',dt));
        %(parameters{5}=cycle_time)
    end
        
end
delete(wb);

%calculate lag time and q in real units
realdt = timesteps*parameters{5}; %dt are the real time steps in s depending on fps! (parameters{5}=cycle_time)
sz = min(parameters{3}, parameters{4}); %get side length of image in px 
realq = (0:(sz-1)/2)*2*pi/(sz*pxsz); %in 1/um. because of radial avg only q along one half of the image
%plot a few D(q,dt)
DDM_plot(DDM, realq, realdt);

atsif_closefile();
mb = msgbox('DDM calculation completed', 'DDM calculation successful', 'Success');


