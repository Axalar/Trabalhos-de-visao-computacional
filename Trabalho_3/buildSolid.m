function [V,F] = buildSolid(type, l, varargin)

opt.rotX = 0;
opt.rotY = 0;
opt.rotZ = 0;
opt.trans = [0,0,0];
opt = tb_optparse(opt, varargin);

[V,F] = platonic_solid(type, l);

V = V';

rot = rotx(opt.rotX);
V = rot*V;

rot = roty(opt.rotY);
V = rot*V;

rot = rotz(opt.rotZ);
V = rot*V;

V = V + repmat(opt.trans', 1, size(V,2));

V = [V; ones(1, size(V,2))];

end