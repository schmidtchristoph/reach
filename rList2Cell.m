function [ C ] = rList2Cell( importlist )
% Transforms a R list datatype (which is imported as a struct) to
% a Matlab cell-array. Also recovers/ reformats multi-arrays contained
% in this R list (which are only exported as vectors).
%
% importlist            the imported struct equivalent of the R list,
%                       which was reformated in R using
%                       matlabExportList.R and exported to Matlab using
%                       writeMat() from the R.matlab package
%
%
%
%
%
%
%
% C                     a Matlab cell-array containing in each cell the
%                       corresponding element of the original R list data
%                       (before it was reformated using
%                       matlabExportList.R()); also multi-arrays stored in
%                       the original R list datatype are recovered
%
%           USAGE:
%
% C = rList2Cell(importlist)
%
%
% See also: matlabExportList.R
%
% The MIT License (MIT) (http://opensource.org/licenses/MIT)
% Copyright (c) 2015 Christoph Schmidt

% 21.11.14

C = struct2cell(importlist);





if isequal(C{1},'FORMATLAB')
    na      = fieldnames(importlist);
    C       = C(2:end);
    na      = na(2:end);
    dataind = findrow('21',na); % data start index


    for k=dataind:size(C,1)
        if isvector(C{k}) %migth be a multiarray
            ind = findrow(['1' na{k}(2)],na);

            if ~isequal(C{ind},'NO_MULTI') %it's a multiarray
                d = C{ind}'; % the dimensions needed to reshape the multimatrix
                C{k} = reshape(C{k},d);

            elseif ~ischar(C{k})

                C{k} = double(C{k});
            end
        end
    end


    C = C(dataind:size(C,1));
end








end

