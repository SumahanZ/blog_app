const Blog = require("../models/BlogModel")
const mongoose = require('mongoose');

module.exports = {
    uploadBlog: async (req, res) => {
        const session = await mongoose.startSession();
        session.startTransaction();

        const { title, content, imageUrl, topics, authorId } = req.body;

        try {
            const createdBlog = await Blog.create({
                title: title,
                content: content,
                imageUrl: imageUrl,
                topics: topics,
                authorId: authorId,
            })

            const { __v, updatedAt, ...others } = createdBlog._doc;

            await session.commitTransaction();
            session.endSession();

            return res.status(201).json({ ...others });

        } catch (error) {
            await session.abortTransaction();
            session.endSession();
            return res.status(500).json({
                "message": error.message
            });
        }
    },

    fetchAllBlogs: async (req, res) => {
        const session = await mongoose.startSession();
        session.startTransaction();

        try {
            const foundBlogs = await Blog.find().populate("authorId");

            const mappedBlogs = foundBlogs.map(blog => {
                const { __v, ...others } = blog._doc;
                const { _id, username, email } = others.authorId;
                others.authorId = _id;
                return { ...others, username, email };
            });

            await session.commitTransaction();
            session.endSession();

            return res.status(201).json(mappedBlogs);

        } catch (error) {
            console.log(error)
            await session.abortTransaction();
            session.endSession();
            return res.status(500).json({
                "message": error.message
            });
        }
    },
}


