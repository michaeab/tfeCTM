function [lagsFromParams] = tfeCTMRotMForward(params,stimuli,varargin)
% Compute CTM forward model
%
% Synopsis
%    [responses,quadraticFactors] = tfeCTMForward(params,stimuli)
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
p.addParameter('numMechanisms',2,@isnumeric);

p.parse(params,stimuli,varargin{:});
params = p.Results.params;

%% Get the ellipsoid parameters in cannonical form
dimension   = p.Results.dimension;
nMechanisms = p.Results.numMechanisms;
if (dimension == 2)
    %The one mechanism model
    if nMechanisms == 1
        R = deg2rotm(params(1));
        E = [1 0; 0 params(2)];
        m_hats = (R*E)'*stimuli;
    elseif  nMechanisms == 2
        R = deg2rotm(params(1));
        E = [1 0; 0 1/params(2)];
        m_hats = (R*E)'*stimuli;
    else
        error('Must be either 1 or 2 mechanisms');
    end
    
    % take the max of the mechanism outputs
    m = vecnorm(m_hats);
elseif (dimension == 3)
    error('3 Dimension case to come');
else
    error('Dimension must be 2 or 3');
end

% Convert mechanism output to lags
lagsFromParams =  params(end-1) +  params(end).* exp(-1*m.*params(3));





