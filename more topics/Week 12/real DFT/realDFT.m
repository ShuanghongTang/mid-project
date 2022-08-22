%% 'Real' DFT
% real-valued version of the DFT

%% Start

clear
printme = @(figname) print('-dpdf', sprintf('figures/realDFT_%s', figname));

%% DFT

N = 8;
F = dftmtx(N);


t = linspace(0,1,100);
figure(1)
clf
for k = 0:N-1
    subplot(N,2,2*k+1);
    if k <= N/2
        c = cos(2*pi*k*t);
    else
        c = cos(2*pi*(N-k)*t);
    end
    plot(t*N, c, 'color', [1 1 1]*0.6)
    hold on
    h = stem(0:N-1, real(F(k+1,:)),'.','k', 'markersize',9);
    xlim([-0.5 N])
    ylim([-1 1]*1.3)
    box off
    set(gca,'fontsize',6)
    set(gca,'ytick', [-1 0 1])
    set(gca,'xtick', 0:N-1)
    ylabel(sprintf('%d', k),'rotation',0)
    
    subplot(N,2,2*k+2);
    if k <= N/2
        s = -sin(2*pi*k*t);
    else
        s = sin(2*pi*(N-k)*t);
    end
    plot(t*N, s, 'color', [1 1 1]*0.6)
    hold on
    stem(0:N-1, imag(F(k+1,:)),'.','k', 'markersize',9);
    xlim([-0.5 N])
    ylim([-1 1]*1.3)
    set(gca,'xtick', 0:N-1)
    box off
    set(gca,'fontsize',6)
    set(gca,'ytick', [-1 0 1])
end
subplot(N,2,1)
title('Real part')
subplot(N,2,2)
title('Imaginary part')
orient tall
printme('complex_DFT_basis')


%% Real DFT

N = 8;
F = dftmtx(N);
R = zeros(N);
R(1,:) = F(1,:);
R(N,:) = F(N/2+1,:);
for k = 2:N/2
    R(2*k-2,:) = sqrt(2)*real(F(k,:));
    R(2*k-1,:) = sqrt(2)*imag(F(k,:));
end

err = R'*R - N*eye(N);
max(abs(err(:)))



figure(2)
clf
for k = 1:N
    subplot(N,2,2*k-1)
    if mod(k,2) == 0
        r = sqrt(2)*cos(2*pi*(k)/2*t);
        if k == N, r = r/sqrt(2); end
    else
        r = -sqrt(2)*sin(2*pi*(k-1)/2*t);
        if k == N, r = r/sqrt(2); end
        if k == 1, r = ones(size(t)); end
    end
    plot(t*N, r, 'color', [1 1 1]*0.6)
    hold on
    stem(0:N-1, R(k,:),'.','k', 'markersize',9);
    xlim([-0.5 N])
    set(gca,'xtick', 0:N-1)
    box off
    ylim([-1 1]*2.3)
    if (k==1) | (k==N);
        ylim([-1 1]*1.3)
    else
        ylim([-1 1]*1.3*sqrt(2))
    end
    set(gca,'fontsize',6)
    if (k == 1) || (k == N)
        set(gca,'ytick', [-1 0 1])
    else
        set(gca,'ytick', [-2 0 2])
    end
    ylabel(sprintf('%d', k-1),'rotation',0)
end


orient tall
printme('real_DFT_basis')

