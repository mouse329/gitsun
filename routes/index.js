var express = require('express');
var router = express.Router();
var sql = require('mssql');
var config = require('config');

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/pplcount', function(req, res, next){
    res.render('pplcount', { title: '班級人數統計' });
     
});

router.get('/classinfo', function(req, res, next) {
    var data = "";
    sql.connect(config).then(function() {
        new sql.Request()
        .execute('sp_ClassInfo').then(function(recordsets) {
            var data = recordsets[0]
            res.render('classinfo', { title: '班級資訊', data: data })   
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
            res.render('stuinfo', { title: '學員查詢', data: data })   
        }).catch(function(err) {
            //console.dir(err)
        });
    }).catch(function(err) {
        //console.dir(err)
    });
});

router.get('/cadreinfo', function(req, res, next) {
    var data = "";
    sql.connect(config).then(function() {
        new sql.Request()
        .execute('sp_CadreInfo').then(function(recordsets) {
            var data = recordsets[0]
            //console.dir(recordsets[0])
            res.render('cadreinfo', { title: '現任班幹部查詢', data: data })   
        }).catch(function(err) {
            console.dir(err)
        });
    }).catch(function(err) {
        console.dir(err)
    });
 
});

router.get('/stuexp', function(req, res, next) {
    var data = "";
    sql.connect(config).then(function() {
        new sql.Request()
        .execute('sp_StuExp').then(function(recordsets) {
            var data = recordsets[0]
            res.render('stuexp', { title: '學員學習經歷', data: data })   
        }).catch(function(err) {
            //console.dir(err)
        });
    }).catch(function(err) {
        //console.dir(err)
    });
});

router.get('/cadreexp', function(req, res, next) {
    var data = "";
    sql.connect(config).then(function() {
        new sql.Request()
        .execute('sp_CadreExp').then(function(recordsets) {
            var data = recordsets[0]
            //console.dir(recordsets[0])
            res.render('cadreexp', { title: '班幹部護持經歷', data: data })   
        }).catch(function(err) {
            console.dir(err)
        });
    }).catch(function(err) {
        console.dir(err)
    });
});

router.get('/cadretrn', function(req, res, next) {
    var data = "";
    sql.connect(config).then(function() {
        new sql.Request()
        .execute('sp_CadreTrn').then(function(recordsets) {
            var data = recordsets[0]
            //console.dir(recordsets[0])
            res.render('cadretrn', { title: '班培經歷', data: data })   
        }).catch(function(err) {
            console.dir(err)
        });
    }).catch(function(err) {
        console.dir(err)
    });
});

module.exports = router;
