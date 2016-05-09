function plotpca(norm,abnorm,d1,d2,d3)
plot3(norm(:,d1),norm(:,d2),norm(:,d3),'go', ...
    abnorm(:,d1),abnorm(:,d2),abnorm(:,d3),'ro')
end % function