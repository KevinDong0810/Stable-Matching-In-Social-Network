% plot the result figure
clear
clc
load('MatchingResult.mat');
n = unidrnd(100);
figure(n);
hold on 
set(gca, 'fontsize',9);
plot(D,accuracy_n,'-bo','LineWidth',2,'MarkerSize',8);
plot(D,accuracy_classical_n,':bo','LineWidth',2,'MarkerSize',8);
plot(D,accuracy,'-r>','LineWidth',2,'MarkerSize',8);
plot(D,accuracy_classical,':r>','LineWidth',2,'MarkerSize',8);
legend('one-to-many with Network','one-to-many without Network','one-to-one with Network','one-to-one without Network' );
xlabel('Maximum Depth D', 'fontsize', 15);
ylabel('Accuracy Rate','fontsize', 15);
set(gca, 'GridLineStyle' ,':');  
set(gca,'XGrid','on');
set(gca,'YGrid','on');
axis([1 10 0 1]);
set(gca,'XTick',1:1:10);
set(gca,'YTick',0:0.1:1);