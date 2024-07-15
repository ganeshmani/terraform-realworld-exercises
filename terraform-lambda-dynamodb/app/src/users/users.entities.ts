import { z } from "zod";

export const userSchema = z.object({
  userId: z.string(),
  name: z.string(),
  email: z.string().email(),
});

export type User = z.infer<typeof userSchema>;
