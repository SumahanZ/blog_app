const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
    username: String,
    email: String,
    password: String,
});

const userModel = mongoose.model("User", userSchema);

//export schema as a model to use
module.exports = userModel;