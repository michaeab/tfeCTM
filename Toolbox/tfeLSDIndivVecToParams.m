function [NRParams,nParams] = tfeLSDIndivVecToParams(paramsvec,nDirections)
% Convert the NR parameter vector to struct array
%
% Syntax:
%    [NRParams,nParams] = tfeLSDVecToParams(paramsvec,nDirections)
%
% Description:
%    Convert vector form of Naka-Rushton parameters for multiple color
%    directions into struct array form.
%
% Inputs:
%    paramsvec       - Vector form of parameters.
%    nDirections     - Number of color directions.
%
% Outputs:
%    NRParams        - Struct array of parameters.  See
%                      tfeNRInitializeParams for the fields.
%
% Optional key/value pairs:
%    None.
%
% See also: tfeIndivParamsToVec, tfeIndivInitParams
%

% History:
%   04/16/22  mab  Header comments.
    
    % Number of parameters.  You just have to know this.  Coordinate
    % any changes with the tfeNRParamsToVec routine.
    nParams = 2;
    
    % Unpack vector into struct array.
    for ii = 1:nDirections        
        NRParams(ii).lambda = paramsvec((ii-1)*nParams+1);
        NRParams(ii).exponent = paramsvec((ii-1)*nParams+2);
    end
end