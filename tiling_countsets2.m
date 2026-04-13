function S = tiling_countsets_xy(M, N)

% For each tile (wx,wy), returns:
%   S.t(wx)x(wy).countset        : Kx1 cell, each = [#cells x 2] of (row,col) in row-major
%   S.t(wx)x(wy).coords_padded   : K x (2*wx*wy) numeric, [r1 c1 r1 c2 ...], 0-padded
%   S.t(wx)x(wy).linset          : K x (wx*wy)   numeric, linear indices (column-major), 0-padded
%   S.t(wx)x(wy).areas           : Kx1, area per cluster
%   S.t(wx)x(wy).boxes           : Kx4, [r1 r2 c1 c2] per cluster

    assert(M>=8 && N>=8, 'M,N must be >= 8');

    S.M = M; S.N = N;
    tile_list = [1 2; 2 1;2 2; 3 3; 4 4; 2 4; 4 2;4 8; 8 4;5 5;6 6;8 8;16 16];  % [wx wy] rows

    for t = 1:size(tile_list,1)
        wx = tile_list(t,1);
        wy = tile_list(t,2);

        boxes = ect_boxes_center_first_rect(M, N, wx, wy);   % K x 4
        K = size(boxes,1);

        Lcoords = 2*wx*wy;    
        Llin    = wx*wy;     

        countset       = cell(K,1);          
        coords_padded  = zeros(K, Lcoords);  
        linset         = zeros(K, Llin);     
        areas          = zeros(K,1);

        for k = 1:K
            r1 = boxes(k,1);  r2 = boxes(k,2);
            c1 = boxes(k,3);  c2 = boxes(k,4);

            rows = r1:r2; cols = c1:c2;

            [C,R]  = meshgrid(cols, rows);        % R: (#rows x #cols), C: same
                        R=R.';
            C=C.';
            coords = [R(:), C(:)];            % transpose + (:) -> row-major order

            areas(k)    = size(coords,1);
            countset{k} = coords;


            flat = reshape(coords.', 1, []);      % [r1 c1 r1 c2 ...], length = 2*area
            coords_padded(k, 1:numel(flat)) = flat;


            lin = sub2ind([M, N], coords(:,1), coords(:,2)).';  % 1 x area
            linset(k, 1:numel(lin)) = lin;
        end

        fld = sprintf('t%dx%d', wx, wy);
        S.(fld).countset       = countset;
        S.(fld).coords_padded  = coords_padded;
        S.(fld).linset         = linset;
        S.(fld).areas          = areas;
        S.(fld).boxes          = boxes;
    end
end

function boxes = ect_boxes_center_first_rect(M, N, wx, wy)


    rM = mod(M, wx);  rN = mod(N, wy);      
    T  = floor(rM/2); B = rM - T;           
    L  = floor(rN/2); R = rN - L;           


    m_w = floor((M - T - B)/wx);           
    n_w = floor((N - L - R)/wy);           

    boxes = [];


    for i = 0:m_w-1
        r1 = T + 1 + i*wx;    r2 = r1 + wx - 1;
        for j = 0:n_w-1
            c1 = L + 1 + j*wy; c2 = c1 + wy - 1;
            boxes = [boxes; r1 r2 c1 c2];
        end
    end


    if T > 0
        for j = 0:n_w-1
            c1 = L + 1 + j*wy;  c2 = c1 + wy - 1;
            boxes = [boxes; 1 T c1 c2];
        end
    end
    if B > 0
        for j = 0:n_w-1
            c1 = L + 1 + j*wy;  c2 = c1 + wy - 1;
            boxes = [boxes; M-B+1 M c1 c2];
        end
    end


    if L > 0
        for i = 0:m_w-1
            r1 = T + 1 + i*wx;  r2 = r1 + wx - 1;
            boxes = [boxes; r1 r2 1 L];
        end
    end
    if R > 0
        for i = 0:m_w-1
            r1 = T + 1 + i*wx;  r2 = r1 + wx - 1;
            boxes = [boxes; r1 r2 N-R+1 N];
        end
    end


    if T>0 && L>0, boxes = [boxes; 1        T        1        L]; end
    if T>0 && R>0, boxes = [boxes; 1        T        N-R+1    N]; end
    if B>0 && L>0, boxes = [boxes; M-B+1    M        1        L]; end
    if B>0 && R>0, boxes = [boxes; M-B+1    M        N-R+1    N]; end
end
