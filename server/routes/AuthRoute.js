const router = require('express').Router();
const authController = require("../controllers/AuthController")
//the end points of the routes
router.post("/register", authController.signupUser)
router.post("/login", authController.loginUser)
router.get("/get-user", authController.getUser)

module.exports = router;