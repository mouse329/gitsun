var express = require('express');
var router = express.Router();
var sql = require('mssql');
var config = {
    user: 'sa',
    password: 'sa',
    server: 'localhost', // You can use 'localhost\\instance' to connect to named instance 
    database: 'SDMCenter',
    port: 1552,
       
    pool: {
        max: 50,
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
            var data = recordsets[0]
            res.render('classinfo', { title: 'classinfo', data: data })   
        }).catch(function(err) {
            //console.dir(err)
        });
    }).catch(function(err) {
        //console.dir(err)
    });
 
});

router.post('/meminfo', function(req, res, next){
    var data = "";
    var name = req.body.name;
    sql.connect(config).then(function() {
        new sql.Request()
        .input('NAME', sql.NVarChar, name)
        .execute('sp_member').then(function(recordsets) {
            var data = recordsets[0]
            //console.dir(recordsets[0])
            //console.dir('req.body.name = '+name)
            res.render('meminfo', { title: name, data: data })
            res.redirect('/meminfo')
        }).catch(function(err) {
            //err
        });
    }).catch(function(err) {
        //err
    });
});

router.get('/cadreinfo', function(req, res, next) {
    var data = "";
    sql.connect(config).then(function() {
        new sql.Request()
        .execute('proc_CadreList').then(function(recordsets) {
            var data = recordsets[0]
            //console.dir(recordsets[0])
            res.render('cadreinfo', { title: 'cadreinfo', data: data })   
        }).catch(function(err) {
            console.dir(err)
        });
    }).catch(function(err) {
        console.dir(err)
    });
 
});

module.exports = router;
