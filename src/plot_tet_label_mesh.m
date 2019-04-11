function plot_tet_label_mesh(tetmesh)

col=repmat(['y','r','g','b','k','c','m'],1,50);
alph=[.2,ones(1,100)];
figure; hold on;
for kk=1:max(tetmesh.label)
    
    T1=tetmesh.faces(find(tetmesh.label==kk),:);%cut_volume(T,r(:,3)-mean(r(:,3)),0);
    S=get_surf_tet(T1);
    S=correct_orientation_tet(S,T1,tetmesh.vertices); p.faces=S;p.vertices=tetmesh.vertices;
    patch(p,'FaceColor',col(kk),'EdgeColor','none','facealpha',alph(kk),'facelighting','phong');axis equal;
end

   camlight; axis off;drawnow;
