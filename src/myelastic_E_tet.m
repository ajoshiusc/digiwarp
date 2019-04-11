%||AUM||
function K=myelastic_E_tet(tmesh,nu,E)

[Dx,Dy,Dz]=myget_tet_grad(tmesh);

Z=sparse(size(Dx,1),size(Dx,2));
L=[Dx,Z,Z;
    Z,Dy,Z;
    Z,Z,Dz;
    Dy,Dx,Z;
    Z,Dz,Dy;
    Dz,Z,Dx];

n=1-nu; n1=(1-2*nu)/2;
WL=[n*Dx,nu*Dy,nu*Dz;
    nu*Dx,n*Dy,nu*Dz;
    nu*Dx,nu*Dy,n*Dz;
    n1*Dy,n1*Dx,Z;
    Z,n1*Dz,n1*Dy;
    n1*Dz,Z,n1*Dx];


K=(E/(1+nu)*(1-2*nu))*L'*WL;

