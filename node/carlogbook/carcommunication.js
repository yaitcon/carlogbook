require('dotenv').config()
const BlueLinky = require('bluelinky');
const oracledb = require('oracledb');
const http = require('http');
const host = 'localhost';
const port = process.env.PORT;

params=function(req){
  let q=req.url.split('?'),result={};
  if(q.length>=2){
      q[1].split('&').forEach((item)=>{
           try {
             result[item.split('=')[0]]=item.split('=')[1];
           } catch (e) {
             result[item.split('=')[0]]='';
           }
      })
  }
  return result;
}

const requestListener = function(req, res) {

req.params=params(req);

const client = new BlueLinky({
  username: process.env.APPUSERNAME,
  password: process.env.APPPWD,
  brand: process.env.BRAND,
  region: process.env.REGION,
  pin: process.env.PIN
});

client.on('ready', async () => {

  const vehicle = client.getVehicle(process.env.FIN);

try {

switch (req.params.apiendpoint) {

case "status":
      res.writeHead(200);
      res.end(req.params.apiendpoint);
      console.log("get api infos status");
      var status = await vehicle.status({ parsed: false, refresh: true });
   // var odo = await vehicle.odometer();
   // if ((status.evStatus.batteryStatus > 0) && (odo.value > 0)) { var letsgo = 1; }
      if (status.evStatus.batteryStatus > 0) { var letsgo = 1; }
      break;

case "odo":
      res.writeHead(200);
      res.end(req.params.apiendpoint);
      console.log("get api infos odo");
      var status = await vehicle.odometer();
      if (status.value > 0) { var letsgo = 1; }
      break;

case "loc":
      res.writeHead(200);
      res.end(req.params.apiendpoint);
      console.log("get api infos loc");
      var status = await vehicle.location();
      var letsgo = 1;
      break;
      
case "monthlyreport":
    res.writeHead(200);
    res.end(req.params.apiendpoint);
    console.log("get api infos mr");
    var status = await vehicle.monthlyReport();
    var letsgo = 1;
    break;

case "drivehistory":
    res.writeHead(200);
    res.end(req.params.apiendpoint);
    console.log("get api infos dh");
    var status = await vehicle.driveHistory();
    var letsgo = 1;
    break;

case "stopcharge":
    res.writeHead(200);
    res.end(req.params.apiendpoint);
    console.log("send stop charge");
    var status = await vehicle.stopCharge();
    var letsgo = 1;
    break;

case "startcharge":
    res.writeHead(200);
    res.end(req.params.apiendpoint);
    console.log("send start charge");
    var status = await vehicle.startCharge();
    var letsgo = 1;
    break;

case "doorlock":
    res.writeHead(200);
    res.end(req.params.apiendpoint);
    console.log("set door lock");
    var status = await vehicle.lock();
    var letsgo = 1;
    break;

case "dooropen":
    res.writeHead(200);
    res.end(req.params.apiendpoint);
    console.log("set door open");
    var status = await vehicle.unlock();
    var letsgo = 1;
    break;

case "stopclimate":
    res.writeHead(200);
    res.end(req.params.apiendpoint);
    console.log("set climatestop");
    var status = await vehicle.stop();
    var letsgo = 1;
    break;

case "climate":
      res.writeHead(200);
      res.end(req.params.apiendpoint);
      console.log("set climate on");
      var status = await vehicle.start({
                                         airCtrl: false,
                                         igniOnDuration: 15, // req.params.duration
                                         airTempvalue: 70, // req.params.temp
                                         defrost: false,
                                         heating1: false
                                         });
       var letsgo = 1;
       break;
 
default:
     res.writeHead(404);
     res.end(JSON.stringify({error:"Resource not found"}));
}
 
     if (letsgo === 1) {
         try {
         let connection;
         connection = await oracledb.getConnection({ user: process.env.DBUSERNAME,
                                                     password: process.env.DBPWD,
                                                     connectionString: process.env.DBHOST });
         await connection.execute(`INSERT INTO eniro VALUES (systimestamp  at time zone 'CET' , :str, upper(:reqname))`,
                                 {     str: { type: oracledb.DB_TYPE_JSON, val: status } ,
                                   reqname: { type: oracledb.DB_TYPE_VARCHAR, val: req.params.apiendpoint} },{autoCommit: true});
     } catch (e){
         console.log(e.stack);
         process.exit();
     }
    } // if
 
 } catch (err) {
         let connection;
         connection = await oracledb.getConnection({ user: process.env.DBUSERNAME,
                                                     password: process.env.DBPWD,
                                                     connectionString: process.env.DBHOST });
         await connection.execute(`INSERT INTO eniro VALUES (systimestamp  at time zone 'CET' , '',upper('NO'|| :reqname))`,
                                 {  reqname: { type: oracledb.DB_TYPE_VARCHAR, val: req.params.apiendpoint} },{autoCommit: true});
   }
 });
 };
 
 const server = http.createServer(requestListener);
 server.listen(port, host, () => {
     console.log(`Server is running on http://${host}:${port}`);
 });
 