no1 = 1;no2 = 8;
fontsz = 15;
subplot(2,2,1);
clr = hsv(10);
for i=11:20
    a = feature{no1,i}(:,2);
    a(abs(a) > 0.005) = [];
    plot(a,'color', clr(i-10,:));
    xlabel('line');ylabel('slope');title('Printer No.1 Slope');
    set(gca, 'fontsize', 15);
    hold on;
end
subplot(2,2,2);
for i=11:20
    a = feature{no2,i}(:,2);
    a(abs(a) > 0.005) = [];
    plot(a,'color', clr(i-10,:));
    xlabel('line');ylabel('slope');title('Printer No.2 Slope');
    set(gca, 'fontsize', 15);
    hold on;
end
subplot(2,2,3);
for i=11:20
    a = feature{no1,i}(2:end,1) - feature{no1,i}(1:end-1,1);
    a(abs(a-250) > 10) = [];
    plot(a,'color', clr(i-10,:));
    xlabel('line');ylabel('interval');title('Printer No.1 Interval');
    set(gca, 'fontsize', 15);
    hold on;
end
subplot(2,2,4);
for i=11:20
    a = feature{no2,i}(2:end,1) - feature{no2,i}(1:end-1,1);
    a(abs(a-250) > 10) = [];
    plot(a,'color', clr(i-10,:));
    xlabel('line');ylabel('interval');title('Printer No.2 Interval');
    set(gca, 'fontsize', 15);
    hold on;
end