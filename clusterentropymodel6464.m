
polartheta=45;
polarrY=sin(polartheta/180*pi);
polarrX=cos(polartheta/180*pi);
Hx=abs(polarrX);
Hy=abs(polarrY);
M=64;N=64;
S=tiling_countsets2(M, N);
tic
T2_all=4;
T4_all=16;

T8_all=64;
T16_all=256;


T2_num=length(S.t2x2.areas);

T4_num=length(S.t4x4.areas);

T8_num=length(S.t8x8.areas);
T16_num=length(S.t16x16.areas);

x=binvar(M*N,1,'full');
y2=binvar(T2_num,T2_all,'full');
y20=binvar(T2_num,1,'full');

y4=binvar(T4_num,T4_all,'full');
y40=binvar(T4_num,1,'full');

y8=binvar(T8_num,T8_all,'full');
y80=binvar(T8_num,1,'full');

y16=binvar(T16_num,T16_all,'full');
y160=binvar(T16_num,1,'full');

Constraints=[];
Constraints=[Constraints,sum(x)/(M*N)<=Hy/(Hx+Hy)+0.001];
Constraints=[Constraints,sum(x)/(M*N)>=Hy/(Hx+Hy)-0.001];

%%%求出每一列有多少个中心的约束

shuzu_T2max=ones(1,T2_all);
for i=1:T2_all
    shuzu_T2max(1,i)=i;
end
shuzu_T4max=ones(1,T4_all);
for i=1:T4_all
    shuzu_T4max(1,i)=i;
end

shuzu_T8max=ones(1,T8_all);
for i=1:T8_all
    shuzu_T8max(1,i)=i;
end
shuzu_T16max=ones(1,T16_all);
for i=1:T16_all
    shuzu_T16max(1,i)=i;
end


for i=1:T2_num
        subnumber=S.t2x2.areas(i);
        Constraints=[Constraints,sum(shuzu_T2max.*y2(i,:))==sum(x(S.t2x2.linset(i,1:subnumber)))];
end
for tt=1:T2_num
    Constraints=[Constraints,sum(y2(tt,:))+ y20(tt)==1];
end

for i=1:T4_num
        subnumber=S.t4x4.areas(i);
        Constraints=[Constraints,sum(shuzu_T4max.*y4(i,:))==sum(x(S.t4x4.linset(i,1:subnumber)))];
end
for tt=1:T4_num
    Constraints=[Constraints,sum(y4(tt,:))+ y40(tt)==1];
end
for i=1:T8_num
        subnumber=S.t8x8.areas(i);
        Constraints=[Constraints,sum(shuzu_T8max.*y8(i,:))==sum(x(S.t8x8.linset(i,1:subnumber)))];
end
for tt=1:T8_num
    Constraints=[Constraints,sum(y8(tt,:))+ y80(tt)==1];
end

for i=1:T16_num
        subnumber=S.t16x16.areas(i);
        Constraints=[Constraints,sum(shuzu_T16max.*y16(i,:))==sum(x(S.t16x16.linset(i,1:subnumber)))];
end
for tt=1:T16_num
    Constraints=[Constraints,sum(y16(tt,:))+ y160(tt)==1];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Objective %%%%%%%%%

shuzu2=repmat(shuzu_T2max,T2_num,1);
shuzu4=repmat(shuzu_T4max,T4_num,1);
shuzu8=repmat(shuzu_T8max,T8_num,1);
shuzu16=repmat(shuzu_T16max,T16_num,1);

Objective1 =sum(sum(shuzu2./(S.t2x2.areas).*log2(shuzu2./(S.t2x2.areas)).*y2));

Objective2 =sum(sum(shuzu4./(S.t4x4.areas).*log2(shuzu4./(S.t4x4.areas)).*y4));

Objective8 =sum(sum(shuzu8./(S.t8x8.areas).*log2(shuzu8./(S.t8x8.areas)).*y8));

Objective16 =sum(sum(shuzu16./(S.t16x16.areas).*log2(shuzu16./(S.t16x16.areas)).*y16));

Objective=(Objective1 +Objective2+Objective8+Objective16);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
options = sdpsettings('solver','gurobi');
options.gurobi.TuneTimeLimit=0;
options.gurobi.MIPGap=1e-2;
% [B,L,U] = boundingbox(Constraints,options,x)
% Solve the problem
sol = optimize(Constraints,Objective,options);

if sol.problem == 0
    % Extract and display value
    solution = value(x);
else
    display('Hmm, something went wrong!');
    sol.info
    yalmiperror(sol.problem)
end

solution = value(x);
toc
pps=1:64;
for pp=64:-1:1
    if ismember(pp, [1,16,32,48,64])
        pps(pp)=[];
    end
end
figure
h = heatmap(reshape(solution,M,N))
h.XDisplayLabels([2	3	4	5	6	7	8	9	10	11	12	13	14	15	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	33	34	35	36	37	38	39	40	41	42	43	44	45	46	47	49	50	51	52	53	54	55	56	57	58	59	60	61	62	63]) = {''}; 

h.YDisplayLabels([2	3	4	5	6	7	8	9	10	11	12	13	14	15	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	33	34	35	36	37	38	39	40	41	42	43	44	45	46	47	49	50	51	52	53	54	55	56	57	58	59	60	61	62	63]) = {''}; 

R=R_calcu(solution,M,N);