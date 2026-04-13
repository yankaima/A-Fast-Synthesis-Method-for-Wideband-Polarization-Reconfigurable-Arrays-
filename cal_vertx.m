function vert=cal_vert(solution,M,N)

vert=zeros(sum(sum(solution)),3);
tt=0;
for i=1:M
    for j=1:N
        tt=tt+1;
    if solution(i,j)==1
    vert(tt,:)=[i,j,1];
    else
        vert(tt,:)=[i,j,0];
    end
    end
end