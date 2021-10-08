function [ avgEXCNT, avgNAN ] = DDM_excnt( avgPS, stripsize)
%EXCLUDECENTER Excludes the center of a matrix
%
% exclude artificially high values near center (with q~0)
% stripsize is the number of cols and rows, which are going to be set to zero
% Suppressing artificially large intensities in the center image %%

%avgPS must be of square size!!

mid = floor(size(avgPS,1)/2);

            avgPS(mid-stripsize:mid+stripsize, :) = 0;
            avgPS(:, mid-stripsize:mid+stripsize) = 0;
            avgEXCNT  = avgPS;
            
            avgNAN  = avgPS;
            
            avgNAN(mid-stripsize:mid+stripsize, :) = nan;
            avgNAN(:, mid-stripsize:mid+stripsize) = nan;

end

