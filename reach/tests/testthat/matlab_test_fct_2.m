function [varargout] = matlab_test_fct_2(in)
	nr_out = nargout;

	varargout = cell(1, nr_out);


	for(k=1:nr_out)
		varargout{k} = k*in;
	end



end