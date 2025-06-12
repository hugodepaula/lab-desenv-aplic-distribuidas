const express = require("express")

const app = express()
const port = process.env.PORT || 5050;

app.get("/", (req,res) => {
    res.send("\n<h1>Requisição tratada pelo Host </h1>\n<p>Host: " + req.hostname + "</p>\n<p>Original Url: " + req.originalUrl + "</p>\n")
    console.log("Requisição tratada pelo Host </h1>\n<p>Host: " + req.hostname + "</p>\n")
    console.log("<p>Url: " + req.url + "</p>\n")
})

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}...`)
})