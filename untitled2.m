figure;
figure_size = [ 0, 0, 800, 350];
set(gcf, 'Position', figure_size);
row = 1; % subplot行数
col = 3; % subplot列数
left_m = 0.05; % 左側余白の割合
bot_m = 0.1; % 下側余白の割合
ver_r = 1.1; % 縦方向余裕 (値が大きいほど各axes間の余白が大きくなる)
col_r = 1.2; % 横方向余裕 (値が大きいほど各axes間の余白が大きくなる)


   % Position は、各Axes に対し、 [左下(x), 左下(y) 幅, 高さ] を指定
   ax(1) = axes('Position',...
      [(1-left_m)*(mod(n-1,col))/col + left_m ,...
      (1-bot_m)*(1-ceil(n/col)/(row)) + bot_m ,...
      (1-left_m)/(col*col_r ),...
      (1-bot_m)/(row*ver_r)]...
      );
   % plotしたいものを書いてください***********
   plot(ax(1),1:500,randn(1,500));
   % *****************************************
%    legend(num2str(n))
%    ylim([-4 4])
%    if mod(n,col)==1
%       ylabel('ylabel')
%    else
%       yticklabels([])
%    end
%    if n>(row-1)*col
%       xlabel('xlabel')
%    else
%       xticklabels([])
%    end
   % font size==================
   h=gca;
   fontsize=8;
   set(h,'fontsize',fontsize)
   % ===========================
