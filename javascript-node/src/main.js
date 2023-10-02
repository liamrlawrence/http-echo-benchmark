const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const PORT = 2000;


app.use(bodyParser.json());


app.post('/api/echo', (req, res) => {
   res.json(req.body);
});


app.listen(PORT, () => {
   console.log(`Server is running on http://0.0.0.0:${PORT}`);
});

