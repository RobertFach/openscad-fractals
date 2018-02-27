module fractalSurface(size=100, resolution=10, height=1, cx=-0.4, cy=0.6, max_iteration=1000) {

    steps = resolution;
    zrange = height;

    function zscaling(val,max_iteration) = val/max_iteration*zrange;

    function calc(zx,zy,iteration,cx,cy) = iteration >= max_iteration ? 0 :
    (zx*zx+zy*zy<4 ? calc(zx*zx-zy*zy + cx, 2*zx*zy + cy, iteration+1,cx,cy) :
    iteration);

    function listcalc1(x,y,cx,cy) = let (zx = 3/size*x-3/2, zy=3/size*y-3/2,
    iteration=0,val = calc(zx,zy,iteration,cx,cy))
    [x/steps,y/steps,zscaling(val,max_iteration)];

    function quad(i) = [i,i+1,i+size+2,i+size+1];

    function quadf(p,i,threshold) = (p[i][2]>=threshold || p[i+1][2]>=threshold ||
    p[i+size+2][2]>=threshold || p[i+size+1]>=threshold) ? [i,i+1,i+size+2,i+size+1] : [];

    // calculates the z value for all points
    points1 = [ for (x=[0:size])for(y=[0:size]) listcalc1(x,y,-0.4,0.6) ];
    // calculates a list of quads out of all points
    faces1 = [ for (x=[0:size-1],y=[0:size-1]) quadf(points1,x*size+x+y,0) ];


    //add a cube to the fractal surface
    union() {
        polyhedron(points1, faces1);
        cube([size/steps,size/steps,0.01]);
    }

}

//fractalSurface(size=200);