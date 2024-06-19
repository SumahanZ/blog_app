//so we can access the schema methods
const User = require("../models/UserModel")
const cryptojs = require("crypto-js")
const jwt = require("jsonwebtoken")
const mongoose = require('mongoose');

module.exports = {
    signupUser: async (req, res) => {
        const session = await mongoose.startSession();
        session.startTransaction();

        try {
            const userFound = await User.findOne({
                email: req.body.email,
            }).session(session);

            if (userFound) {
                await session.abortTransaction();
                session.endSession();
                return res.status(400).json({ "message": "User with this email already exists" });
            }

            const user = await User.create([{
                username: req.body.username,
                email: req.body.email,
                password: cryptojs.AES.encrypt(req.body.password, process.env.SECRET).toString(),
            }], { session });

            const userToken = jwt.sign(
                {
                    id: user[0]._id
                },
                process.env.JWT_SECRET,
                { expiresIn: "21d" }
            );

            const { password, __v, updatedAt, createdAt, ...others } = user[0]._doc;

            await session.commitTransaction();
            session.endSession();

            return res.status(201).json({ ...others, token: userToken });

        } catch (error) {
            await session.abortTransaction();
            session.endSession();
            return res.status(500).json({
                "message": error.message
            });
        }
    },

    getUser: async (req, res) => {
        try {
            const decodedToken = jwt.verify(req.body.token, process.env.JWT_SECRET);

            if (!decodedToken) {
                return res.status(400).json({ "message": "Token is not valid" })
            }

            const userFound = await User.findById(decodedToken.id);
            return res.status(201).json({ ...userFound._doc })
        } catch (error) {
            return res.status(500).json({
                "message": error
            })
        }
    },

    loginUser: async (req, res) => {
        const session = await mongoose.startSession();
        session.startTransaction();

        try {
            const userFound = await User.findOne({
                email: req.body.email,
            }).session(session);

            const decryptedPassword = cryptojs.AES.decrypt(userFound.password, process.env.SECRET).toString(cryptojs.enc.Utf8)

            if (!userFound) {
                await session.abortTransaction();
                session.endSession();
                return res.status(400).json({ "message": "User not found" })
            }

            if (decryptedPassword != req.body.password) {
                await session.abortTransaction();
                session.endSession();
                return res.status(400).json({ "message": "Password doesn't match" })
            }

            const userToken = jwt.sign(
                {
                    id: userFound._id
                }, process.env.JWT_SECRET, { expiresIn: "21d" })

            const { password, __v, updatedAt, createdAt, ...others } = userFound._doc
            await session.commitTransaction();
            session.endSession();

            return res.status(201).json({ ...others, token: userToken })
        } catch (error) {
            await session.abortTransaction();
            session.endSession();
            return res.status(500).json({
                "message": error
            })
        }
    },
}


