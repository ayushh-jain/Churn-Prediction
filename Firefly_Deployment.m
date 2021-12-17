CostFunction=@(x) Rosenbrock(x);
nVar=15;
VarSize=[1 nVar];
VarMin=-10;
VarMax= 10;
io=xlsread('data.xlsx');
[x,y]=size(io);
MaxIt=x;
nPop=y;
gamma=1;
beta0=2;
alpha=0.2;
alpha_damp=0.98;
delta=0.05*(VarMax-VarMin);
m=2;
if isscalar(VarMin) && isscalar(VarMax)
dmax = (VarMax-VarMin)*sqrt(nVar);
else
dmax = norm(VarMax-VarMin);
38
end
firefly.Position=[];
firefly.Cost=[];
pop=repmat(firefly,nPop,1);
BestSol.Cost=inf;
for i=1:nPop
pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
pop(i).Cost=CostFunction(pop(i).Position);
if pop(i).Cost<=BestSol.Cost
BestSol=pop(i);
end
end
BestCost_Hybrid=zeros(MaxIt,1);
for it=1:MaxIt
newpop=repmat(firefly,nPop,1);
for i=1:nPop
newpop(i).Cost = inf;
for j=1:nPop
if pop(j).Cost < pop(i).Cost
rij=norm(pop(i).Position-pop(j).Position)/dmax;
beta=beta0*exp(-gamma*rij^m);
e=delta*unifrnd(-1,+1,VarSize);
newsol.Position = pop(i).Position ...
+ beta*rand(VarSize).*(pop(j).Position-pop(i).Position) ...
+ alpha*e;
newsol.Position=max(newsol.Position,VarMin);
newsol.Position=min(newsol.Position,VarMax);
newsol.Cost=CostFunction(newsol.Position);
if newsol.Cost <= newpop(i).Cost
newpop(i) = newsol;
if newpop(i).Cost<=BestSol.Cost
BestSol=newpop(i);
39
end
end
end
end
end
pop=[pop
newpop];
[~, SortOrder]=sort([pop.Cost]);
pop=pop(SortOrder);
pop=pop(1:nPop);
BestCost_Hybrid(it)=BestSol.Cost;
alpha = alpha*alpha_damp;
end
load('tic_toc.mat')
%% Results
figure;
plot(BestCost_Hybrid,'LineWidth',2);
semilogy(BestCost_Hybrid,'LineWidth',2);
title('Best Cost of Hybrid Firefly Algorithm')
xlabel('Iteration');
ylabel('Time');
figure;
plot(BestCost_Hybrid,'LineWidth',2);
title('Comparision od Best Cost between Hybrid and Firefly Algorithm')
semilogy(BestCost_Hybrid,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;
hold on
plot(BestCost,'LineWidth',2);
semilogy(BestCost,'LineWidth',2);
hold off
figure;
plot(tic_toc_firefly,'LineWidth',2);
title('Time Consumption of Firelfly Algorithm')
xlabel('Time');
ylabel('Iterations');
40
figure;
plot(tic_toc_hybrid_firefly,'LineWidth',2)
title('Time Consumption of Hybrid Firelfly Algorithm')
xlabel('Time');
ylabel('Iterations');
figure;
xlabel('Time');
ylabel('Iterations');
plot(tic_toc_firefly,'LineWidth',2)
title('Hybrid vs Firefly Algorithm Time consumption')
hold on
plot(tic_toc_hybrid_firefly,'LineWidth',2)
hold off
figure;
plot(ROC_Firefly,'LineWidth',2)
title('Region of Convergence of Firelfly Algorithm')
xlabel('ROC');
ylabel('Iterations');
figure;
plot(ROC_Hybrid,'LineWidth',2)
title('Region of Convergence of Firelfly Algorithm')
xlabel('ROC');
ylabel('Iterations');
figure;
xlabel('ROC');
ylabel('Iterations');
plot(ROC_Hybrid)
title('Hybrid vs Firefly Algorithm ROC Output')
hold on
plot(ROC_Firefly)
hold off
disp('The accuracy of the Firefly Algorithm is ')
disp(accuracy)
disp('The accuracy of the Hybrid Firefly Algorithm is ')
disp(accuracy_hy)
