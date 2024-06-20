const jwt = require("jsonwebtoken")
const User = require("../models/UserModel")

const auth = async (req, res, next) => {
    try {
        const token = req.header("Bearer-token");

        if (!token)
            return res.status(401).json({ error: "Token does not exist" });

        const decodedTokenData = jwt.verify(token, process.env.SECRET);

        if (!decodedTokenData)
            return res.status(401).json({ error: "Token does not match verification" });

        const existingUser = await User.findById(decodedTokenData.id);

        if (!existingUser) {
            return res.status(401).json({ error: "User with this specific id is not found" });
        }

        req.user = decodedTokenData.id;
        req.token = token;

        next();
    } catch (error) {
        return res.status(500).json({ error: error.message })
    }
}

module.exports = auth;
