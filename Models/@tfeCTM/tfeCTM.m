classdef tfeCTM < tfe
% tfeQCM
%  Create at tfeQCM (Quadratic Color Model) object
%
% Syntax:
%    tfe = tfeQCM(varargin);
% 
% Description:
%     Implements a model that is quadratic in the color contrast of the
%     stimulus.
%
%     Inherits optional key/value pairs from parent class tfe.
%
%     NOTE: Locks described under key/value pairs below not yet
%     implemented.
%
% Inputs:
%    None.
%
% Outputs:
%    obj         - The object.
%
% Optional key/value pairs:
%    'dimension' - The dimension of the ellipsoid. Can be 2 or 3. Default
%                  3.
%    'lockedAngle' - If dimension is 2, this specifies the angle of the
%                    ellipse, and this angle is not searched over. Default
%                    is empty, which means angle is searched over.
%    'lockedCrfAmp' - If value set, this is used as the amplitude of the
%                    Naka-Rrushton function, and that is not searched over.
%                    Default is empty, which means search.
%    'lockedCrfExponent' - If value set, this is used as the exponent of
%                    the Naka-Rushton function, and that is not searched
%                    over. Default is empty, which means search.

%    'lockedCrfSemi' - If value set, this is used as the semi-saturation
%                    constant of the Naka-Rushton function, and that is not
%                    searched over. Default is empty, which means search.

%    'lockedCrfOffset' - If value set, this is used as the offset of
%                    the Naka-Rushton function, and that is not searched
%                    over. Default is empty, which means search.
%
% See also:
%

% History:
%   06/26/16 dhb       Started in on this.
%   08/24/18 dhb, mab  Get key/value dimension pair working.

    % Public, read-only properties.
    properties (SetAccess = protected, GetAccess = public)
        % Specify dimension of cone contrast space.  Can be 2 or 3.
        dimension = 3;
        
        % Specify number of mechanisms.  Can be 1 or 2.
        numMechanism = 1;
        
        % Flag as to whether we are fitting.  For very careful use as a way
        % of communicating when we can save some time during fitting.
        fitting = false;
        stimuli = [];
    end
    
    % Private properties. Only methods of the parent class can set these
    properties(Access = private)
    end
    
    % Public methods
    methods  
    end
    
    properties (Dependent)
    end
    
    % Methods.  Most public methods are implemented in a separate function,
    % but we put the constructor here.
    methods (Access=public)
        % Constructor
        function obj = tfeCTM(varargin)
           
            % Parse input. Need to add any key/value pairs that need to go
            % to the tfe parent class, as well as any that are QCM
            % specific.
            p = inputParser; p.KeepUnmatched = true;
            p.addParameter('verbosity','none',@ischar);
            p.addParameter('dimension',3,@(x) (isnumeric(x) & isscalar(x)));
            p.addParameter('numMechanism',1,@(x) (isnumeric(x) & isscalar(x)));
            p.parse(varargin{:});
            
            % Base class constructor
            obj = obj@tfe('verbosity',p.Results.verbosity);
            
            % Set dimension
            obj.dimension = p.Results.dimension;
            if (obj.dimension ~= 2 & obj.dimension ~= 3)
                error('Can only handle dimension 2 or 3');
            end
            % Set number of mechanisms 
            obj.numMechanism = p.Results.numMechanism;
            if (obj.numMechanism ~= 1 & obj.numMechanism ~= 2)
                error('Can only handle 1 or 2 mechanisms');
            end

        end
    end 
    
    % Get methods for dependent properties
    methods
    end
    
    % Methods may be called by the subclasses, but are otherwise private 
    methods (Access = protected)
    end
    
    % Methods that are totally private (subclasses cannot call these)
    methods (Access = private)
    end
    
end
