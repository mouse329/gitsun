var express = require('express');
var router = express.Router();
var sql = require('mssql');
var config = {
    user: 'sa',
    password: 'sa',
    server: 'localhost', // You can use 'localhost\\instance' to connect to named instance 
    database: 'SDMCenter',
    port: 1550,
       
     pool: {
        max: 20,
        min: 0,
        idleTimeoutMillis: 30000
    }
}
/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/classinfo', function(req, res, next) {
    var data = "";
    sql.connect(config).then(function() {
        new sql.Request()
        .execute('sp_MonthlyReport').then(function(recordsets) {
            console.dir(recordsets[0].length);
            var data = recordsets[0];
            res.render('classinfo', { title: 'classinfo', data: data });     
        }).catch(function(err) {
            //console.dir(err)
        });
    }).catch(function(err) {
        //console.dir(err)
    });
 
});

module.exports = router;
