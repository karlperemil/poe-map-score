var dropData = ["n",12,1,"n",8,1,"n",8,1,"n",7,2,"n",6,0,"m",5,4,"m",14,11,"m",7,7,"n",7,1,"r",1,3,"n",6,0,"m",10,11,"m",7,6,"n",9,2,"r",1,3,"m",13,9,"m",6,7,"n",4,0,"r",1,3,"m",9,12,"n",12,0,"r",1,2,"m",12,9,"r",1,2,"n",9,1,"r",1,2,"n",5,0,"n",5,1,"r",1,2,"n",6,0,"m",12,11,"r",1,3,"m",10,13,"n",10,1,"r",1,2,"n",8,0,"m",7,0,"r",1,2,"n",3,0,"n",7,1,"n",7,0,"r",1,2,"m",6,8,"n",4,1,"n",4,1,"n",10,0,"r",1,1,"n",4,0,"n",7,1,"n",6,2,"m",10,11,"n",3,0,"r",1,2,"n",7,0,"m",6,5,"n",10,2,"n",7,1,"r",1,2,"r",1,2,"m",12,11,"m",11,6,"n",3,0,"n",6,0,"n",8,1,"n",5,0,"n",7,1,"n",18,4,"n",5,1,"m",6,7,"n",7,0,"n",11,1,"r",1,3,"r",1,2,"n",10,1,"n",4,0,"m",8,8,"n",8,0,"r",1,2,"r",1,3,"n",11,2,"r",1,2,"m",3,3,"n",9,0,"n",7,0,"n",4,1,"r",1,2,"r",1,2,"n",14,2,"n",10,0,"n",11,1,"n",4,0,"r",1,2,"n",9,1,"r",1,2,"r",1,2,"r",1,2,"m",8,8,"n",10,2,"n",7,1,"m",13,13,"m",12,12,"n",6,2,"n",5,2,"n",10,0,"r",1,2];

var rare = {count: 0, drops: 0};
var magic = {count: 0, drops: 0};
var normal = {count: 0, drops: 0};
var drops = {}
drops["n"] = normal;
drops["m"] = magic;
drops["r"] = rare;
for(var i = 0; i < dropData.length; i+=3){
	var addTo = null;
	drops[dropData[i]].count += dropData[i+1];
	drops[dropData[i]].drops += dropData[i+2];
}

console.log(rare.drops/rare.count);
console.log(magic.drops/magic.count);
console.log(normal.drops/normal.count);
