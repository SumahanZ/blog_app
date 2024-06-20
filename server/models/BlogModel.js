const mongoose = require("mongoose");
const { Schema } = mongoose;

const blogSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true,
    },
    content: {
        type: String,
        required: true,
    },
    imageUrl: String,
    topics: {
        type: Array
    },
    authorId: {
        type: Schema.Types.ObjectId, ref: "User", required: true
    }
}, { timestamps: true });

const blogModel = mongoose.model("Blog", blogSchema);

//export schema as a model to use
module.exports = blogModel;