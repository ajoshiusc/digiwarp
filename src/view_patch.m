function h=view_patch(FV1,newfig)
%function view_patch(FV)
%FV: a tessellation to view
%
%copywrite Dimitrios Pantazis, PhD student, USC

if ~exist('newfig','var')
    h=figure;
else
    if newfig~=0
        h=figure;
    end
end
%camlight
%lighting gouraud
axis equal
axis off   
axis vis3d
FV.vertices=FV1.vertices;FV.faces=FV1.faces;
nVertices = size(FV.vertices,1);
hpatch = patch(FV,'FaceColor','interp','EdgeColor','none','FaceVertexCData',ones(nVertices,3)*0.9,'faceAlpha',1); %plot surface        
lighting gouraud
material dull
set(gcf,'color','white'); light
