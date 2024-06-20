const express = require("express");
const http = require("http");
const cors = require("cors");
const dotenv = require("dotenv");
const mongoose = require("mongoose");
const authRouter = require("./routes/AuthRoute");
const blogRouter = require("./routes/BlogRoute");

const uri = "mongodb+srv://jinseianime879:HUTCjsEmz33gT6pb@cluster0.qoxi4sz.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

mongoose.connect(uri).then(() => {
    console.log("Connected to MongoDB Database");
}).catch((err) => console.error('Error connecting to MongoDB:', err))

dotenv.config();

const app = express();
const PORT = process.env.PORT | 3001;

var server = http.createServer(app);
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(authRouter);
app.use(blogRouter);

server.listen(PORT, "0.0.0.0", async () => {
    console.log(`connected listened at ${process.env.PORT}`);
});
