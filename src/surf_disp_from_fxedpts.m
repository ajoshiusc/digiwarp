%||AUM||
%||Shree Ganeshaya Namaha||

function def=surf_disp_from_fxedpts(surf,fxedpts,disp_fxedpts)

L=loreta(surf);
b1=L(:,fxedpts)*disp_fxedpts(:,1);
b2=L(:,fxedpts)*disp_fxedpts(:,2);
b3=L(:,fxedpts)*disp_fxedpts(:,3);

freepts=1:length(L);
freepts(fxedpts)=[];
L=L(:,freepts);

K=L'*L;
M=(diag(K)+eps);

x=mypcg(K,-L'*b1,1e-232,30000,M);
y=mypcg(K,-L'*b2,1e-232,30000,M);
z=mypcg(K,-L'*b3,1e-232,30000,M);

def(fxedpts,:)=disp_fxedpts;
def(freepts,:)=[x,y,z];

