function paramsvec = tfeLSDIndivParamsToVec(indivParams)
% Convert the LSD parameter structure array to one long vector
%
% Syntax:
%    paramsvec = tfeLSDParamsToVec(indivParams)
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
        paramsvec = [paramsvec ; [indivParams(ii).lambda indivParams(ii).exponent]'];
    end
end