function R= R_calcu(solution,M,N)
X = reshape(solution,M,N);
% ================= A) 计算 R(p,q) 的 for 循环实现 =================
% 输入：X (M x N, 0/1)
% 输出：R ((2M-1) x (2N-1))，pvec=-(M-1):M-1, qvec=-(N-1):N-1
[M,N] = size(X);
pvec = -(M-1):(M-1);
qvec = -(N-1):(N-1);
R = zeros(length(pvec), length(qvec));

for ip = 1:length(pvec)
    p = pvec(ip);
    % m 范围：使 m 与 m+p 都落在 [1,M]
    m_start = max(1, 1 - p);
    m_end   = min(M, M - p);
    for iq = 1:length(qvec)
        q = qvec(iq);
        % n 范围：使 n 与 n+q 都落在 [1,N]
        n_start = max(1, 1 - q);
        n_end   = min(N, N - q);

        acc = 0;
        for m = m_start:m_end
            mm = m + p; % 1..M（由范围保证）
            for n = n_start:n_end
                nn = n + q; % 1..N
                acc = acc + X(m,n) * X(mm,nn);
            end
        end
        R(ip,iq) = acc; % 非负整数
    end
end



