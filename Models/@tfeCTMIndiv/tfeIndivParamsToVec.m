function paramsvec = tfeIndivParamsToVec(indivParams)
% Convert the NR parameter structure array to one long vector
%
% Syntax:
%    paramsvec = tfeNRParamsToVec(indivParams)
%
% Description:
%    Convert vector form of Naka-Rushton parameters for multiple color
%    directions into struct array form.
%
% Inputs:
%    indivParams        - Struct array of parameters.  See
%                      tfeNRInitializeParams for the fields.
%
% Outputs:
%    paramsvec       - Vector form of parameters.
%
% Optional key/value pairs:
%    None.
%
% See also: tfeIndivVecToParams, tfeIndivInitParams
%


% History:
%   04/15/18  mab  Header comments.

    nDirections = length(indivParams);
    paramsvec = [];
    for ii = 1:nDirections
        paramsvec = [paramsvec ; [indivParams(ii).amplitude indivParams(ii).minLag indivParams(ii).scale]'];
    end
end