function [ varargout ] = matlab_test_fct_3( varargin )
	nr_out = nargout;
	nr_in  = nargin;

	for(k = 1:nr_out)
		try
			varargout{k} = varargin{k}*5;
		catch me
			varargout{k} = 99;
		end
	end


end