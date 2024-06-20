const router = require('express').Router();
const blogController = require("../controllers/BlogController")
const auth = require("../middlewares/AuthMiddleware");

router.post("/upload-blog", auth, blogController.uploadBlog)
router.get("/fetch-blogs", auth, blogController.fetchAllBlogs)


module.exports = router;