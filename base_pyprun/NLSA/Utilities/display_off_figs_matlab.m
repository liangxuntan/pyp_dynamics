% % example-1
a=1:4;
f = figure('visible','off');
plot(a)
saveas(f,'newout','fig')

openfig('newout.fig','new','visible')



% % example-1
f = figure('visible', 'off');
surf(peaks);
print -djpeg test.jpg
close(f)