function indivParams = tfeIndivInitParams(obj)
% Initialize the NR parameter struct array
%
% Syntax:
%    NRParams = tfeIndivInitParams(nDirections)     
%
% Description
%    Set up struct array of exp. decay parameters for the given number of
%    directions.
%
% Inputs:
%    nDirections     - Number of color directions.
%
% Outputs:
%    NRParams        - Struct array of parameters.  Fields are:
%                         amplitude - Max amplitude (default 1)
%                         minLag - minimum lag (default 0.25)
%                         scale - scaling of the input contrast (default 1.5)                    
%
% Optional key/value pairs:
%    None.
%
% See also: tfeNRParamsToVec, tfeNRVecToParams
%

% History:
%   04/15/22  mab  Header comments.

% Reasonable defaults
amplitude = 1;
minLag = 0.250;
scale = 1.5;


% Set up the struct array
for ii = 1:obj.nDirections
    indivParams(ii).amplitude = amplitude;
    indivParams(ii).minLag = minLag;
    indivParams(ii).scale = scale;
end

end