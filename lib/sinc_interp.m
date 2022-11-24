% Ideally "resamples" x vector from s to u by sinc interpolation
function yy = sinc_interp(x,y,xI)
    % Interpolates x samples sampled at "s" instants
    % Output y is sampled at "u" instants ("u" for "upsampled")

    % Find the sampling period of the undersampled signal
    T = x(2)-x(1);
   
    for i=1:length(xI)
%    k= y.*sinc( (1/T)*(xI(i) - x));
%    y( i ) = sum(k);
%      

   yy( i ) = sum( y .* sinc( (1/T)*(xI(i) - x) ) );

     
    end

    % Make sure y is same shape as u (row->row, col->col)
    yy= reshape(yy, size(xI));
end
