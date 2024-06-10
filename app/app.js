'use strict';
const http = require('http');
var assert = require('assert');
const express= require('express');
const app = express();
const mustache = require('mustache');
const filesystem = require('fs');
const url = require('url');
const hostname = '127.0.0.1'
const port = 3000;

const hbase = require('hbase')
var hclient = hbase({ host: 'localhost', port: 8070, encoding: 'latin1'})

function rowToMap(row) {
    var stats = {};

    // Assuming row is an object with key, column, timestamp, and $ properties
    stats[row.column] = String(row['$']);

    return stats;
}


app.use(express.static('public'));
app.get('/ratings.html', function (req, res) {
    const year = parseInt(req.query['year'], 10);

    // Performing a scan on the HBase table
    hclient.table('josemaria_hbase_annual_top_10').scan({
        startRow: year + '1', // Assuming '0' is a valid rank, adjust as needed
        stopRow: (year + 1) + '0', // Assuming '0' is a valid rank, adjust as needed
    }, function (err, cells) {
        if (err) {
            console.error(err);
            res.status(500).send('Internal Server Error');
            return;
        }

        // Filtering results for the specific year
        const filteredResults = cells.filter(cell => {
            const rowKeyYear = parseInt(cell.key.substring(0, 4), 10);
            return rowKeyYear === year;
        });

        if (filteredResults.length === 0) {
            res.status(404).send('No data found for the specified year');
            return;
        }

        // Assuming you want to display data for a specific movie, you can choose the first result
        const movieInfo = rowToMap(filteredResults[0]);

        // Rendering HTML template
        var template = filesystem.readFileSync("result.mustache").toString();
        var html = mustache.render(template, {
            //year_rank: filteredResults[0].key,
            year: year,
            primarytitle: movieInfo['primarytitle'],
            genres: movieInfo['genres'],
            averagerating: movieInfo['averagerating'],
            numvotes: movieInfo['numvotes']
        });

        res.send(html);
    });
});

app.listen(port);