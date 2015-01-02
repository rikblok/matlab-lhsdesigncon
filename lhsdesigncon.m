function X = lhsdesigncon(n,p,lb,ub,isexp,A,b,varargin)
%LHSDESIGNCON Generate an NxP latin hypercube sample with bounds
%   and linear constraints and optional exponential distribution.
%   X=LHSDESIGNCON(N,P,LB,UB,ISEXP) generates a latin hypercube sample X
%   containing N values on each of P variables.  For each column, if ISEXP
%   is FALSE the N values are randomly distributed with one from each
%   of N intervals, between LB and UB, of identical widths (UB-LB)/N, and
%   they are randomly permuted.  For columns with ISEXP=TRUE, the logarithm
%   of the intervals have identical widths.
%
%   X=LHSDESIGNCON(...,A,b) generates a latin hypercube sample subject to 
%   the linear inequalities A*x ? b. 
%
%   X=LHSDESIGNCON(...,'PARAM1',val1,'PARAM2',val2,...) specifies parameter
%   name/value pairs to control the sample generation.  See LHSDESIGN for 
%   valid parameters.
%
%   Latin hypercube designs are useful when you need a sample that is
%   random but that is guaranteed to be relatively uniformly/exponentially
%   distributed over each dimension.
%
%   Example:  The following command generates a latin hypercube sample X
%             containing 10000 values for each of 2 variables.  The first
%             variable is uniformly sampled between -100 and +100, the
%             second is exponentially sampled between 10^-1 and 10^2 (ie.
%             the exponent is uniformly sampled between -1 and 2).
%             Additionally, the samples satisfy the constraints 
%             X(1) + X(2) <= 50 and X(2) - X(1) >= 25.
%
%      A = [1, 1; 1, -1]; b = [50; -25]; % A x <= b
%      x = lhsdesigncon(10000,2,[-100 1e-1],[100 1e2],[false true],A,b);
%      % Show samples are well distributed within constraints.
%      figure;
%      semilogy(x(:,1),x(:,2),'.');
%
%   Requires lhsdesignbnd.
%
%   See also LHSDESIGN, LHSDESIGNBND.

%   Release History:
%   2015-01-01
%   * initial release

%     Copyright (c) 2014, Rik Blok (rik.blok@ubc.ca)
%     All rights reserved.
% 
%     Redistribution and use in source and binary forms, with or without
%     modification, are permitted provided that the following conditions are met:
% 
%     1. Redistributions of source code must retain the above copyright notice, this
%        list of conditions and the following disclaimer. 
%     2. Redistributions in binary form must reproduce the above copyright notice,
%        this list of conditions and the following disclaimer in the documentation
%        and/or other materials provided with the distribution.
% 
%     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
%     ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
%     WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
%     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
%     ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
%     (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
%     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
%     ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
%     (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
%     SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
%     The views and conclusions contained in the software and documentation are those
%     of the authors and should not be interpreted as representing official policies, 
%     either expressed or implied, of the FreeBSD Project.

% Defaults
if nargin < 7,  b = [];                     end
if nargin < 6,  A = [];                     end
if nargin < 5,  isexp = false(size(lb));    end

% Error traps.
% error trap to see if Ax <= b true for any x in [lb,ub]?

nkeep = 0;
samples = n;

while nkeep < n
    % Generate new X's.  Can't reuse any old X values because distribution
    % depends on number of samples.
    X=lhsdesignbnd(samples,p,lb,ub,isexp,varargin{:}); % (samples x p)
    % check bounds
    if ~isempty(b)
        bsample = b(:,ones(1,samples)); % blen x samples
        keep = all(A*X' <= bsample);   % 1 x samples
    else
        keep = true(samples,1); % keep 'em all
    end
    % count keep
    nkeep = sum(keep);
    % done?
    if nkeep >= n
        % done. Remove rejected samples
        X = X(keep,:);
    else
        % not done. Increase sample size and try again
        if nkeep == 0
            warning('None of %d samples fit constraints.',samples);
            samples = 20 * samples;
        else
            % new sample size = 1..20 x old sample size
            % oversample by 10% to increase chance of sufficient samples
            samples = ceil(min([20 1.1*n/nkeep]) * samples);
        end
    end
end
% remove excess
X = X(1:n,:); % n x p

end
