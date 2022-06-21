/**
 * DApp Game 
 * @author Raed S. Rasheed
 * 
**/

// we use ethers.js which is a library for interacting with the Ethereum Blockchain and its ecosystem
// also we use express js to work with 

const ethers = require('ethers');
const express = require('express');
var bodyParser = require('body-parser')
const crypto = require('crypto');
const dotenv = require('dotenv').config()


const app = express();
app.use(bodyParser.urlencoded({extended : true}));
app.use(bodyParser.json());

// set public folder
app.use(express.static('public'));

// parse requests of content-type - application/json
app.use(express.json());

var myHash256 = crypto.createHash('sha256').update("Raed Rasheed").digest('hex');
console.log("This is 'Raed Rasheed' hash256: '" + myHash256);

require("./app/routes/game.routes.js")(app);


// set port, listen for requests
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});
