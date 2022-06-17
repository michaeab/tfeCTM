function [lagsFromParams] = tfeCTMIndivForward(paramsMat,contrasts,varargin)
% Compute CTM forward model
%
% Synopsis
%    [responses,quadraticFactors] = tfeCTMIndivForward(params,stimuli)
%
% Description:
%    Take stimuli and compute CTM responses.
%
% Inputs:
%      params        - CTM model parameter struct
%      stimuli       - Stimuli, with stimulus contrasts in columns
%
% Outputs:
%      responses     - Row vector of responses
%

% History:
%   11/09/21  mab   wrote it (from tfeQCM template).


% When paramsToVec is working write a parameter check
% %% Check parameterization
% if (~tfeCTMCheckParams(params))
%     error('Bad values in CTM parameters structure');
% end

p = inputParser; p.KeepUnmatched = true;
p.addRequired('params',@isvector);
p.addRequired('stimuli',@ismatrix);
p.addParameter('dimension',2,@isnumeric);

p.parse(paramsMat,contrasts,varargin{:});
paramsMat = p.Results.params;

%% Get the ellipsoid parameters in cannonical form
dimension   = p.Results.dimension;

nDirections = size(paramsMat,2);

if (dimension == 2)
  for ii = 1:nDirections 
      pcFromParams(:,ii) = 1 - (1 - 0.5).*exp(-(contrasts{ii}./paramsMat(ii).lambda).^paramsMat(ii).exponent);
  end
elseif (dimension == 3)
    error('3 Dimension case to come');
else
    error('Dimension must be 2 or 3');
end






