function Tracking_performance(Sys, Tar, Filter_1, Filter_2)

%% Define the mark type and color
all_marks = {'o','+','h','x','^','s','d','v','*','>','<','p','h'};
all_legend = {'PF','GPF','AKKF-linear','AKKF-Quadratic','AKKF-Quartic','AKKF-Gaussian'};

color_M = [0, 0.4470, 0.741;
    0.8500, 0.3250, 0.0980
    0.4660, 0.6740, 0.1880
    0.88, 0.24, 0.65
    0, 47/255, 164/255
    0.16, 0.56, 0.16
    0.9290, 0.6940, 0.1250 ];

%% Tracking performance
figure('Renderer', 'painters', 'Position', [50 200 1200 700]); hold on;box on;

for n_plot = 1:2
    subplot(1,2,n_plot); hold on;box on
    set(gca,'linewidth',1.5)
    GridStyle.LineWidth = 0.9;
    ax.GridAlpha = 2;
    set(gca,'Fontsize',24)
    axis([-0.5,0.5,-1.5,1]);
    xlabel('X-axis');ylabel('Y-axis');

    h1 = plot(0,0,'r*', 'MarkerSize',14,'LineWidth',2);
    h2 = plot(Tar.X(1,:),Tar.X(3,:),'k+-','MarkerSize',10, 'LineWidth',3);
    h3 = plot(Tar.X(1,1),Tar.X(3,1),'r+', 'MarkerSize',20,'LineWidth',2);

    if n_plot == 1
        h4 = plot(Filter_1.X_est(1,:),Filter_1.X_est(3,:),'Marker',...
            all_marks{1},'MarkerSize',10,'LineWidth',2,'Color',color_M(1,:));
        %plot(Filter_1.X_P_proposal(1,:,1),Filter_1.X_P_proposal(3,:,1),'y.',...
        %    'MarkerSize',20);
        
        
        legend('Observer','Ground truth','Start point','AKKF');
    else
        h5 = plot(Filter_2.X_est(1,:),Filter_2.X_est(3,:),'Marker',...
            all_marks{3},'MarkerSize',10,'LineWidth',2,'Color',color_M(3,:));
        legend('Observer','Ground truth','Start point','PF');

    end

end



end


