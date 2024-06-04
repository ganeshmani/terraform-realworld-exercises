const express = require("express");

const app = express();

app.get("/", (req, res) => {
  res.send("Hello World!!!.Welcome to NodeJS AWS EC2 Instance!!");
});

const PORT = process.env.PORT || 4500;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
