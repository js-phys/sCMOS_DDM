function [ output_args ] = DDM_plot( DDMin, realq, realdt)
%DDMPLOT Plot the resulting DDM data
%
% Each column in DDM represents the image structure function D(q,dt) as a function of q at a fixed dt.
% Each row in DDM represents D(q,dt) as a function of dt at a fixed q;. 
one = figure;
totaldt=round(size(DDMin,2)*0.9);
for i=1:4
    subplot(2, 2, i);
    fordt=round(totaldt/i);
    %plot(DDMin(:,fordt));
    semilogx(DDMin(:,fordt));
    title(sprintf('\\Deltat = %.2f',realdt(fordt)));
    ylabel('D(q,dt)');
    xlabel('q [px]');
end

two = figure;
totalq=round(size(DDMin,1)*0.9);
for i=1:4
    subplot(2, 2, i);
    forq=round(totalq/i);
    %plot(realdt, DDMin(forq,:));
    semilogx(realdt, DDMin(forq,:));
    title(sprintf('q = %.2f [\\mum^-^1]',realq(forq)*1E-6));
    ylabel('D(q,dt)');
    xlabel('dt [s]');
end

end

