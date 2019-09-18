% Given margin, risk limit and N, this script generates the total risk 
% and risk schedule of various B-square audits, each represented by an 
% array of sample sizes, n, and an array of kmin of the same length. 
% The script also generates the schedule of stopping probabilities 
% for the given margin. 
%
% Currently the two types of B-square audits are BRAVO and BRAVO-like 
% (BRAVO without replacement). The script generates n and kmin from 
% functions BSquareBRAVOkminMany and BSquareBRAVOLikekminMany, and then 
% the risk schedule and stopping probabilities from BSquareRisksMany. 
%
%------------
%
%Input: 
%   margin:         array of fractional margins
%   alpha:          array of fractional risk limits
%   N:              array of total votes cast for two candidates
% Types of audits: BRAVO and BRAVO-like, with BRAVO being first. 
%
%----------
%
% For each combination of elements in the above arrays, the script
% generates:
%   n:              array of sample sizes, beginning with the first one 
%                       where it is possible to stop the audit (k=n). 
%   kmin:           array of minimum values of k; jth  value is the minimum 
%                       number of votes for winner required to terminate 
%                       an audit with sample size n(j). 
%   risk:           array of individual risk values. jth value is the 
%                       risk (or stopping prob.) of the round with sample 
%                       size n(j)
%
%--------
%
% Output Values
%   Each is an array of size: 
%   number of types of audits X size(margin,2) X size(alpha,2) X size(N,2)
%	RiskValue:                  the total risk, computed as the sum of all 
%                                   values of risk(j)
%	StopProb:               the total stopping probability, should 
%                                   be one for BRAVOLike, sanity check
%	ExpectedBallotsIncorrect:	expected number of ballots examined when 
%                                   outcome is incorrect. Sanity check. 
%                                   Should be larger than (1-risk-limit)*N 
%   ExpectedBallotsCorrect:     expected number of ballots for given 
%                                   margin when outcome is correct. 
%
%   Also outputs two lists of size 
%   number of types of audits X size(margin,2) X size(alpha,2) X size(N,2)
%   each list element is an array of the size of the corresponding array n
%   RiskSched:                  the risk schedule, corresponding to the 
%                                   variable "risk" above, for zero margin
%   StopSched:                  the schedule of stopping probabilities, 
%                                   corresponding to the variable "risk" 
%                                   above, for the corresponding margin
%

margins = [0.1, 0.16, 0.2, 0.3, 0.4];
margin_incorrect = zeros(1,size(margins,2));
alpha = [0.05, 0.1];
N = [1000];

%--------------BRAVO------------%
[nBRAVO, kminBRAVO] = BSquareBRAVOkminMany(margins, alpha);
[StopSched(1,:,:,:), StopProb(1,:,:,:), ExpectedBallotsCorrect(1,:,:,:)] = BSquareRisksMany(margins, alpha, N, nBRAVO, kminBRAVO, 0);
[RiskSched(1,:,:,:), RiskValue(1,:,:,:), ExpectedBallotsInCorrect(1,:,:,:)] = BSquareRisksMany(margin_incorrect, alpha, N, nBRAVO, kminBRAVO, 0);

%--------------BRAVOLike------------%
[nBRAVOLike, kminBRAVOLike] = BSquareBRAVOLikekminMany(margins, alpha, N);
[StopSched(2,:,:,:), StopProb(2,:,:,:), ExpectedBallotsCorrect(2,:,:,:)] = BSquareRisksMany(margins, alpha, N, nBRAVOLike, kminBRAVOLike, 1);
[RiskSched(2,:,:,:), RiskValue(2,:,:,:), ExpectedBallotsInCorrect(2,:,:,:)] = BSquareRisksMany(margin_incorrect, alpha, N, nBRAVOLike, kminBRAVOLike, 1);

