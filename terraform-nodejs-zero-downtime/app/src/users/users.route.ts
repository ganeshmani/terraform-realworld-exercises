import { Request, Response, Router } from "express";
import { createUser, getUser } from "./users.controller";

const router = Router();

router.get("/:id", async (req: Request, res: Response) => {
  const userId = req.params.id;
  const user = await getUser(userId);

  res.send(user);
});

router.post("/", async (req: Request, res: Response) => {
  // zod schema validation
  const body = req.body;

  const user = await createUser(body);

  res.send(user);
});

export default router;
