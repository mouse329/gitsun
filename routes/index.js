var express = require('express');
var router = express.Router();
var sql = require('mssql');
var config = require('config');

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/pplcount', function(req, res, next){
    res.render('pplcount', { title: 'pplcount' });
     
});

router.get('/classinfo', function(req, res, next) {
    var data = "";
    sql.connect(config).then(function() {
        new sql.Request()
        .execute('sp_ClassInfo').then(function(recordsets) {
            var data = recordsets[0]
            res.render('classinfo', { title: 'classinfo', data: data })   
        }).catch(function(err) {
            //console.dir(err)
        });
    }).catch(function(err) {
        //console.dir(err)
    });
});

router.get('/classinfo', function(req, res, next) {
    var data = "";
    sql.connect(config).then(function() {
        new sql.Request()
        .execute('sp_ClassInfo').then(function(recordsets) {
            var data = recordsets[0]
            res.render('classinfo', { title: 'classinfo', data: data })   
        }).catch(function(err) {
            //console.dir(err)
        });
    }).catch(function(err) {
        //console.dir(err)
    });
});

router.get('/stuinfo', function(req, res, next) {
    var data = "";
    sql.connect(config).then(function() {
        new sql.Request()
        .execute('sp_StuInfo').then(function(recordsets) {
            var data = recordsets[0]
            res.render('stuinfo', { title: 'stuinfo', data: data })   
        }).catch(function(err) {
            //console.dir(err)
        });
    }).catch(function(err) {
        //console.dir(err)
    });
});

// router.post('/stuinfo', function(req, res, next){
//     var data = "";
//     var name = req.body.name;
//     sql.connect(config).then(function() {
//         new sql.Request()
//         .input('NAME', sql.NVarChar, name)
//         .execute('sp_StuInfo').then(function(recordsets) {
//             var data = recordsets[0]
//             //console.dir(recordsets[0])
//             //console.dir('req.body.name = '+name)
//             res.render('stuinfo', { title: name, data: data })
//             res.redirect('/stuinfo')
//         }).catch(function(err) {
//             //err
//         });
//     }).catch(function(err) {
//         //err
//     });
// });

router.get('/cadreinfo', function(req, res, next) {
    var data = "";
    sql.connect(config).then(function() {
        new sql.Request()
        .execute('sp_CadreInfo').then(function(recordsets) {
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
