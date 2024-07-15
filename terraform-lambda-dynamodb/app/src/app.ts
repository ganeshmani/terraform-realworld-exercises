import express from "express";
import { Request, Response, Router } from "express";
import routes from "./users/users.route";

const app = express();

app.use(express.json());

app.get("/", async (req: Request, res: Response) => {
  res.send("Hello World");
});

app.use("/user", routes);

app.use(
  (req: express.Request, res: express.Response, next: express.NextFunction) => {
    res.status(404).send();
  }
);

app.use(
  (
    err: any,
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ) => {
    res.status(err.status || 500).send();
  }
);

export default app;
