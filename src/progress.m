function progress(k,init_k,final_k,step,str)
% function progress(k,init_k,final_k,step,str)
%
% Displays progress of a loop, and estimated time remaining.
% The output has the form:
%     k out of K 'string'. Time remaining [] min
%
% INPUTS:
%   k: loop index
%   init_k: initial value of k in loop
%   final_k: final value of k in loop
%   step: increment of loop index
%   str: string relevant to loop
%
% EXAMPLE:
%  for i = 10:100 %for all i values
%      progress(i,10,100,2,'i value');
%  end
%
% EXAMPLE OUTPUT:
%  10 out of 100 i value. Time remaining: NaN min
%  12 out of 100 i value. Time remaining: 0.0018333 min
%  14 out of 100 i value. Time remaining: 0.0031738 min
%  16 out of 100 i value. Time remaining: 0.0027125 min
%   
%
%Author: Dimitrios Pantazis, USC


if k == init_k
    tic
    tremaining = NaN;
else
    try %if tic did not run, then it will produce an error
        t = toc;
        tremaining = t*(final_k-k)/k/60;
    end
end

if(rem(k,step)==0) disp([num2str(k) ' out of ' num2str(final_k) ' ' str '. Time remaining: ' num2str(tremaining) ' min']); end
drawnow
